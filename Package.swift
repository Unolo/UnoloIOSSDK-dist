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
            checksum: "72a2425a0d9deb0d566ca1dae7da31655f5064c381cc2b1bb515dbcf00e58a22"
        ),
    ]
)
