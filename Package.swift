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
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.4/UnoloIOSSDK.xcframework.zip",
            checksum: "f7e414360ebc6d10b8c12b8f3f9e6a7ebf7981a0fa633b008a4e3119f8d4f345"
        ),
        .binaryTarget(
            name: "UnoloAttendance",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.4/UnoloAttendance.xcframework.zip",
            checksum: "b5664b7b095c60c6cb00286d4d3d90677b55e54f39f7d012a83811e352ed1d96"
        ),
        .binaryTarget(
            name: "UnoloCustomClient",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.4/UnoloCustomClient.xcframework.zip",
            checksum: "67d6c94134ace551873c9e84fac7008fe71aa787fce166427610f34fa88395e6"
        ),
    ]
)
