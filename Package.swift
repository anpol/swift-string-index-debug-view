// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftStringIndexDebugView",
    products: [
        .library(
            name: "SwiftStringIndexDebugView",
            targets: ["SwiftStringIndexDebugView"]),
    ],
    targets: [
        .target(
            name: "SwiftStringIndexDebugView"),
    ]
)
