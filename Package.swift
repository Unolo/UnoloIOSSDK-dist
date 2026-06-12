// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "UnoloIOSSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Location Tracking only — links Core
        .library(
            name: "UnoloIOSSDK",
            targets: ["UnoloIOSSDK"]
        ),
        // Attendance (full) — links Attendance + Core (shared deps come from Core, no duplication)
        .library(
            name: "UnoloAttendance",
            targets: ["UnoloAttendance", "UnoloIOSSDK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "UnoloIOSSDK",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.10/UnoloIOSSDK.xcframework.zip",
            checksum: "6706a0008f15cd5f88110b7e6e6e29ed31448fd1e75e222f8d1b199e5b5dffa4"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.10/UnoloAttendance.xcframework.zip",
            checksum: "5468bd398d8c751c857983f4e4a6767a22c6fbb61ad08d44cf75ca96865368fd"
        ),
    ]
)
