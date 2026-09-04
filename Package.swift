// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UnoloIOSSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Location Tracking only — links Core. GoogleMapsTarget is included because Core's
        // own public interface re-exports GoogleMaps (GMSMapView etc. show up in Core's own
        // public API, e.g. the geo-tag camera) -- without it, a consumer's build fails with
        // "Unable to find module dependency: 'GoogleMaps'" even though GoogleMaps' actual
        // compiled code is already statically embedded inside UnoloIOSSDK.xcframework itself.
        .library(
            name: "UnoloIOSSDK",
            targets: ["UnoloIOSSDKWrapper", "GoogleMapsTarget"]
        ),
        // Attendance (full) — links Attendance + Core (shared deps come from Core, no duplication)
        .library(
            name: "UnoloAttendance",
            targets: ["UnoloAttendanceWrapper", "UnoloIOSSDKWrapper", "GoogleMapsTarget"]
        ),
        // CustomClient — links CustomClient + Core only (CustomClient never depends on Attendance).
        // Also needs GooglePlaces/JNPhoneNumberView/NotificationBannerSwift/SVProgressHUD/SideMenu
        // visible for the same "module dependency" reason as GoogleMapsTarget above.
        .library(
            name: "UnoloCustomClient",
            targets: [
                "UnoloCustomClientWrapper", "UnoloIOSSDKWrapper", "GoogleMapsTarget",
                "GooglePlacesTarget", "JNPhoneNumberViewTarget", "NotificationBannerTarget",
                "SVProgressHUDTarget", "SideMenuTarget",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/googlemaps/ios-maps-sdk", from: "9.4.0"),
        .package(url: "https://github.com/googlemaps/ios-places-sdk", exact: "9.4.1"),
        .package(url: "https://github.com/JNDisrupter/JNPhoneNumberView", from: "2.0.0"),
        .package(url: "https://github.com/Daltron/NotificationBanner", from: "4.0.0"),
        .package(url: "https://github.com/SVProgressHUD/SVProgressHUD", from: "2.3.1"),
        .package(url: "https://github.com/jonkykong/SideMenu", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "UnoloIOSSDKWrapper",
            dependencies: ["UnoloIOSSDKBinary"],
            path: "Sources/UnoloIOSSDKWrapper"
        ),
        .target(
            name: "UnoloAttendanceWrapper",
            dependencies: ["UnoloAttendanceBinary"],
            path: "Sources/UnoloAttendanceWrapper"
        ),
        .target(
            name: "UnoloCustomClientWrapper",
            dependencies: ["UnoloCustomClientBinary"],
            path: "Sources/UnoloCustomClientWrapper"
        ),
        .target(
            name: "GoogleMapsTarget",
            dependencies: [.product(name: "GoogleMaps", package: "ios-maps-sdk")],
            path: "Sources/GoogleMapsTarget"
        ),
        .target(
            name: "GooglePlacesTarget",
            dependencies: [.product(name: "GooglePlaces", package: "ios-places-sdk")],
            path: "Sources/GooglePlacesTarget"
        ),
        .target(
            name: "JNPhoneNumberViewTarget",
            dependencies: [.product(name: "JNPhoneNumberView", package: "JNPhoneNumberView")],
            path: "Sources/JNPhoneNumberViewTarget"
        ),
        .target(
            name: "NotificationBannerTarget",
            dependencies: [.product(name: "NotificationBannerSwift", package: "NotificationBanner")],
            path: "Sources/NotificationBannerTarget"
        ),
        .target(
            name: "SVProgressHUDTarget",
            dependencies: [.product(name: "SVProgressHUD", package: "SVProgressHUD")],
            path: "Sources/SVProgressHUDTarget"
        ),
        .target(
            name: "SideMenuTarget",
            dependencies: [.product(name: "SideMenu", package: "SideMenu")],
            path: "Sources/SideMenuTarget"
        ),
        .binaryTarget(
            name: "UnoloIOSSDKBinary",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.9/UnoloIOSSDK.xcframework.zip",
            checksum: "c00b570b22bbd1084d88568b6e077622d3b9d137e6a7919246c42f76fb6d796c"
        ),
        .binaryTarget(
            name: "UnoloAttendanceBinary",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.9/UnoloAttendance.xcframework.zip",
            checksum: "ddb33e59a196c4c9b0f656aff166c39d0864c9d3f0da5533a5d9292cebfd132b"
        ),
        .binaryTarget(
            name: "UnoloCustomClientBinary",
            url: "https://github.com/Unolo/UnoloIOSSDK-dist/releases/download/1.0.9/UnoloCustomClient.xcframework.zip",
            checksum: "5a95887f626b531012a02e902a8db4fa60b64061338136f781e3c22a64d2eeaf"
        ),
    ]
)
