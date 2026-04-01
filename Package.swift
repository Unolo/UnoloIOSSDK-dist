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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.8.0/UnoloIOSSDK.xcframework.zip",
            checksum: "8d9257d69bce62e48ee2bc96d33052a10786c034d68fd0f5b3641d7987712a41"
        ),
    ]
)
