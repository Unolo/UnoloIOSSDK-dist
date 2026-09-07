// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UnoloIOSSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Location Tracking only — links Core.
        .library(
            name: "UnoloIOSSDK",
            targets: ["UnoloIOSSDK"]
        ),
        // Attendance (full) — links Attendance + Core.
        .library(
            name: "UnoloAttendance",
            targets: ["UnoloAttendance", "UnoloIOSSDK"]
        ),
        // CustomClient — links CustomClient + Core only (CustomClient never depends on Attendance).
        .library(
            name: "UnoloCustomClient",
            targets: ["UnoloCustomClient", "UnoloIOSSDK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "UnoloIOSSDK",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.0/UnoloIOSSDK.xcframework.zip",
            checksum: "7e72bdca58beb5538d49a51aa46b9129ddb18f7e8e05d8badcfedd072ed9903b"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.0/UnoloAttendance.xcframework.zip",
            checksum: "b0644d55c250130b001366825f0d1e74033ba2354b7e2a81e147114c313f5679"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.0/UnoloCustomClient.xcframework.zip",
            checksum: "07524ec6fb2369e2b2ec1e80d4a8436f69aac2a5334e9c6deda6c0974b79626c"
        ),
    ]
)
