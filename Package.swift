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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.5/UnoloIOSSDK.xcframework.zip",
            checksum: "d31b05ab1f5878ccb6062377117af53f5f9cede29f302389711cc7a650474dc7"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.5/UnoloAttendance.xcframework.zip",
            checksum: "c1056bb21d90cfe903007d330a305b9be6b2fbe8de0c21ba48ecfea335595aae"
        ),
    ]
)
