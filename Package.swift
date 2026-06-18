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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.9.6/UnoloIOSSDK.xcframework.zip",
            checksum: "0bb826ec06eac88f52d196372e27b1b9ede119359b8e62fc6e248d8f4fcecc28"
        ),
    ]
)
