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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.11/UnoloIOSSDK.xcframework.zip",
            checksum: "8d12b0c188bcfdb5017a1780a6f11757c704a7c80600a97be133207a77b45426"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.1.11/UnoloAttendance.xcframework.zip",
            checksum: "9770faad3b9789e05b6609a8e386ca97aac5dc452a7850f895d215ec72180b64"
        ),
    ]
)
