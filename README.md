# AnimatableBezierPath

Metal-based implementation of bezier curve that you fill with gradient along path and animate.

Here how it looks.

![Mesh gradient gif](Files/bezier.gif)

## How to generate mesh

It is as simple as native UIKit API. Ideally you should ask your designer to create SVG file with single continuous bezier curve, export it and convert it with online converter [like this one](http://svg-converter.kyome.io/) or manually.
You can find "Hello" example [here](Sources/AnimatableBezierPath/Samples/Hello.swift).
 
Here how it looks like:

```swift
public var helloBezierPath: BezierPath = {
    // Initiate bezier path with `viewBox` and desired `lineWidth`
    var shape = BezierPath(viewBox: .init(width: 1032, height: 322), lineWidth: 120)
    
    // Start your curve via moving to initial position
    shape.move(to: CGPoint(x: 1, y: 303.38))
    
    // And then you should draw it relatively to your `viewBox`
    shape.addCurve(to: CGPoint(x: 109.8, y: 227.73), controlPoint1: CGPoint(x: 28.31, y: 287.4), controlPoint2: CGPoint(x: 88.3, y: 249.9))
    shape.addCurve(to: CGPoint(x: 210.23, y: 48.3), controlPoint1: CGPoint(x: 164.86, y: 164.55), controlPoint2: CGPoint(x: 202.46, y: 117.58))
    
    return shape
}()
```
