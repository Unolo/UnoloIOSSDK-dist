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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.12/UnoloIOSSDK.xcframework.zip",
            checksum: "6a2953e0bdc5695818bde1e2c06cb0b02d5a1b698729a994146b7ce6cb1c2650"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.12/UnoloAttendance.xcframework.zip",
            checksum: "742487db00ea2821a393bbf3d37654c8c9f21ffc9bb2ffbe6291d675b82c7601"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.12/UnoloCustomClient.xcframework.zip",
            checksum: "c36d8f649a6e18a04bac9c98a1434204a38b563c8e6b35f1e63fa2f591a01a5c"
        ),
    ]
)
