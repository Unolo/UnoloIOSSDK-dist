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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.9.4/UnoloIOSSDK.xcframework.zip",
            checksum: "7ef071a600ad557cabdfd1e294368cd9c13e36555cc14a271c3490d41483c4c4"
        ),
    ]
)
