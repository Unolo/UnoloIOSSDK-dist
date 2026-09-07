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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.3/UnoloIOSSDK.xcframework.zip",
            checksum: "17c84b052a6ec33a04f03c61d8d42c5f72bf2e43786dce1e2e6438f76cb27d36"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.3/UnoloAttendance.xcframework.zip",
            checksum: "4aa7c20a35d03448a4a82d9048d5fa10b3276c41130d9ea8a47c93272ca2d72b"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.3/UnoloCustomClient.xcframework.zip",
            checksum: "55d1cbb0d956151881f0706a44366ddd21b4c4b5f5947d2985fe4a325a9a256f"
        ),
    ]
)
