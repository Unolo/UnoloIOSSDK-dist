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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.3/UnoloIOSSDK.xcframework.zip",
            checksum: "4a642e360dc7526f2025b2a5112db112a5a3a69ac03c8c5bc7cd36a193a961a0"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.3/UnoloAttendance.xcframework.zip",
            checksum: "3682da01e1657dbb42fa7068c3ff626f6dfd8e6d7eb07ab1f6a49abdb93624cf"
        ),
    ]
)
