# Mappls iOS SDK 1.0.38

Documentation: [`docs/v1.0.38/README.md`](docs/v1.0.38/README.md)

## Updated SDKs since v1.0.37

- **MapplsAnnotationExtension** 1.0.3 → 1.0.4
- **MapplsDirectionUI** 1.0.11 → 1.0.12
- **MapplsFeedbackKit** 2.0.0 → 2.0.1
- **MapplsFeedbackUIKit** 2.0.0 → 2.0.1
- **MapplsGeofenceUI** 1.0.4 → 1.0.7

## Changelog

### MapplsAnnotationExtension

#### 1.0.4 (21 Oct, 2026)

##### Changed

- Updated to the latest Mappls SDK dependencies (MapplsAPICore 1.0.18, MapplsAPIKit 2.0.39).
- Raised the minimum iOS deployment target to 13.0.

### MapplsDirectionUI

#### 1.0.12 (19 Oct, 2026)

##### Added
- Added `resetDirectionsUI()` in `MapplsDirectionViewController`.
- Added accessibility labels for map control buttons.

##### Changed
- `restDirectionsUI()` is deprecated, use `resetDirectionsUI()` instead.

##### Fixed
- Fixed crashes from unknown location authorization status, missing routes and out-of-range route indexes.
- Fixed toll cost estimation finishing before results arrived on iOS 14 and below.
- Fixed older route responses overwriting newer routes.
- Fixed via points given as Mappls Pin being plotted at the source location.
- Fixed placeholder distance shown on the add waypoint panel.

### MapplsFeedbackKit

#### 2.0.1 (21 Oct, 2026)

- Builds against the legacy `MapplsAPICore` (`mappls-api-core-distribution`) `1.0.18`.
- SDK is distributed as an XCFramework through Swift Package Manager.
- Minimum supported iOS version is 15.0.

### MapplsFeedbackUIKit

#### 2.0.1 (21 Oct, 2026)

- Built against the legacy `MapplsAPICore` (`mappls-api-core-distribution`) `1.0.18` and `MapplsFeedbackKit` `2.0.1`.
- SDK is distributed as an XCFramework through Swift Package Manager.
- Minimum supported iOS version is 15.0.

### MapplsGeofenceUI

#### 1.0.7 (21 Oct, 2026)

##### Changed
- Updated to the latest dependencies.
