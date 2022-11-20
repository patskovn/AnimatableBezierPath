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

import CoreGraphics
import simd

public var helloColors: [BezierColor] = [
    .init(21/255, 123/255, 147/255, 1),
    .init(253/255, 211/255, 93/255, 1),
    .init(244/255, 83/255, 67/255, 1),
    .init(149/255, 117/255, 179/255, 1),
    .init(108/255, 153/255, 223/255, 1),
    .init(127/255, 182/255, 221/255, 1),
]

public var helloBezierPath: BezierPath = {
    var shape = BezierPath(viewBox: .init(width: 1032, height: 322), lineWidth: 120)
    shape.move(to: CGPoint(x: 1, y: 303.38))
    shape.addCurve(to: CGPoint(x: 109.8, y: 227.73), controlPoint1: CGPoint(x: 28.31, y: 287.4), controlPoint2: CGPoint(x: 88.3, y: 249.9))
    
    shape.move(to: CGPoint(x: 146.8, y: 183.76))
    shape.addCurve(to: CGPoint(x: 210.23, y: 48.3), controlPoint1: CGPoint(x: 164.86, y: 164.55), controlPoint2: CGPoint(x: 202.46, y: 117.58))
    shape.addCurve(to: CGPoint(x: 142.83, y: 32.47), controlPoint1: CGPoint(x: 216.39, y: -6.67), controlPoint2: CGPoint(x: 160.85, y: -16.06))
    shape.addCurve(to: CGPoint(x: 112.88, y: 253.68), controlPoint1: CGPoint(x: 128.3, y: 71.61), controlPoint2: CGPoint(x: 121.25, y: 194.9))
    
    
    shape.move(to: CGPoint(x: 99.23, y: 319.65))
    shape.addCurve(to: CGPoint(x: 142.39, y: 188.59), controlPoint1: CGPoint(x: 104.37, y: 285.49), controlPoint2: CGPoint(x: 118.61, y: 216.74))
    shape.addCurve(to: CGPoint(x: 225.64, y: 201.35), controlPoint1: CGPoint(x: 168.53, y: 157.66), controlPoint2: CGPoint(x: 219.46, y: 150.09))
    shape.addCurve(to: CGPoint(x: 229.61, y: 310.85), controlPoint1: CGPoint(x: 230.05, y: 237.85), controlPoint2: CGPoint(x: 205.38, y: 292.38))
    shape.addCurve(to: CGPoint(x: 340.17, y: 296.34), controlPoint1: CGPoint(x: 253.83, y: 329.32), controlPoint2: CGPoint(x: 314.62, y: 313.49))
    
    
    shape.addCurve(to: CGPoint(x: 415.49, y: 214.74), controlPoint1: CGPoint(x: 369.24, y: 280.83), controlPoint2: CGPoint(x: 404.09, y: 254.76))
    shape.normalizeLastConnection()
    shape.addCurve(to: CGPoint(x: 340.17, y: 178.48), controlPoint1: CGPoint(x: 430.19, y: 163.12), controlPoint2: CGPoint(x: 373.15, y: 140.67))
    shape.normalizeLastConnection()
    shape.addCurve(to: CGPoint(x: 345.45, y: 293.74), controlPoint1: CGPoint(x: 315.06, y: 207.26), controlPoint2: CGPoint(x: 310.21, y: 267.15))
    
    shape.addCurve(to: CGPoint(x: 508.43, y: 270.39), controlPoint1: CGPoint(x: 359.55, y: 316.13), controlPoint2: CGPoint(x: 438.66, y: 343.57))
    shape.normalizeLastConnection()
    
    
    shape.addCurve(to: CGPoint(x: 596.96, y: 124.82), controlPoint1: CGPoint(x: 540.44, y: 232.43), controlPoint2: CGPoint(x: 582.87, y: 175.14))
    shape.addCurve(to: CGPoint(x: 594.32, y: 6.08), controlPoint1: CGPoint(x: 614.58, y: 61.94), controlPoint2: CGPoint(x: 618.11, y: 17.52))
    shape.normalizeLastConnection()
    shape.addCurve(to: CGPoint(x: 520.76, y: 101.27), controlPoint1: CGPoint(x: 567.89, y: -6.62), controlPoint2: CGPoint(x: 535.3, y: 28.71))
    shape.addCurve(to: CGPoint(x: 508.43, y: 218.06), controlPoint1: CGPoint(x: 510.52, y: 152.39), controlPoint2: CGPoint(x: 508.43, y: 179.36))
    
    
    shape.addCurve(to: CGPoint(x: 573.62, y: 320.97), controlPoint1: CGPoint(x: 507.69, y: 252.36), controlPoint2: CGPoint(x: 517.24, y: 319.56))
    shape.addCurve(to: CGPoint(x: 705.76, y: 231.25), controlPoint1: CGPoint(x: 639.25, y: 322.61), controlPoint2: CGPoint(x: 685.35, y: 261.6))
    shape.normalizeLastConnection()
    
    shape.addCurve(to: CGPoint(x: 767.43, y: 91.4), controlPoint1: CGPoint(x: 724.7, y: 201.79), controlPoint2: CGPoint(x: 754.8, y: 141.69))
    shape.addCurve(to: CGPoint(x: 754.21, y: 6.52), controlPoint1: CGPoint(x: 781.96, y: 33.54), controlPoint2: CGPoint(x: 774.22, y: 13.38))
    shape.normalizeLastConnection()
    shape.addCurve(to: CGPoint(x: 687.26, y: 91.4), controlPoint1: CGPoint(x: 729.11, y: -2.08), controlPoint2: CGPoint(x: 700.92, y: 32.03))
    shape.addCurve(to: CGPoint(x: 677.57, y: 262.92), controlPoint1: CGPoint(x: 674.8, y: 145.6), controlPoint2: CGPoint(x: 661.72, y: 217.18))
    
    
    shape.addCurve(to: CGPoint(x: 739.24, y: 320.53), controlPoint1: CGPoint(x: 674.93, y: 273.67), controlPoint2: CGPoint(x: 703.5, y: 319.05))
    shape.normalizeLastConnection()
    shape.addCurve(to: CGPoint(x: 841.43, y: 220.26), controlPoint1: CGPoint(x: 786.37, y: 322.48), controlPoint2: CGPoint(x: 819.85, y: 286.67))
    shape.normalizeLastConnection()
    
    
    shape.addCurve(to: CGPoint(x: 905.3, y: 160.01), controlPoint1: CGPoint(x: 848.04, y: 196.95), controlPoint2: CGPoint(x: 867.95, y: 160.01))
    shape.addCurve(to: CGPoint(x: 967.4, y: 235.65), controlPoint1: CGPoint(x: 951.81, y: 317.63), controlPoint2: CGPoint(x: 966.82, y: 208.5))
    shape.normalizeLastConnection()
    
    shape.addCurve(to: CGPoint(x: 896.49, y: 320.09), controlPoint1: CGPoint(x: 830.86, y: 267.31), controlPoint2: CGPoint(x: 951.81, y: 317.63))
    shape.normalizeLastConnection()
    shape.addCurve(to: CGPoint(x: 841.43, y: 220.26), controlPoint1: CGPoint(x: 786.37, y: 322.48), controlPoint2: CGPoint(x: 829, y: 266))
    shape.normalizeLastConnection()
    
    shape.addCurve(to: CGPoint(x: 905.3, y: 160.01), controlPoint1: CGPoint(x: 848.04, y: 196.95), controlPoint2: CGPoint(x: 867.95, y: 160.01))
    shape.addCurve(to: CGPoint(x: 981.94, y: 181.56), controlPoint1: CGPoint(x: 951.99, y: 160.01), controlPoint2: CGPoint(x: 948.46, y: 182.44))
    shape.addCurve(to: CGPoint(x: 1037, y: 153.41), controlPoint1: CGPoint(x: 1008.72, y: 180.85), controlPoint2: CGPoint(x: 1029.81, y: 162.5))
    
    return shape
}()
