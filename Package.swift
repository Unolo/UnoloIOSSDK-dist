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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.9.2/UnoloIOSSDK.xcframework.zip",
            checksum: "5a9b3216eb3138dbf53f6f55aeec687763b1d15642ba88bb5ea874ff89bbb51e"
        ),
    ]
)
