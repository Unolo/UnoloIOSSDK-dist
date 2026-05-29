# Unolo iOS SDK — Attendance integration guide

Punch-in / punch-out UI with GPS-validated selfie, optional odometer capture, geofence-based auto-attendance, and shift-aware real-time notifications. Builds on the base location-tracking SDK — adds the attendance UI surface and read access to `lastAttendance()` / `getAttendanceSince(timestamp:)`.

**Distribution:** XCFramework (`UnoloIOSSDK.framework`) via Swift Package Manager
**Current version:** `1.1.0`
**Bundle:** All internal dependencies auto-embedded — no extra deps required in host app

This guide assumes you've finished the [base location-tracking integration](./README.md). That covers `Info.plist` keys, Always permission flow, SDK init, and the basic tracking lifecycle. **Do that first.** This guide covers only the attendance-specific additions.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Add the dependency](#2-add-the-dependency)
3. [Initialize the SDK](#3-initialize-the-sdk)
4. [Common integration patterns](#4-common-integration-patterns)
5. [Public API reference](#5-public-api-reference)
6. [Errors](#6-errors)
7. [Troubleshooting](#7-troubleshooting)
8. [What's NOT in scope](#8-whats-not-in-scope)

---

## 1. Prerequisites

- Everything in [base SDK § Requirements](./README.md#1-requirements):
  - iOS 15.6+
  - Xcode 15.0+
  - Swift 5.9+
- **Google Maps API key** — required (the punch-in screen renders a map)
- **Attendance enabled server-side** for your company (Unolo provisions this — confirm with `support@unolo.com` and your `companyID`)
- **Info.plist keys**:
  - `NSLocationWhenInUseUsageDescription`
  - `NSLocationAlwaysAndWhenInUseUsageDescription`
  - `NSMotionUsageDescription`
  - `NSCameraUsageDescription` (selfie step)
  - `UIBackgroundModes` → `location` (for background tracking after Always grant)

### Google Maps API key

1. Create an API key at <https://console.cloud.google.com/apis/credentials>.
2. Enable the **Maps SDK for iOS** API on that project.
3. Restrict the key to your app's bundle identifier (iOS apps restriction).
4. Pass it to the SDK once, before presenting the attendance screen:

   ```swift
   UnoloSDK.provideGoogleMapsKey("YOUR_GOOGLE_MAPS_API_KEY")
   ```

Don't commit an unrestricted Maps key. Anyone who pulls your IPA can use it against your billing.

---

## 2. Add the dependency

### Swift Package Manager

In Xcode: **File → Add Package Dependencies** → paste:

```
https://github.com/Unolo/UnoloIOSSDK-dist.git
```

Pin to the latest tagged version (e.g. `1.1.0`). The SDK ships as `UnoloIOSSDK.framework` with **all internal dependencies auto-embedded** — your host app doesn't need to add them separately.

### Link the framework

Drag `UnoloIOSSDK.framework` into your target's **Frameworks, Libraries, and Embedded Content** section. Make sure **Embed & Sign** is selected.

### Imports

```swift
import UnoloIOSSDK
```

---

## 3. Initialize the SDK

The SDK is a singleton. Call `initialize(...)` once at app launch (typically in `AppDelegate.application(_:didFinishLaunchingWithOptions:)` or the equivalent `App` struct in SwiftUI):

```swift
import UnoloIOSSDK

UnoloSDK.provideGoogleMapsKey("YOUR_GOOGLE_MAPS_API_KEY")

UnoloSDK.shared.initialize(
    companyID: "4010",
    employeeID: "203706",
    licenseKey: "YOUR_LICENSE_KEY"
) { result in
    switch result {
    case .success:
        print("SDK initialized")
    case .failure(let error):
        print("SDK init failed: \(error.localizedDescription)")
    }
}
```

### What `initialize(...)` does internally

- Login via `sdkLogin` REST + Firebase custom-token sign-in (named `FirebaseApp`)
- Loads cached session if credentials match — skips the login round-trip on relaunch
- Wipes local state if `companyID` / `employeeID` / `licenseKey` changed (employee-switch migration)
- Registers Poppins font, sets `IQKeyboardManager`, installs `UNUserNotificationCenterDelegate` for foreground banner support
- Requests notification permission (`[.alert, .badge, .sound]`)
- Fetches server settings — populates `Utils.employeeRoster` (today's shift), `actionTriggers` (grace periods), `siteBasedAutoAttendance` (geofence sites)
- Kicks off `Utils.monitorGeofenceForAutoAttendance()` so Location-Based Auto Attendance triggers without waiting for a first manual punch
- Restores tracking state if the app was killed mid-session (`isAttendanceMarked` → resume)

The completion fires after the **settings fetch** completes on fresh install. On cached session it fires after manager setup but settings refresh continues in the background — call `refreshSettings(completion:)` explicitly if you need to wait for it.

### Mode parity with Android

iOS does **not** ship a `TrackingMode` enum like Android. The mode is implied by the server flag `Utils.isAttendanceModuleEnabled` (set inside `Utils.updateSettings(...)`):

- **Attendance enabled (server flag ON)** → use `presentAttendanceScreen(...)`. Calling `startLocationTracking(...)` returns `UnoloError.attendanceModuleEnabled`.
- **Attendance disabled (server flag OFF)** → use `startLocationTracking(...)` / `stopLocationTracking(...)`. `presentAttendanceScreen(...)` returns `UnoloAttendanceError.moduleNotEnabled`.

If the panel hasn't enabled attendance for your `companyID`, the server response omits the flag and the SDK falls back to programmatic tracking mode.

---

## 4. Common integration patterns

### 4.1 Launch the attendance home screen

```swift
UnoloSDK.shared.presentAttendanceScreen { result in
    switch result {
    case .success(let attendanceVC):
        // attendanceVC is a UINavigationController wrapping NewAttendanceVC.
        // Present modally, push, or embed — your choice.
        attendanceVC.modalPresentationStyle = .fullScreen
        self.present(attendanceVC, animated: true)
    case .failure(let error):
        print("Attendance not available: \(error.localizedDescription)")
    }
}
```

The SDK returns a `UIViewController` (specifically a `UINavigationController` wrapping `NewAttendanceVC`) configured with:

- White opaque nav bar (handled by `NavigationBarHandler`)
- `overrideUserInterfaceStyle = .light` to match the storyboard's hardcoded card backgrounds
- Status-bar style `.darkContent` for visibility on white nav bar
- All pushed children (Selfie capture, Odometer scanner, FaceDetection, DynamicForm placeholder) inherit the same chrome

Pre-conditions checked before `success` is returned:

- `UnoloSDK.shared.initialize(...)` completed — else `.sdkNotInitialized`
- `Utils.isAttendanceModuleEnabled == true` (set by `Utils.updateSettings` from server response) — else `.moduleNotEnabled`
- The host app has presented the returned VC — the SDK does not present itself

### 4.2 Embed the attendance VC in your own container

```swift
UnoloSDK.shared.presentAttendanceScreen { result in
    guard case .success(let attendanceVC) = result else { return }

    // Embed in a tab bar, child VC, or your own nav stack
    self.addChild(attendanceVC)
    self.containerView.addSubview(attendanceVC.view)
    attendanceVC.view.frame = self.containerView.bounds
    attendanceVC.didMove(toParent: self)
}
```

The returned VC is a fully-formed `UINavigationController` — you can either present it modally, push it on your own stack (extract the root VC first), or embed it as a child. The SDK's defensive light-mode + status-bar overrides apply at the VC level too, so embedding standalone is safe.

### 4.3 Observe attendance state

```swift
class MyVC: UIViewController, UnoloSDKDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        UnoloSDK.shared.delegate = self
    }

    // Tracking lifecycle
    func unoloSDK(didChangeTrackingStatus isTracking: Bool) {
        statusLabel.text = isTracking ? "Tracking active" : "Tracking stopped"
    }

    // Location updates (fires per-update while tracking)
    func unoloSDK(didUpdateLocation location: UnoloLocationModel) {
        // location.latitude, longitude, accuracy, speed, bearing, timestamp
    }

    // Permission changes
    func unoloSDK(didChangePermissionStatus status: UnoloPermissionStatus) { }

    // Errors (parity with Android setErrorListener)
    func unoloSDK(didFailWithError error: UnoloError) {
        print("SDK error: \(error.localizedDescription)")
    }
}
```

For point-in-time queries (no live stream):

```swift
// Snapshot of last record
let last = UnoloSDK.shared.lastAttendance()
if let last = last {
    let isPunchedIn = last.eventTypeID == 8
    print("\(isPunchedIn ? "Punched in" : "Punched out") at \(Date(timeIntervalSince1970: last.timestamp / 1000))")
}

// Quick boolean
let isPunchedIn = UnoloSDK.shared.isAttendanceMarked()
```

### 4.4 Read attendance history

```swift
// Since yesterday midnight
let cal = Calendar.current
let yesterday = cal.startOfDay(for: Date()).addingTimeInterval(-86400)
let startMs = yesterday.timeIntervalSince1970 * 1000

let records: [UnoloAttendanceModel] = UnoloSDK.shared.getAttendanceSince(timestamp: startMs)
for record in records {
    print("\(record.eventTypeID == 8 ? "IN " : "OUT") @ \(record.timestamp)")
}

// Or a fixed range
let startTs: Double = ...
let endTs: Double = ...
let inRange = UnoloSDK.shared.getAttendanceBetween(startTimestamp: startTs, endTimestamp: endTs)
```

Both functions read from local CoreData synchronously — available offline. Records are ordered oldest to newest.

`UnoloAttendanceModel` fields:

| Field | Type | Notes |
|---|---|---|
| `eventTypeID` | `Int` | `8` = punch-in, `9` = punch-out |
| `latitude` / `longitude` | `Double` | Stored as `Float` in CoreData (≈3 m precision) |
| `accuracy` / `speed` / `bearing` | `Double` | iOS CLLocation defaults — `-1` for unknown speed/bearing |
| `timestamp` | `Double` | Epoch ms |
| `isSynced` | `Bool` | `true` once Apollo GraphQL acks the insert |

### 4.5 Manual programmatic tracking (attendance disabled mode)

If the server has attendance disabled for your `companyID`, the attendance UI is unavailable. Use the base location-tracking surface instead:

```swift
UnoloSDK.shared.startLocationTracking { result in
    switch result {
    case .success: print("Tracking started")
    case .failure(let error): print(error.localizedDescription)
    }
}

UnoloSDK.shared.stopLocationTracking { _ in }
```

Calling these while `isAttendanceModuleEnabled == true` returns `UnoloError.attendanceModuleEnabled`.

### 4.6 Force a settings refresh

The SDK refreshes settings on every cold init. To refresh mid-session (e.g. after admin updates shift / restriction rules on the panel):

```swift
UnoloSDK.shared.refreshSettings { result in
    // After this completes, employeeRoster, actionTriggers, attendance sites are updated
}
```

A refresh re-arms `Utils.monitorGeofenceForAutoAttendance()` automatically, so geofence regions update if the panel adds/removes sites.

### 4.7 Manual data sync

The SDK syncs locations / events / attendance / app-state / activity opportunistically (lifecycle, network back, scheduled). To force a flush:

```swift
UnoloSDK.shared.syncNow()
```

Useful before app foreground exit or after a panel-side admin action.

---

## 5. Public API reference

### `UnoloSDK` (singleton)

Access via `UnoloSDK.shared`.

#### Initialization

| Method | Returns | Notes |
|---|---|---|
| `static func provideGoogleMapsKey(_ apiKey: String)` | — | Call once before `presentAttendanceScreen`. |
| `func initialize(companyID:employeeID:licenseKey:completion:)` | `Result<Bool, UnoloError>` | Fresh install: completes after settings load. Cached session: completes after manager setup. |
| `func isSDKInitialized() -> Bool` | Bool | |

#### Attendance UI

| Method | Returns | Notes |
|---|---|---|
| `func presentAttendanceScreen(completion:)` | `Result<UIViewController, UnoloAttendanceError>` | Returns a `UINavigationController` to present/embed. |
| `var isAttendanceModuleEnabled: Bool` | Bool | Set by server response. Read-only in normal use. |

#### Attendance state

| Method | Returns | Notes |
|---|---|---|
| `func isAttendanceMarked() -> Bool` | Bool | `true` if latest record is `eventTypeID == 8`. |
| `func lastAttendance() -> UnoloAttendanceModel?` | Optional | Latest record (any event type). |
| `func getAttendanceSince(timestamp:)` | `[UnoloAttendanceModel]` | Records since the given epoch-ms, oldest first. |
| `func getAttendanceBetween(startTimestamp:endTimestamp:)` | `[UnoloAttendanceModel]` | Records in a fixed range, oldest first. |
| `func getCurrentEmployeeID() -> String` | String | Cached from login response. |

#### Location tracking (programmatic mode only)

| Method | Returns | Notes |
|---|---|---|
| `func startLocationTracking(completion:)` | `Result<Bool, UnoloError>?` | Returns `.failure(.attendanceModuleEnabled)` when attendance UI is the active mode. |
| `func stopLocationTracking(completion:)` | Same | Same gate. |
| `func isCurrentlyTracking() -> Bool` | Bool | |
| `func getLastLocation() -> UnoloLocationModel?` | Optional | Persists across kill. |
| `func getUnsyncedLocationCount() -> Int` | Int | Backlog count. |
| `func getLocationsSince(timestamp:)` | `[UnoloLocationModel]` | |
| `var trackingState: UnoloTrackingState` | Enum | `.unauthenticated` / `.inactive` / `.active`. |

#### Sync + settings

| Method | Returns | Notes |
|---|---|---|
| `func syncNow()` | — | Triggers immediate flush of locations / events / attendance / app-state / activity. |
| `func refreshSettings(completion:)` | `Result<Bool, UnoloError>?` | Re-fetches server settings and re-arms auto-attendance geofences. |

#### Delegate

| Property | Type |
|---|---|
| `var delegate: UnoloSDKDelegate?` | Weak |

### Public types

| Type | Purpose |
|---|---|
| `UnoloAttendanceModel` | Snapshot of an attendance record (eventTypeID, lat/lon, accuracy, speed, bearing, timestamp, isSynced) |
| `UnoloLocationModel` | Snapshot of a location update |
| `UnoloError` | Base SDK errors (`.notInitialized`, `.locationPermissionDenied`, `.attendanceModuleEnabled`, `.networkError(...)`, ...) |
| `UnoloAttendanceError` | Attendance-specific errors (`.sdkNotInitialized`, `.moduleNotEnabled`) |
| `UnoloTrackingState` | `.unauthenticated`, `.inactive`, `.active` |
| `UnoloPermissionStatus` | Mirrors `CLAuthorizationStatus` |
| `UnoloSDKDelegate` | Callback protocol (didUpdateLocation, didFailWithError, didChangeTrackingStatus, didChangePermissionStatus) |

---

## 6. Errors

Errors flow through **two channels**:

1. **Direct return** — methods that take a completion handler return a `Result<T, UnoloError>` or `Result<T, UnoloAttendanceError>`. Branch on that.
2. **Delegate** — `UnoloSDKDelegate.unoloSDK(didFailWithError:)` fires for async errors (location service errors, sync failures, permission revocation during tracking).

### `UnoloError` cases

| Case | When | What to do |
|---|---|---|
| `.notInitialized` | Any public method called before `initialize(...)` completes | Wait for the init completion handler to fire. |
| `.locationPermissionDenied` | User denied Location, or revoked it mid-tracking | Open Settings. |
| `.locationServicesDisabled` | Device-level Location off | Settings → Privacy → Location Services. |
| `.networkError(String)` | Login / Firebase / GraphQL failed | Retry after network recovers. |
| `.apiError(statusCode, message)` | Server returned non-2xx | Inspect message; transient → retry, 401 → re-init. |
| `.encodingError` | CoreLocation → CoreData conversion failed | Rare — file a bug. |
| `.storageError(String)` | CoreData save failed | Disk pressure / migration issue. |
| `.attendanceModuleEnabled` | `startLocationTracking` called while attendance UI is active | Use `presentAttendanceScreen(...)` instead. |
| `.unknown(String)` | Last-resort wrapper | Inspect message. |

### `UnoloAttendanceError` cases

| Case | When | What to do |
|---|---|---|
| `.sdkNotInitialized` | `presentAttendanceScreen` before `initialize(...)` | Wait for init. |
| `.moduleNotEnabled` | Server flag off for this company | Open a ticket with `support@unolo.com`. |

---

## 7. Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `presentAttendanceScreen` returns `.moduleNotEnabled` | Server `isAttendanceModuleEnabled` flag off | Confirm with support; check `refreshSettings(...)` completion logs `isAttendanceModuleEnabled=true`. |
| Punch screen renders but the map is blank | Missing or restricted Maps API key | `UnoloSDK.provideGoogleMapsKey(...)` must run **before** `presentAttendanceScreen`. Confirm the **Maps SDK for iOS** API is enabled on the Cloud project and the key restriction lists your real bundle ID. |
| Auto-attendance never fires when entering a configured site | `Utils.locationBasedAutoAttendance` is `false` or `siteBasedAutoAttendance` is empty | Check console for `monitorGeofenceForAutoAttendance: locationBasedAutoAttendance=…, sites=…`. If `sites=0`, panel hasn't configured the site. If flag is `false`, panel's Mode dropdown isn't set to "Location Based Auto Attendance". |
| Auto-attendance fires but no banner appears in foreground | Notification permission denied OR `UNUserNotificationCenter.current().delegate` overwritten | SDK installs its own delegate only if `delegate == nil`. If your host app sets a delegate, implement `willPresent` to return `[.banner, .sound, .badge]`. Confirm permission: `Settings → TestApp → Notifications`. |
| Auto-attendance fires but tracking doesn't start in background | Permission is "While Using App", not "Always" | iOS suspends location updates in background under WhenInUse. SDK auto-prompts for upgrade on `appDidEnterBackground` when `isAttendanceMarked + WhenInUse`. Accept the prompt → `didChangeAuthorization(.authorizedAlways)` fires → `resumeTrackingAfterKill()` starts tracking. |
| Manual punch button shows "Need Always permission" popup | `Utils.updateFreq != -1` + WhenInUse | Force-quit + reopen + grant Always when iOS reprompts; or set `updateFreq = -1` on the panel to allow WhenInUse-only operation (no continuous tracking). |
| Selfie step fails / crashes on simulator | MLKit static binaries lack arm64-simulator slice | Test on real device, or run simulator under Rosetta (right-click app → Get Info → "Open using Rosetta"). |
| Build fails: "Polyline.swiftinterface: 'LocationCoordinate2D' is not a member type" | Polyline 5.1.0 swiftinterface verification bug with `BUILD_LIBRARY_FOR_DISTRIBUTION=YES` | `build_xcframework.sh` already passes `SWIFT_VERIFY_EMITTED_MODULE_INTERFACE=NO + -no-verify-emitted-module-interface` to work around this. Don't strip those flags. |
| `presentAttendanceScreen` succeeds but VC is blank / hangs on settings | First-install settings race | Fix already in place — `initialize(...)` completion waits for `refreshSettings` on fresh install. If you patched it out, restore. |

---

## 8. What's NOT in scope

The iOS SDK migration intentionally **excludes** these bherubaba modules. Calling related APIs will be a no-op or hit a stub:

- **Chat / Messaging** — `MessageCDHelper`, `ChatViewModel`
- **Task module** — `TaskCDHelper`, `NewTaskBaseVC`, `RealTimeTaskManager`
- **Expense + Conveyance** — `NewAddExpenseVC`, auto-conveyance odometer post
- **Leave / Holiday** — leave application UI
- **Employee Dashboard** — calendar, leave/expense stats card (host-app responsibility)
- **Order / Inventory** — `NewOrderListVC`, `NewAddOrderVC`
- **Client + Sitepool management** — read-only via attendance restriction sites only
- **Custom Fields** — generic form rendering
- **Shared Travel** — joint travel coordination
- **Dynamic Forms** — ships as a "Form Module not available in SDK" placeholder VC (Phase 7 deferred). Form template lookup + rendering not migrated. Toggle the panel flag off until a future SDK release adds it.

If your app depends on any excluded module, keep that surface in the host app — the SDK doesn't gate it. The attendance flow itself does **not** depend on any excluded module.

---

## Quick start (TL;DR)

```swift
import UnoloIOSSDK

// 1. Pre-init
UnoloSDK.provideGoogleMapsKey("YOUR_MAPS_KEY")

// 2. Init at app launch
UnoloSDK.shared.initialize(
    companyID: "4010",
    employeeID: "203706",
    licenseKey: "YOUR_LICENSE_KEY"
) { result in
    if case .success = result {
        // Ready
    }
}

// 3. Present attendance UI from any VC
UnoloSDK.shared.presentAttendanceScreen { result in
    if case .success(let vc) = result {
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

// 4. Read state
let isIn = UnoloSDK.shared.isAttendanceMarked()
let last = UnoloSDK.shared.lastAttendance()
let history = UnoloSDK.shared.getAttendanceSince(timestamp: yesterdayMs)
```

That's the full integration surface. For everything else (location tracking, error handling, lifecycle hooks), the SDK runs internally — observe via `UnoloSDKDelegate` or query state via the methods above.
