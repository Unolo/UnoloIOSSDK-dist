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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.3/UnoloIOSSDK.xcframework.zip",
            checksum: "a9b85bdbfcc0737948f8ef6082dcd429c3ee01a52d0db3b5ddb09f1f2d12907d"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.3/UnoloAttendance.xcframework.zip",
            checksum: "8b80948d268d947c0c8a3a9bbe1852799a5bf15a9886b5aa2d7b929117cb103f"
        ),
    ]
)
