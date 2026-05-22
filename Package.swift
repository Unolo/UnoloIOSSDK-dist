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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.2/UnoloIOSSDK.xcframework.zip",
            checksum: "0d4009b95901f1d52344d59d32cd80c276ae4eea3f864c46368348c0f4bb9e3d"
        ),
    ]
)
