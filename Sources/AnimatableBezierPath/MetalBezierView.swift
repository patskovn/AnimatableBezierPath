// MIT License
//
// Copyright (c) 2016
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Metal
import MetalKit
import _BezierCHeaders

public class MetalBezierView: MTKView {
    
    /// This represents amount of triangles used to draw single bezier curve.
    /// By single it means not whole `BezierPath` struct, but single `BezierParameters`.
    /// The bigger value here the "smoother" the curve is
    private let trianglesPerBezierCurve: UInt32
    
    private var commandQueue: MTLCommandQueue?
    private var bezierPipelineDescriptor = MTLRenderPipelineDescriptor()
    private var circlePipelineDescriptor = MTLRenderPipelineDescriptor()

    /// Array of indices for triangles that we are manupulate to draw certain percent of whole curve
    private let indices: [UInt16]
    private let indicesBuffer: MTLBuffer?
    private var msaaColorTexture: MTLTexture?
    
    var params: BezierPath
    var animationPercent: Float = 0
    var colors: [simd_float4] {
        didSet {
            guard !colors.isEmpty else {
                fatalError("Bruh I really need colors here")
            }
        }
    }
    
    init(params: BezierPath, colors: [simd_float4], device: MTLDevice? = MTLCreateSystemDefaultDevice(), trianglesPerBezierCurve: UInt32 = 300) {
        guard !colors.isEmpty else {
            fatalError("Bruh I really need colors here")
        }
        
        self.params = params
        self.colors = colors
        self.trianglesPerBezierCurve = trianglesPerBezierCurve
        self.indices = stride(from: 0, to: UInt16(trianglesPerBezierCurve), by: 1).reduce(into: []) {
            $0 += [$1, $1 + 1, $1 + 2]
        }
        
        self.indicesBuffer = device?.makeBuffer(bytes: indices,
                                                length: MemoryLayout<UInt16>.size * indices.count,
                                                options: .storageModeShared)!
        
        super.init(frame: .zero, device: device)
        
        framebufferOnly = true
        colorPixelFormat = .bgra8Unorm
        clearColor = MTLClearColor(red: 0.0, green: 0, blue: 0, alpha: 0)
        preferredFramesPerSecond = 60
        
        // Run with 4x MSAA
        sampleCount = 4
        
        // Bloody API differences -_-
        #if canImport(AppKit)
        layer?.isOpaque = false
        #else
        layer.isOpaque = false
        #endif
        
        
        guard let device else { return }
        self.device = device
        commandQueue = device.makeCommandQueue()
        
        // We should use `.module` here, because this is distributed via swift package manager
        guard let library = try? device.makeDefaultLibrary(bundle: .module) else { return }
        initializeMetalPipeline(from: library)
    }
    
    
    /// Unpack & compile all shaders from the library
    private func initializeMetalPipeline(from library: MTLLibrary) {
        bezierPipelineDescriptor.vertexFunction = library.makeFunction(name: "bezier_vertex")
        bezierPipelineDescriptor.fragmentFunction = library.makeFunction(name: "bezier_fragment")
        bezierPipelineDescriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        
        // Run with 4x MSAA:
        bezierPipelineDescriptor.sampleCount = self.sampleCount
        bezierPipelineDescriptor.rasterSampleCount = self.sampleCount
        
        circlePipelineDescriptor.vertexFunction = library.makeFunction(name: "circle_vertex")
        circlePipelineDescriptor.fragmentFunction = library.makeFunction(name: "circle_fragment")
        circlePipelineDescriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        
        // Run with 4x MSAA:
        circlePipelineDescriptor.sampleCount =  sampleCount
        circlePipelineDescriptor.rasterSampleCount = sampleCount
    }
    
    required init(coder: NSCoder) {
        fatalError("Storyboards are for lamers")
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        msaaColorTexture = nil
    }
    
