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
        // CustomClient — links CustomClient + Core only (CustomClient never depends on Attendance)
        .library(
            name: "UnoloCustomClient",
            targets: ["UnoloCustomClient", "UnoloIOSSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "UnoloIOSSDK",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.8/UnoloIOSSDK.xcframework.zip",
            checksum: "c00b570b22bbd1084d88568b6e077622d3b9d137e6a7919246c42f76fb6d796c"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.8/UnoloAttendance.xcframework.zip",
            checksum: "ddb33e59a196c4c9b0f656aff166c39d0864c9d3f0da5533a5d9292cebfd132b"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.8/UnoloCustomClient.xcframework.zip",
            checksum: "5a95887f626b531012a02e902a8db4fa60b64061338136f781e3c22a64d2eeaf"
        ),
    ]
)
