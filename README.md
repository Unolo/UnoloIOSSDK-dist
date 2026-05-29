# Unolo Location Tracking SDK — iOS Integration Guide

Reliable background location tracking for field workforce management.

---

## Table of Contents

1. [Requirements](#1-requirements)
2. [Installation](#2-installation)
3. [Setup](#3-setup)
4. [SDK Initialization](#4-sdk-initialization)
5. [Start & Stop Tracking](#5-start--stop-tracking)
6. [Tracking State](#6-tracking-state)
7. [Data Sync](#7-data-sync)
8. [Location Queries](#8-location-queries)
9. [Error Handling](#9-error-handling)
10. [Delegate (Callbacks)](#10-delegate-callbacks)
11. [API Reference](#11-api-reference)
12. [Permissions](#12-permissions)
13. [Complete Integration Example](#13-complete-integration-example)
14. [Troubleshooting](#14-troubleshooting)

---

## 1. Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

---

## 2. Installation

### Swift Package Manager

Add the following to your `Package.swift` or use Xcode > File > Add Package Dependencies:

```
https://github.com/Unolo/UnoloIOSSDK-dist.git
```

---

## 3. Setup

### Info.plist

Add these keys to your app's `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to provide location-based services</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location in the background to provide continuous location-based services</string>
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

## 4. SDK Initialization

Initialize the SDK with your credentials. This handles authentication and internal setup.

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

> **Note:** `initialize()` must be called before any other SDK method. Safe to call on every app launch — handles re-authentication and credential changes automatically.

### Credential Change (User Switch)

When `initialize()` is called with credentials that differ from the previous session (different `employeeID`, `companyID`, or `licenseKey`), the SDK performs a graceful migration automatically:

**During runtime (app is running):**
1. **Best-effort data sync** — attempts to sync all pending data for the old employee before clearing.
2. **Signs out** the old session.
3. **Clears all local data** — CoreData and UserDefaults are wiped.
4. **Performs fresh login** with the new credentials.

**After app restart / kill:**
1. **Detects credential change** from saved credentials.
2. **Clears all local data** — CoreData, cached token, and UserDefaults are wiped.
3. **Performs fresh login** with the new credentials.

```swift
// Switch employees — just call initialize() with new credentials
UnoloSDK.shared.initialize(
    companyID: "4010",
    employeeID: "emp002",
    licenseKey: "your-license-key"
) { result in
    switch result {
    case .success:
        print("New employee authenticated")
    case .failure(let error):
        print("Switch failed: \(error.localizedDescription)")
    }
}
```

> **Key points:**
> - Fully automatic — the host app just passes new credentials.
> - The completion callback fires only after the full migration completes.
> - No data from the previous employee leaks to the new session.
> - Safe to call `initialize()` repeatedly for frequent employee switches.

---

## 5. Start & Stop Tracking

### Start Tracking

Call when the employee starts work:

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

### Stop Tracking

Call when the employee ends work:

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

## 6. Tracking State

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

## 7. Data Sync

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

## 8. Location Queries

### Last location

```swift
if let location = UnoloSDK.shared.getLastLocation() {
    print("\(location.latitude), \(location.longitude) +/-\(location.accuracy)m")
}
```

### Locations since timestamp

```swift
let locations = UnoloSDK.shared.getLocationsSince(timestamp: 1711900800000)
for loc in locations {
    print("Lat: \(loc.latitude), Lon: \(loc.longitude), Time: \(loc.timestamp)")
}
```

### Attendance

```swift
// Check if currently tracking
let isTracking = UnoloSDK.shared.isAttendanceMarked()

// Get last attendance record
if let attendance = UnoloSDK.shared.lastAttendance() {
    print("EventType: \(attendance.eventTypeID)")  // 8 = Started, 9 = Stopped
    print("Location: \(attendance.latitude), \(attendance.longitude)")
    print("Time: \(attendance.timestamp)")
}
```

### Other queries

```swift
let isInitialized = UnoloSDK.shared.isSDKInitialized()
let isTracking = UnoloSDK.shared.isCurrentlyTracking()
let unsyncedCount = UnoloSDK.shared.getUnsyncedLocationCount()
let employeeID = UnoloSDK.shared.getCurrentEmployeeID()
```

---

## 9. Error Handling

The SDK reports errors through the delegate callback and completion handlers:

```swift
// Via delegate
func unoloSDK(didFailWithError error: UnoloError) {
    switch error {
    case .notInitialized:
        print("SDK not initialized")
    case .locationPermissionDenied:
        print("Location permission denied")
    case .locationServicesDisabled:
        print("Location services off")
    case .networkError(let msg):
        print("Network: \(msg)")
    case .apiError(let code, let msg):
        print("API error \(code): \(msg)")
    case .encodingError:
        print("Encoding failed")
    case .storageError(let msg):
        print("Storage: \(msg)")
    case .unknown(let msg):
        print("Unknown: \(msg)")
    }
}
```

| Error | Description |
|---|---|
| `.notInitialized` | SDK not initialized — call `initialize()` first |
| `.locationPermissionDenied` | Location permission denied by user |
| `.locationServicesDisabled` | Device location services are turned off |
| `.networkError(String)` | Network request failed (timeout, no connectivity) |
| `.apiError(statusCode, message)` | Server returned an error |
| `.encodingError` | Data encoding failed |
| `.storageError(String)` | Local storage operation failed |
| `.unknown(String)` | Unexpected error |

---

## 10. Delegate (Callbacks)

Implement `UnoloSDKDelegate` to receive SDK callbacks. All methods are **optional**.

```swift
class ViewController: UIViewController, UnoloSDKDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        UnoloSDK.shared.delegate = self
    }

    // Called when a new location is received
    func unoloSDK(didUpdateLocation location: UnoloLocationModel) {
        print("Location: \(location.latitude), \(location.longitude)")
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
    func unoloSDK(didChangePermissionStatus status: UnoloPermissionStatus) {
        print("Permission: \(status)")
    }
}
```

---

## 11. API Reference

### `UnoloSDK`

| Method / Property | Description |
|---|---|
| `UnoloSDK.shared` | Singleton instance |
| `initialize(companyID:employeeID:licenseKey:completion:)` | Authenticate and initialize SDK |
| `startLocationTracking(completion:)` | Start location tracking |
| `stopLocationTracking(completion:)` | Stop location tracking |
| `syncNow()` | Trigger immediate data sync |
| `refreshSettings(completion:)` | Refresh settings from server |
| `isSDKInitialized() -> Bool` | Check if SDK is initialized |
| `isCurrentlyTracking() -> Bool` | Check if tracking is active |
| `isAttendanceMarked() -> Bool` | Check if user is currently punched in |
| `getLastLocation() -> UnoloLocationModel?` | Get last known location (persists across app kill) |
| `getLocationsSince(timestamp:)` | Get all locations after a given timestamp (ms) |
| `getUnsyncedLocationCount() -> Int` | Get count of locations not yet synced to server |
| `getCurrentEmployeeID() -> String` | Get current employee ID |
| `lastAttendance()` | Get last attendance record from local database |
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

### `UnoloLocationModel`

The `didUpdateLocation` callback returns `UnoloLocationModel` with location data:

| Property | Type | Description |
|---|---|---|
| `latitude` | `Double` | Latitude coordinate |
| `longitude` | `Double` | Longitude coordinate |
| `altitude` | `Double` | Altitude in meters |
| `accuracy` | `Double` | Horizontal accuracy in meters |
| `speed` | `Double` | Speed in m/s |
| `bearing` | `Double` | Course/heading |
| `timestamp` | `Date` | Time of location fix |

### `getLocationsSince()` Response

Returns `[UnoloLocationModel]` — same properties as `UnoloLocationModel` above.

### `UnoloAttendanceModel`

| Property | Type | Description |
|---|---|---|
| `eventTypeID` | `Int` | 8 = Tracking Started, 9 = Tracking Stopped |
| `latitude` | `Double` | Latitude |
| `longitude` | `Double` | Longitude |
| `accuracy` | `Double` | Horizontal accuracy in meters |
| `speed` | `Double` | Speed in m/s |
| `bearing` | `Double` | Course/heading |
| `timestamp` | `Double` | Timestamp in milliseconds |
| `isSynced` | `Bool` | Whether this record has been synced to server |

### `UnoloPermissionStatus`

| Case | Description |
|---|---|
| `.notDetermined` | User hasn't been asked yet |
| `.restricted` | Location access restricted |
| `.denied` | User denied permission |
| `.authorizedAlways` | Always permission granted |
| `.authorizedWhenInUse` | When in use permission granted |

---

## 12. Permissions

The SDK requires the following permissions:

| Permission | Purpose |
|---|---|
| `NSLocationWhenInUseUsageDescription` | Foreground location access |
| `NSLocationAlwaysAndWhenInUseUsageDescription` | Background location access |
| `NSMotionUsageDescription` | Motion/activity detection |
| `UIBackgroundModes > location` | Background location tracking |

The SDK automatically requests location permission when `startLocationTracking()` is called if permission has not been determined yet. If the user has previously denied permission, the SDK returns a `.locationPermissionDenied` error — the host app should guide the user to Settings to enable it manually.

---

## 13. Complete Integration Example

### SwiftUI

```swift
import SwiftUI
import UnoloIOSSDK

// Delegate handler (SwiftUI uses a class since View is a struct)
class UnoloDelegate: NSObject, UnoloSDKDelegate {
    func unoloSDK(didUpdateLocation location: UnoloLocationModel) {
        print("Location: \(location.latitude), \(location.longitude)")
    }

    func unoloSDK(didFailWithError error: UnoloError) {
        print("Error: \(error.localizedDescription)")
    }

    func unoloSDK(didChangeTrackingStatus isTracking: Bool) {
        print("Tracking: \(isTracking)")
    }

    func unoloSDK(didChangePermissionStatus status: UnoloPermissionStatus) {
        print("Permission: \(status)")
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
                    switch result {
                    case .success:
                        print("Tracking started")
                    case .failure(let error):
                        print("Failed: \(error.localizedDescription)")
                    }
                }
            }

            Button("Stop Tracking") {
                UnoloSDK.shared.stopLocationTracking { result in
                    switch result {
                    case .success:
                        print("Tracking stopped")
                    case .failure(let error):
                        print("Failed: \(error.localizedDescription)")
                    }
                }
            }

            Button("Sync Now") {
                UnoloSDK.shared.syncNow()
            }

            Button("Check Status") {
                print("Initialized: \(UnoloSDK.shared.isSDKInitialized())")
                print("Tracking: \(UnoloSDK.shared.isCurrentlyTracking())")
                print("Attendance: \(UnoloSDK.shared.isAttendanceMarked())")
                print("Employee: \(UnoloSDK.shared.getCurrentEmployeeID())")
                print("Unsynced: \(UnoloSDK.shared.getUnsyncedLocationCount())")
            }

            Button("Get Locations") {
                if let attendance = UnoloSDK.shared.lastAttendance() {
                    let locations = UnoloSDK.shared.getLocationsSince(timestamp: attendance.timestamp)
                    for loc in locations {
                        print("Lat: \(loc.latitude), Lon: \(loc.longitude), Time: \(loc.timestamp)")
                    }
                }
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

    // Start tracking
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

    // Stop tracking
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
                print("Lat: \(loc.latitude), Lon: \(loc.longitude), Time: \(loc.timestamp)")
            }
        }
    }

    // MARK: - UnoloSDKDelegate

    func unoloSDK(didUpdateLocation location: UnoloLocationModel) {
        print("Location: \(location.latitude), \(location.longitude)")
    }

    func unoloSDK(didFailWithError error: UnoloError) {
        print("Error: \(error.localizedDescription)")
    }

    func unoloSDK(didChangeTrackingStatus isTracking: Bool) {
        print("Tracking: \(isTracking)")
    }

    func unoloSDK(didChangePermissionStatus status: UnoloPermissionStatus) {
        print("Permission: \(status)")
    }
}
```

---

## 14. Troubleshooting

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
