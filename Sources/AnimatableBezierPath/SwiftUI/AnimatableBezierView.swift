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

public struct AnimatableBezierView: View {
    
    private let path: BezierPath
    private let colors: [BezierColor]
    private let animationPercent: Float
    
    public init(path: BezierPath, colors: [BezierColor], animationPercent: Float = 1) {
        self.path = path
        self.colors = colors
        self.animationPercent = animationPercent
    }
    
    public var body: some View {
        Color.clear
            .modifier(AnimatableMetalViewModifier(animationPercent: animationPercent, path: path, colors: colors))
    }
}

// AnimatableModifier is deprecated. But combination of Modifier+Animatable doesn't work for modifiers outside of module.
// So we have to stick to deprecated protocol to make animation work for library users.
public struct AnimatableMetalViewModifier: AnimatableModifier {
    
    private var animationPercent: Float
    private let path: BezierPath
    private let colors: [BezierColor]
    
    public init(animationPercent: Float, path: BezierPath, colors: [BezierColor]) {
        self.animationPercent = animationPercent
        self.path = path
        self.colors = colors
    }
    
    public var animatableData: Float {
        get { animationPercent }
        set { animationPercent = newValue }
    }
    
    public func body(content: Content) -> some View {
        MetalViewMapper(animationPercent: animationPercent, path: path, colors: colors)
    }
}


