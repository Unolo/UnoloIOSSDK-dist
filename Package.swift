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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.1/UnoloIOSSDK.xcframework.zip",
            checksum: "764ccdc410e3ce3d404e1b7573d9ef5175f77563b96d4e55fc07131094863005"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.1/UnoloAttendance.xcframework.zip",
            checksum: "1a26dabbcbbf5e1bf07121d536ba2f44b19391689da216249b414c8cf92706fe"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.1/UnoloCustomClient.xcframework.zip",
            checksum: "80c41656317f3d1abe12c0d5cb5eb08fa5adbd717a94f9d463e7cb6b50333fd6"
        ),
    ]
)
