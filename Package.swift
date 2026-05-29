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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.4/UnoloIOSSDK.xcframework.zip",
            checksum: "8868a3df69347b98b2d9f021b9c21ab88be0eafc977eda2e9034f59f3eca7dac"
        ),
    ]
)
