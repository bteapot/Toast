// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Toast",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Toast",
            targets: ["Toast"]
        ),
    ],
    targets: [
        .target(
            name: "Toast"
        ),
    ]
)
