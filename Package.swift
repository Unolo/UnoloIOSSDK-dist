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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.8/UnoloIOSSDK.xcframework.zip",
            checksum: "1239a6dce64ab8b7386bdd716900a6a213ff0f44eff286c2479fc39d89cc9adc"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.8/UnoloAttendance.xcframework.zip",
            checksum: "1bdd2c14010ee03d75e4558bc9c08762085efb498c58517ec56d93820c2073c3"
        ),
    ]
)
