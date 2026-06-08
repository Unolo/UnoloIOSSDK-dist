  // swift-tools-version: 5.9

  import PackageDescription

  let package = Package(
      name: "UnoloIOSSDK",
      platforms: [
          .iOS(.v15)
      ],
      products: [
          .library(name: "UnoloIOSSDK",     targets: ["UnoloIOSSDK"]),       // Location Tracking
          .library(name: "UnoloAttendance", targets: ["UnoloAttendance"]),   // Attendance module
      ],
      targets: [
          .binaryTarget(
              name: "UnoloIOSSDK",
              url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.0/UnoloIOSSDK.xcframework.zip",
              checksum: "2320522d1208b4df4849a1f12e6dbafd9fc151c5a85eb42dd5438928030d21e4"
          ),
          .binaryTarget(
              name: "UnoloAttendance",
              url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.0/UnoloAttendance.xcframework.zip",
              checksum: "ea3c24c6c47d6acb882b27cfb8757230c0048c5f23126a78c0ec8b6c0d4327c7"
          ),
      ]
  )
