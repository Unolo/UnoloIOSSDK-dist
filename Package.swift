// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "UnoloIOSSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "UnoloIOSSDK",
            targets: ["UnoloIOSSDK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "UnoloIOSSDK",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.9.3/UnoloIOSSDK.xcframework.zip",
            checksum: "4b2d469666dc411b99a6fe3e09c015124dc6275356fdf37a72d41316ab03a867"
        ),
    ]
)
