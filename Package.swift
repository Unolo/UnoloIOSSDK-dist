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
            checksum: "18b0fbac060c3c17b6d143e976b440bb09f354df5429ce66608b09f1306938a3"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.5/UnoloAttendance.xcframework.zip",
            checksum: "01c0a5cc09e2c9abbc1106ec26f94e36d718b7daa734eaedfea168cc2aadd034"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.5/UnoloCustomClient.xcframework.zip",
            checksum: "5da6080fbc238f74916fc6f1b66806c80d8abaa7b0e2881e5f31eab19dd59a93"
        ),
    ]
)
