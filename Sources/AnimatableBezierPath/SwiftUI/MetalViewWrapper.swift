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

import SwiftUI
import simd

#if canImport(UIKit)

import UIKit

public struct MetalViewMapper: UIViewRepresentable {
    private let animationPercent: Float
    private let path: BezierPath
    private let colors: [simd_float4]
    
    public init(animationPercent: Float, path: BezierPath, colors: [BezierColor]) {
        self.animationPercent = animationPercent
        self.path = path
        self.colors = colors.map(\.value)
    }
    
    public func makeUIView(context: Context) -> MetalBezierView {
        let view = MetalBezierView(params: helloBezierPath, colors: colors)
        view.animationPercent = animationPercent
        return view
    }
    
    public func updateUIView(_ view: MetalBezierView, context: Context) {
        view.animationPercent = animationPercent
        view.params = path
        view.colors = colors
    }
}

#elseif canImport(AppKit)

import AppKit

public struct MetalViewMapper: NSViewRepresentable {
    private let animationPercent: Float
    private let path: BezierPath
    private let colors: [simd_float4]
    
    public init(animationPercent: Float, path: BezierPath, colors: [BezierColor]) {
        self.animationPercent = animationPercent
        self.path = path
        self.colors = colors.map(\.value)
    }
    
    public func makeNSView(context: Context) -> MetalBezierView {
        let view = MetalBezierView(params: helloBezierPath, colors: colors)
        view.animationPercent = animationPercent
        return view
    }
    
    public func updateNSView(_ view: MetalBezierView, context: Context) {
        view.animationPercent = animationPercent
        view.params = path
        view.colors = colors
    }
}


#endif
