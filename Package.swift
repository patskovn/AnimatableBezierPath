// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnimatableBezierPath",
    platforms: [.macOS(.v10_15), .iOS(.v13), .macCatalyst(.v13)],
    products: [
        .library(name: "AnimatableBezierPath", targets: ["AnimatableBezierPath"]),
        .library(name: "_BezierCHeaders", targets: ["_BezierCHeaders"])
    ],
    targets: [
        .target(name: "AnimatableBezierPath", dependencies: ["_BezierCHeaders"]),
        .target(name: "_BezierCHeaders")
    ]
)
