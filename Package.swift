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
            targets: ["UnoloIOSSDK", "UnoloIOSSDKDependencies"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios", exact: "0.39.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.0.0"),
    ],
    targets: [
        .binaryTarget(
            name: "UnoloIOSSDK",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.4.1/UnoloIOSSDK.xcframework.zip",
            checksum: "b792eec890a5c0b3b809717ab10f46952b33fde0c1bc735785729f2a7e9989a3"
        ),
        .target(
            name: "UnoloIOSSDKDependencies",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ],
            path: "Sources/UnoloIOSSDKDependencies"
        ),
    ]
)
