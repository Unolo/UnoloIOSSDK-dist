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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.9.0/UnoloIOSSDK.xcframework.zip",
            checksum: "08ed3c35fa3b4a949ea6b339000db4db7ed0ff13d46ff2e0d983ddfd0ab5fccc"
        ),
    ]
)
