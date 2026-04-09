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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.9.5/UnoloIOSSDK.xcframework.zip",
            checksum: "02a6318dba5ab0394ca5eb9d7a29834243c8528d74383c2d4b44e11f85a8df5e"
        ),
    ]
)