    /// Creates our custom texture that we will use for rendering.
    /// We need that because MTKView's own texture supports MSAA only for one render pipeline but we have two: circles and bezier path.
    /// So we creating our custom texture.
    private func makeMSAARenderTextureIfNeeded() {
        let drawableWidth = Int(drawableSize.width)
        let drawableHeight = Int(drawableSize.height)
        
        if msaaColorTexture == nil ||
            msaaColorTexture?.width != drawableWidth ||
            msaaColorTexture?.height != drawableHeight ||
            msaaColorTexture?.sampleCount != sampleCount
        {
            let textureDescriptor = MTLTextureDescriptor()
            textureDescriptor.textureType = .type2DMultisample
            textureDescriptor.sampleCount = sampleCount
            textureDescriptor.pixelFormat = colorPixelFormat
            textureDescriptor.width = drawableWidth
            textureDescriptor.height = drawableHeight
            textureDescriptor.storageMode = .private
            textureDescriptor.usage = .renderTarget
            
            msaaColorTexture = device?.makeTexture(descriptor: textureDescriptor)
            msaaColorTexture?.label = "MSAA x\(sampleCount) Color"
        }
    }
    
    private func renderPassDescriptor(colorTexture: MTLTexture) -> MTLRenderPassDescriptor {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        
        renderPassDescriptor.colorAttachments[0].texture = msaaColorTexture
        renderPassDescriptor.colorAttachments[0].resolveTexture = colorTexture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = clearColor
        renderPassDescriptor.colorAttachments[0].storeAction = .storeAndMultisampleResolve
        
        return renderPassDescriptor
    }


    public override func draw(_ rect: CGRect) {
        guard rect.size != .zero else { return }
        
        makeMSAARenderTextureIfNeeded()
        
        guard let commandBuffer = commandQueue?.makeCommandBuffer(),
              let currentDrawable
        else { return }
        
        let path = self.params
        let lineWidth: Float = path.normalizedLineWidth(viewSize: drawableSize)
        let bezierCurve = path.normalizedParameters(viewSize: drawableSize)
        
        var circles: [CircleVertex] = []
        if animationPercent.isZero {
            circles = []
        } else {
            circles = [
                CircleVertex(center: bezierCurve[0].a,
                             color: colors.first!,
                             radius: lineWidth / 2),
                CircleVertex(center: getClosingCircleCenter(animationPercent: animationPercent, vectors: bezierCurve),
                             color: getClosingCircleColor(animationPercent: animationPercent, gradientColors: colors),
                             radius: lineWidth / 2),
            ]
        }
        
        let bezierPassDescriptor = self.renderPassDescriptor(colorTexture: currentDrawable.texture)
        render(bezierCurve: bezierCurve, commandBuffer: commandBuffer, renderPassDescriptor: bezierPassDescriptor, colors: colors, lineWidth: lineWidth)
        
        let circlePassDescriptor = self.renderPassDescriptor(colorTexture: currentDrawable.texture)
        circlePassDescriptor.colorAttachments[0].loadAction = .load
        render(circles: circles, commandBuffer: commandBuffer, renderPassDescriptor: circlePassDescriptor)
        
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
    
    private func render(circles: [CircleVertex], commandBuffer: MTLCommandBuffer, renderPassDescriptor: MTLRenderPassDescriptor) {
        guard let device,
              !circles.isEmpty,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor),
              let pipelineState = try? device.makeRenderPipelineState(descriptor: circlePipelineDescriptor)
        else { return }
        
        var circles = circles
        let paramBuffer = device.makeBuffer(bytes: &circles, length: MemoryLayout<CircleVertex>.size * circles.count)
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(paramBuffer, offset: 0, index: 0)
        
        for i in stride(from: 0, to: 720, by: 1) {
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: i, vertexCount: 3, instanceCount: circles.count)
        }
        
