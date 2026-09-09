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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.5/UnoloIOSSDK.xcframework.zip",
            checksum: "27ba9826b2e9bb3b3a5768681939f285ec44aa192fdc7479e43922e25f0e86b3"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.5/UnoloAttendance.xcframework.zip",
            checksum: "fd6496e19900134ec9e1493c6411e896946f3da90628e6c72de33392cf800a7e"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.5/UnoloCustomClient.xcframework.zip",
            checksum: "5fecb9f98e2811b10a9cc16f7f6c443f0490c9266df6af0e12a6b007ff28a84a"
        ),
    ]
)
