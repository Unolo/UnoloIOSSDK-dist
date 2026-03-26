  // swift-tools-version: 5.9

  import PackageDescription

  let package = Package(
      name: "UnoloIOSSDK",
      platforms: [
          .iOS(.v15)
      ],
      products: [
          .library(
              name: "UnoloIOSSDK",
              targets: ["UnoloIOSSDK"]
          ),
      ],
      targets: [
          .binaryTarget(
              name: "UnoloIOSSDK",
              url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.5.0/UnoloIOSSDK.xcframework.zip",
              checksum: "5f479bf2818e1fcda29d74c8f07be55495e6bfa11963b77735f3ce5b1b37dde1"
          ),
      ]
  )