        renderEncoder.endEncoding()
    }
    
    
    /// This method uses exactly the same algorithm that is inside the shader to determine proper circle position in canvas
    private func getClosingCircleCenter(animationPercent: Float, vectors: [BezierParameters]) -> simd_float2 {
        if animationPercent == 0 {
            return vectors[0].a
        }
        let chunkSize = 1 / Float(vectors.count)
        let vectorNumber = Int(ceil(animationPercent / chunkSize))
        
        let vector = vectors[vectorNumber - 1]
        let delta = animationPercent - Float(vectorNumber - 1) * chunkSize
        let t = delta / chunkSize
        let nt = 1 - t
        
        return pow(nt, 3) * vector.a + 3 * pow(nt, 2) * t * vector.p1 + 3 * nt * pow(t, 2) * vector.p2 + pow(t, 3) * vector.b
    }
    
    /// This method uses kinda the same algorithm that is inside the shader to determine proper circle color.
    /// It is a bit easier because we use `animationPercent` to determine color and don't need additional calculations
    private func getClosingCircleColor(animationPercent: Float, gradientColors: [simd_float4]) -> simd_float4 {
        guard animationPercent != 1 else {
            return gradientColors.last!
        }
        
        let colorT = animationPercent
        
        let stopLength = Float(gradientColors.count - 1)
        var colorValueRatio = colorT / (1 / stopLength)
        let bucket = Int(colorValueRatio)
        
        let startColor = gradientColors[bucket]
        let endColor = gradientColors[bucket + 1]
        
        colorValueRatio = colorValueRatio - floor(colorValueRatio)
        return startColor + colorValueRatio * (endColor - startColor)
    }
    
    private func render(bezierCurve: [BezierParameters], commandBuffer: MTLCommandBuffer, renderPassDescriptor: MTLRenderPassDescriptor, colors: [simd_float4], lineWidth: Float) {
        guard let device,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor),
              let pipelineState = try? device.makeRenderPipelineState(descriptor: bezierPipelineDescriptor),
              let indicesBuffer
        else { return }
        
        var bezierCurve = bezierCurve
        let paramBuffer = device.makeBuffer(bytes: &bezierCurve,
                                            length: MemoryLayout<BezierParameters>.size * bezierCurve.count,
                                            options: .storageModeShared)!
        
        var gradientColors: [simd_float4] = colors
        var globalParams = GlobalParameters(lineWidth: lineWidth,
                                            elementsPerInstance: trianglesPerBezierCurve,
                                            gradientStepsCount: UInt32(gradientColors.count),
                                            vectorsCount: UInt32(bezierCurve.count),
                                            filledPercent: animationPercent)
        
        let globalParamBuffer = device.makeBuffer(bytes: &globalParams,
                                                  length: MemoryLayout<GlobalParameters>.size,
                                                  options: .storageModeShared)
        let gradientColorsBuffer = device.makeBuffer(bytes: &gradientColors,
                                                     length: MemoryLayout<simd_float4>.size * gradientColors.count,
                                                     options: .storageModeShared)
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        renderEncoder.setVertexBuffer(paramBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(globalParamBuffer, offset: 0, index: 1)
        renderEncoder.setVertexBuffer(gradientColorsBuffer, offset: 0, index: 2)
        
        let totalAmountOfIndices = bezierCurve.count * indices.count
        
        for i in stride(from: 0, to: bezierCurve.count, by: 1) {
            let indicesCount = calculateIndicesCountToDraw(totalAmountOfIndices: totalAmountOfIndices,
                                                           animationPercent: animationPercent,
                                                           vertexIndex: i,
                                                           totalVerticesCount: bezierCurve.count)
            
            if indicesCount != 0 {
                renderEncoder.drawIndexedPrimitives(type: .triangle,
                                                    indexCount: indicesCount,
                                                    indexType: .uint16,
                                                    indexBuffer: indicesBuffer,
                                                    indexBufferOffset: 0,
                                                    instanceCount: 1,
                                                    baseVertex: 0,
                                                    baseInstance: i)
            }
        }
        
        
        renderEncoder.endEncoding()
    }
    
    private func calculateIndicesCountToDraw(totalAmountOfIndices: Int, animationPercent: Float, vertexIndex: Int, totalVerticesCount: Int) -> Int {
        let totalAmountOfIndices = Float(totalAmountOfIndices)
        let totalVerticesCount = Float(totalVerticesCount)
        
        let totalDrawnVerticesOnThatStep = (vertexIndex + 1) * indices.count
        
        let currentPercentage = Float(totalDrawnVerticesOnThatStep) / totalAmountOfIndices
        guard currentPercentage > animationPercent else {
            return indices.count
        }

        let percentDiff = currentPercentage - animationPercent
        if percentDiff > 1 / totalVerticesCount {
            return 0
        } else {
            // In theory we will always have value <= indices.count, but it is worth to check and play safe
            return min(indices.count, Int(ceil((1 / totalVerticesCount - percentDiff) * totalAmountOfIndices)))
        }
    }
}
