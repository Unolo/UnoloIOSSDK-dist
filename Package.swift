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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.13/UnoloIOSSDK.xcframework.zip",
            checksum: "f29dc32035d6fc9bfc0c34d1d275ff030246c97d8b510c86029ba6dc7a456005"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.13/UnoloAttendance.xcframework.zip",
            checksum: "ddf4e79e00505c8064a4232e2b874dfa33aba6a76febc497bd7e3c444f998acc"
        ),
    ]
)
