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
public typealias NativeColor = UIColor
#elseif canImport(AppKit)
import AppKit
public typealias NativeColor = NSColor
#endif

public struct BezierColor {
    let value: simd_float4
    
    public init(_ value: simd_float4) {
        self.value = value
    }
    
    public init(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        self.init(.init(r, g, b, a))
    }
    
    public init(_ nativeColor: NativeColor) {
        let (r, g, b, a) = nativeColor.components
        self.init(.init(r, g, b, a))
    }
    
    @available(iOS 14.0, macOS 10.16, *)
    public init(_ swiftUIColor: Color) {
        self.init(NativeColor(swiftUIColor))
    }
}

extension NativeColor {
    var components: (red: Float, green: Float, blue: Float, opacity: Float) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        
        self.getRed(&r, green: &g, blue: &b, alpha: &o)
        
        return (Float(r), Float(g), Float(b), Float(o))
    }
}
