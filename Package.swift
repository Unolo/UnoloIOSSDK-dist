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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.11/UnoloIOSSDK.xcframework.zip",
            checksum: "8386062b347218157532755f78faa0874e96f385851aea910c06855c0bfe3e03"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.11/UnoloAttendance.xcframework.zip",
            checksum: "fbdd44bb8fc9dd40112aee29c367a946166ed05636e6241539bf55e3ea6f7cc4"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.11/UnoloCustomClient.xcframework.zip",
            checksum: "f8f1bbb2d70fc96a3d02d32a9e20295744fec83a5a29c1045bad7ccfc1803b2a"
        ),
    ]
)
