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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.2/UnoloIOSSDK.xcframework.zip",
            checksum: "bf5a81db214b217ed6b5a9430a096f7e40ffc730cdd7287dbedb9349e71be568"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.2/UnoloAttendance.xcframework.zip",
            checksum: "be66790d508f17098a1713d05efcd390f1561fa3356c1ab86dabbca1866da847"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.2/UnoloCustomClient.xcframework.zip",
            checksum: "7345af8b2c5901e746a967593c471ef72627aa039ee33edc48e62af06eb792bc"
        ),
    ]
)
