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

#if canImport(UIKit)
import UIKit
let defaultScale = UIScreen.main.scale
#elseif canImport(AppKit)
import AppKit
let defaultScale = NSScreen.main?.backingScaleFactor ?? 1
#endif

import _BezierCHeaders

public struct BezierPath {
    public var parameters: [BezierParameters]
    
    private let scale: Float
    private let viewBox: CGSize
    private let lineWidth: CGFloat
    
    private var startingPoint: CGPoint?
    
    /// Creates bezier path according to parameters. Usually you should provide empty parameters and use `addCurve` api to fill it in.
    /// - Parameters:
    ///   - parameters: Array of bezier parameters to draw. For ideal picture this should be a single curve with mirrored control point on the vertices points.
    ///   - scale: Scale of the screen
    ///   - viewBox: Size for bounding box of a curve
    ///   - lineWidth: This one is self-explanatory
    init(parameters: [BezierParameters] = [], scale: Float = Float(defaultScale), viewBox: CGSize, lineWidth: CGFloat) {
        self.parameters = parameters
        self.scale = scale
        self.viewBox = viewBox
        self.lineWidth = lineWidth
    }
    
    func normalizedLineWidth(viewSize: CGSize) -> Float {
        Float(lineWidth / viewSize.width)
    }
    
    func normalizedParameters(viewSize: CGSize) -> [BezierParameters] {
        let viewBox = simd_float2(Float(self.viewBox.width), Float(self.viewBox.height))
        let viewSize = simd_float2(Float(viewSize.width), Float(viewSize.height))
        let shift = simd_float2(abs(viewSize.x - viewBox.x * scale) / 2, abs(viewSize.y - viewBox.y * scale) / 2) / viewSize
        
        func toMetal(_ v: simd_float2) -> simd_float2 {
            .init((2 * v.x) - 1, (v.y * -2) + 1) * 0.9
        }
        
        return parameters
            .map { BezierParameters(a: $0.a / viewSize * scale + shift, b: $0.b / viewSize * scale + shift, p1: $0.p1 / viewSize * scale + shift, p2: $0.p2 / viewSize * scale + shift) }
            .map { BezierParameters(a: toMetal($0.a), b: toMetal($0.b), p1: toMetal($0.p1), p2: toMetal($0.p2)) }
    }
    
    /// You may use that method but ideally you shouldn't. Prefer `addCurve` API
    public mutating func move(to point: CGPoint) {
        if let last = parameters.last {
            parameters.append(BezierParameters(a: last.b, b: point.f2, p1: 2 * last.b - last.p2, p2: (last.b + point.f2) / 2))
        } else {
            startingPoint = point
        }
    }
    
    public mutating func addCurve(to b: CGPoint, controlPoint1 p1: CGPoint, controlPoint2 p2: CGPoint) {
        if let last = parameters.last {
            parameters.append(BezierParameters(a: last.b, b: b.f2, p1: p1.f2, p2: p2.f2))
        } else if let a = startingPoint {
            parameters.append(BezierParameters(a: a.f2, b: b.f2, p1: p1.f2, p2: p2.f2))
        }
    }
    
    /// This method mirrors last connection control point to achieve smooth connection.
    public mutating func normalizeLastConnection() {
        guard parameters.count > 2 else { return }
        parameters[parameters.count - 1].p1 = 2 * parameters[parameters.count - 2].b - parameters[parameters.count - 2].p2
    }
}

private extension CGPoint {
    var f2: simd_float2 {
        .init(Float(x), Float(y))
    }
}
