# Changelog for Mappls Map SDK for iOS

## 7.0.2

### 🐞 Bug fixes

- Fixed `#import <MapplsMap/MapplsMap.h>` failing with "file not found" in 7.0.1. The
  framework contains `MapplsMap.h` again, as in 6.x, so Objective-C code written for 6.x
  compiles without changes. `@import MapplsMap;` and Swift's `import MapplsMap` work as
  before.

## 7.0.1

### ⬆️ Upgrading from 6.x

- This is a new major version, so your dependency rule doesn't pick it up on its own:
  - CocoaPods: change your `Podfile` to `pod 'MapplsMap', '7.0.1'` and run
    `pod update MapplsMap`.
  - Swift Package Manager: set the `MapplsMap` package to **Exact Version** `7.0.1` (or **Up
    to Next Major Version** from `7.0.1`).
- **CocoaPods: `MapplsAPICore` and `MapplsAPIKit` are no longer installed with `MapplsMap`.**
  Add them to your `Podfile` next to `MapplsMap`, otherwise the app crashes at launch with
  `dyld: Library not loaded: @rpath/MapplsAPICore.framework/MapplsAPICore`:

  ```ruby
  pod 'MapplsMap', '7.0.1'
  pod 'MapplsAPICore', '1.0.18'
  pod 'MapplsAPIKit', '2.0.39'
  ```

### ✨ Improvements

- Updated the map rendering engine, with performance improvements and bug fixes.
- Added `BuildingMapPlugin` to hide and show the 3D buildings on the map, for the whole map
  or at a coordinate.
- Added `MapplsMapView.getAvailableMapplsMapStyle()`, which returns the Mappls styles
  available to your account once authorization has completed.

### 🐞 Bug fixes
- Fixed mapplsPin issue in UserLocation.
- Fixed map labels in regional languages, such as Hindi, being shown on a single line. Long
  labels in these languages now wrap onto several lines, like labels in English.
