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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.5/UnoloIOSSDK.xcframework.zip",
            checksum: "5b1593f0ed7fde2c49bd3bcb780ca381f81e573c3e96e3b5a9f966ca545723d7"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.5/UnoloAttendance.xcframework.zip",
            checksum: "054ef300503696edabcb83f347726104b6d663bc1b3cc857edca6c359a6bfb49"
        ),
    ]
)
