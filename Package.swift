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
            targets: ["UnoloIOSSDKWrapper"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios", exact: "0.39.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.0.0"),
    ],
    targets: [
        .target(
            name: "UnoloIOSSDKWrapper",
            dependencies: [
                "UnoloIOSSDKBinary",
                "FirebaseAuthTarget",
                "ApolloTarget",
            ],
            path: "Sources/UnoloIOSSDKWrapper"
        ),
        .target(
            name: "FirebaseAuthTarget",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ],
            path: "Sources/FirebaseAuthTarget"
        ),
        .target(
            name: "ApolloTarget",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
            ],
            path: "Sources/ApolloTarget"
        ),
        .binaryTarget(
            name: "UnoloIOSSDKBinary",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.6.0/UnoloIOSSDK.xcframework.zip",
            checksum: "a8717edf4de1a6239f784133e5a79683800d26f9eaee883b357b897756b37736"
        ),
    ]
)
