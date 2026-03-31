# UnoloIOSSDK

Unolo iOS SDK for real-time location tracking, attendance management, and data sync.

---

## Table of Contents

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Setup](#setup)
4. [SDK Initialization](#sdk-initialization)
5. [Start & Stop Tracking](#start--stop-tracking)
6. [Tracking State](#tracking-state)
7. [Data Sync](#data-sync)
8. [Delegate (Callbacks)](#delegate-callbacks)
9. [API Reference](#api-reference)
10. [Permissions](#permissions)
11. [Error Types](#error-types)
12. [Complete Integration Example](#complete-integration-example)
13. [Troubleshooting](#troubleshooting)

---

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

---

## Installation

### Swift Package Manager

Add the following to your `Package.swift` or use Xcode > File > Add Package Dependencies:

```
https://github.com/Unolo/UnoloIOSSDK.git
```

---

## Setup

### Info.plist

Add these keys to your app's `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to track attendance</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location for background tracking</string>
<key>NSMotionUsageDescription</key>
<string>We use motion data to detect activity like walking, driving, and stationary</string>
```

For background location tracking, also add:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>location</string>
</array>
```

> **Important:** Without `UIBackgroundModes > location`, the SDK will not track location in the background.

---

## SDK Initialization

Initialize the SDK with your credentials. This handles login, Firebase authentication, and internal setup.

```swift
import UnoloIOSSDK

UnoloSDK.shared.initialize(
    companyID: "YOUR_COMPANY_ID",
    employeeID: "YOUR_EMPLOYEE_ID",
    licenseKey: "YOUR_LICENSE_KEY"
) { result in
    switch result {
    case .success:
        print("SDK initialized successfully")
    case .failure(let error):
        print("Failed: \(error.localizedDescription)")
    }
}
```

> **Note:** `initialize()` must be called before any other SDK method.

---

## Start & Stop Tracking

### Start Tracking (Punch In)

Call when the employee punches in / starts work:

```swift
UnoloSDK.shared.startLocationTracking { result in
    switch result {
    case .success:
        print("Tracking started")
    case .failure(let error):
        print("Failed: \(error.localizedDescription)")
    }
}
```

### Stop Tracking (Punch Out)

Call when the employee punches out / ends work:

```swift
UnoloSDK.shared.stopLocationTracking { result in
    switch result {
    case .success:
        print("Tracking stopped")
    case .failure(let error):
        print("Failed: \(error.localizedDescription)")
    }
}
```

---

## Tracking State

The SDK provides a `UnoloTrackingState` enum to query the current state:

| State | Meaning |
|---|---|
| `.unauthenticated` | SDK not initialized — call `initialize()` first |
| `.inactive` | Authenticated, tracking not started |
| `.active` | Authenticated and actively tracking |

```swift
let state = UnoloSDK.shared.trackingState
print("State: \(state.rawValue)")    // "UNAUTHENTICATED", "INACTIVE", "ACTIVE"
print("Message: \(state.message)")   // Human-readable guidance
```

### Check Status

```swift
UnoloSDK.shared.isSDKInitialized()     // true if initialize() was successful
UnoloSDK.shared.isCurrentlyTracking()   // true if tracking is active
```

---

## Data Sync

Location data is automatically synced to the Unolo backend. To trigger an immediate sync:

```swift
UnoloSDK.shared.syncNow()
```

Refresh settings from server:

```swift
UnoloSDK.shared.refreshSettings { result in
    switch result {
    case .success:
        print("Settings refreshed")
    case .failure(let error):
        print("Failed: \(error.localizedDescription)")
    }
}
```

---

## Delegate (Callbacks)

Implement `UnoloSDKDelegate` to receive SDK callbacks. All methods are **optional**.

```swift
class ViewController: UIViewController, UnoloSDKDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        UnoloSDK.shared.delegate = self
    }

    // Called when a new location is received
    func unoloSDK(didUpdateLocation location: CLLocation) {
        print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }

    // Called when an error occurs
    func unoloSDK(didFailWithError error: UnoloError) {
        print("Error: \(error.localizedDescription)")
    }

    // Called when tracking status changes (start/stop)
    func unoloSDK(didChangeTrackingStatus isTracking: Bool) {
        print("Tracking: \(isTracking)")
    }

    // Called when location permission status changes
    func unoloSDK(didChangePermissionStatus status: CLAuthorizationStatus) {
        print("Permission: \(status.rawValue)")
    }
}
```

---

## API Reference

### `UnoloSDK`

| Method / Property | Description |
|---|---|
| `UnoloSDK.shared` | Singleton instance |
| `initialize(companyID:employeeID:licenseKey:completion:)` | Authenticate and initialize SDK |
| `startLocationTracking(completion:)` | Start tracking + Punch In |
| `stopLocationTracking(completion:)` | Stop tracking + Punch Out |
| `syncNow()` | Trigger immediate data sync |
| `refreshSettings(completion:)` | Refresh settings from server |
| `isSDKInitialized() -> Bool` | Check if SDK is initialized |
| `isCurrentlyTracking() -> Bool` | Check if tracking is active |
| `isAttendanceMarked() -> Bool` | Check if user is currently punched in |
| `getLastLocation() -> CLLocation?` | Get last known location (persists across app kill) |
| `getLocationsSince(timestamp:) -> [LocationModel]` | Get all locations after a given timestamp (ms) |
| `getUnsyncedLocationCount() -> Int` | Get count of locations not yet synced to server |
| `getCurrentEmployeeID() -> String` | Get current employee ID |
| `lastAttendance() -> AttdnceCDModel?` | Get last attendance record from local database |
| `trackingState` | Current SDK state (read-only) |
| `delegate` | Set delegate for callbacks |

### `UnoloSDKDelegate`

All methods are optional.

| Callback | Description |
|---|---|
| `unoloSDK(didUpdateLocation:)` | New location received |
| `unoloSDK(didFailWithError:)` | Error occurred |
| `unoloSDK(didChangeTrackingStatus:)` | Tracking started or stopped |
| `unoloSDK(didChangePermissionStatus:)` | Location permission changed |

### `UnoloTrackingState`

| State | Value | Meaning |
|---|---|---|
| `.unauthenticated` | `"UNAUTHENTICATED"` | SDK not initialized |
| `.inactive` | `"INACTIVE"` | Initialized, tracking not started |
| `.active` | `"ACTIVE"` | Tracking is active |

### `UnoloError`

| Error | Description |
|---|---|
| `.notInitialized` | SDK not initialized |
| `.locationPermissionDenied` | Location permission denied |
| `.locationServicesDisabled` | Location services off |
| `.networkError(String)` | Network issue |
| `.apiError(statusCode, message)` | Server error |
| `.encodingError` | Data encoding failed |
| `.storageError(String)` | Storage error |
| `.unknown(String)` | Unknown error |

### `CLLocation` (Apple's native location object)

The `didUpdateLocation` callback returns Apple's standard `CLLocation` object with full location data including coordinates, altitude, accuracy, speed, course, timestamp, and more.

---

## Permissions

The SDK requires the following permissions:

| Permission | Purpose |
|---|---|
| `NSLocationWhenInUseUsageDescription` | Foreground location access |
| `NSLocationAlwaysAndWhenInUseUsageDescription` | Background location access |
| `NSMotionUsageDescription` | Motion/activity detection |
| `UIBackgroundModes > location` | Background location tracking |

The SDK automatically requests location permission when `startLocationTracking()` is called if permission has not been granted yet.

---

## Complete Integration Example

### SwiftUI

```swift
import SwiftUI
import UnoloIOSSDK

// Delegate handler (SwiftUI uses a class since View is a struct)
class UnoloDelegate: NSObject, UnoloSDKDelegate {
    func unoloSDK(didUpdateLocation location: CLLocation) {
        print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }

    func unoloSDK(didFailWithError error: UnoloError) {
        print("Error: \(error.localizedDescription)")
    }

    func unoloSDK(didChangeTrackingStatus isTracking: Bool) {
        print("Tracking: \(isTracking)")
    }

    func unoloSDK(didChangePermissionStatus status: CLAuthorizationStatus) {
        print("Permission: \(status.rawValue)")
    }
}

@main
struct MyApp: App {
    let delegate = UnoloDelegate()

    init() {
        UnoloSDK.shared.initialize(
            companyID: "4010",
            employeeID: "emp001",
            licenseKey: "your-license-key"
        ) { result in
            switch result {
            case .success:
                print("SDK ready")
            case .failure(let error):
                print("SDK error: \(error.localizedDescription)")
            }
        }
        UnoloSDK.shared.delegate = delegate
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    var body: some View {
        VStack(spacing: 20) {
            Button("Start Tracking") {
                UnoloSDK.shared.startLocationTracking { result in
                    print("Tracking: \(result)")
                }
            }

            Button("Stop Tracking") {
                UnoloSDK.shared.stopLocationTracking { result in
                    print("Stopped: \(result)")
                }
            }

            Button("Sync Now") {
                UnoloSDK.shared.syncNow()
            }
        }
    }
}
```

### UIKit (Swift)

**AppDelegate.swift** — Initialize SDK here:

```swift
import UIKit
import UnoloIOSSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UnoloSDK.shared.initialize(
            companyID: "4010",
            employeeID: "emp001",
            licenseKey: "your-license-key"
        ) { result in
            switch result {
            case .success:
                print("SDK ready")
            case .failure(let error):
                print("SDK error: \(error.localizedDescription)")
            }
        }

        return true
    }
}
```

**ViewController.swift** — Use SDK methods:

```swift
import UIKit
import UnoloIOSSDK

class ViewController: UIViewController, UnoloSDKDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        UnoloSDK.shared.delegate = self
    }

    // Start tracking (Punch In)
    @IBAction func startTrackingTapped(_ sender: UIButton) {
        UnoloSDK.shared.startLocationTracking { result in
            switch result {
            case .success:
                print("Tracking started")
            case .failure(let error):
                print("Failed: \(error.localizedDescription)")
            }
        }
    }

    // Stop tracking (Punch Out)
    @IBAction func stopTrackingTapped(_ sender: UIButton) {
        UnoloSDK.shared.stopLocationTracking { result in
            switch result {
            case .success:
                print("Tracking stopped")
            case .failure(let error):
                print("Failed: \(error.localizedDescription)")
            }
        }
    }

    // Check status
    func checkStatus() {
        let isInitialized = UnoloSDK.shared.isSDKInitialized()
        let isTracking = UnoloSDK.shared.isCurrentlyTracking()
        let isPunchedIn = UnoloSDK.shared.isAttendanceMarked()
        let empId = UnoloSDK.shared.getCurrentEmployeeID()
        let unsyncedCount = UnoloSDK.shared.getUnsyncedLocationCount()

        print("Initialized: \(isInitialized)")
        print("Tracking: \(isTracking)")
        print("Punched In: \(isPunchedIn)")
        print("Employee: \(empId)")
        print("Unsynced: \(unsyncedCount)")
    }

    // Get locations since punch in
    func getLocations() {
        if let attendance = UnoloSDK.shared.lastAttendance() {
            let locations = UnoloSDK.shared.getLocationsSince(timestamp: attendance.timestamp)
            for loc in locations {
                print("Lat: \(loc.lat), Lon: \(loc.lon), Time: \(loc.timestamp)")
            }
        }
    }

    // MARK: - UnoloSDKDelegate

    func unoloSDK(didUpdateLocation location: CLLocation) {
        print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }

    func unoloSDK(didFailWithError error: UnoloError) {
        print("Error: \(error.localizedDescription)")
    }

    func unoloSDK(didChangeTrackingStatus isTracking: Bool) {
        print("Tracking: \(isTracking)")
    }

    func unoloSDK(didChangePermissionStatus status: CLAuthorizationStatus) {
        print("Permission: \(status.rawValue)")
    }
}
```

---

## Troubleshooting

| Issue | Fix |
|---|---|
| SDK init fails | Verify `companyID`, `employeeID`, and `licenseKey` are correct |
| Location not tracking | Ensure "Allow All the Time" location permission is granted |
| Background tracking not working | Add `UIBackgroundModes > location` in Info.plist |
| Data not syncing | Check network connection, call `syncNow()` to force sync |
| `notInitialized` error | Call `initialize()` before any other SDK method |

---

## License

Proprietary - Unolo
