// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "Highway",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Highway",
            targets: ["Highway"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Highway",
            dependencies: [],
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "HighwayTests",
            dependencies: ["Highway"],
            exclude: ["Info.plist"]
        ),
    ]
)
