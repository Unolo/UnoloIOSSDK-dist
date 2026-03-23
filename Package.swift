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
      dependencies: [                                                                                              
          .package(url: "https://github.com/apollographql/apollo-ios", exact: "0.39.0"),
          .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.0.0"),                           
      ],                                                                                                           
      targets: [                                                                                                   
          .binaryTarget(                                                                                           
              name: "UnoloIOSSDK",                                                                                 
              url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/0.3.0/UnoloIOSSDK.xcframework.zip",     
              checksum: "581625dd27bbc1deb19f6bfc2c2cc90d6ef6a90090138ca208222ade80f1effd"                         
          ),                                                                                                       
      ]
  )              