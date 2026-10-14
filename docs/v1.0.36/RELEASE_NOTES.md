# Mappls iOS SDK 1.0.35

Documentation: [`docs/v1.0.35/README.md`](docs/v1.0.35/README.md)

## Updated SDKs since v1.0.34

- **MapplsAPICore** 1.0.16 → 1.0.18
- **MapplsAPIKit** 2.0.32 → 2.0.38
- **MapplsAnnotationExtension** 1.0.1 → 1.0.3
- **MapplsDirectionUI** 1.0.10 → 1.0.11
- **MapplsMap** 5.13.16 → 6.0.2
- **MapplsNearbyUI** 1.0.1 → 1.0.3
- **MapplsUIWidgets** 1.0.12 → 1.0.15

## Unchanged SDKs

- MapplsDrivingRangePlugin 1.0.2
- MapplsFeedbackKit 2.0.0
- MapplsFeedbackUIKit 2.0.0
- MapplsGeoanalytics 1.0.0
- MapplsGeofenceUI 1.0.1
- MapplsIntouch 1.0.1
- MapplsTrackingPlugin 1.0.0

## Changelog

### MapplsAPICore

#### 1.0.18 (23 Jul 2026)

##### Changes
- Improvements and Bug Fixes.

### MapplsAPIKit

#### 2.0.38 (25 Sep, 2026)

##### Added
- Added a `responseLanguage` option to `MapplsNearbyAtlasOptions`, `MapplsTextSearchAtlasOptions`, and `MapplsPOIAlongTheRouteOptions` to request the response in a specified language.
- Added a `lang` property to the AutoSuggest (`MapplsAutoSuggestLocationResults`) and Nearby (`NearbyResult`) responses indicating the language of the returned results.
- Added an `isKeyword` property to `MapplsPlaceExplanation`.
##### Changed
- Renamed the `searchType` request parameter to `global` in `MapplsAutoSearchAtlasOptions`, `MapplsNearbyAtlasOptions`, `MapplsAtlasGeocodeOptions`, and `MapplsReverseGeocodeOptions`.
##### Removed
- Removed the unused internal `AutoSuggestResult` struct.

### MapplsAnnotationExtension

#### 1.0.3 (23 Jul 2026)

##### Changes
- Updated Map SDK.

#### 1.0.2 (25 Feb 2025)

##### Changes
- 'bitcode' disabled to support Xcode 15

### MapplsDirectionUI

#### 1.0.11 (07 Oct, 2026)

##### Added
- Added support for latest Mappls SDKs.

### MapplsMap

#### 6.0.2 (23 July 2026)

##### Changes
- Bug fixes and improvementes.

#### 6.0.1 (17 July 2026)

##### Changes
- Bug fixes and improvementes

#### 6.0.0 (06 Jun 2025)

##### Changes
- Updated minimum iOS deployment target to 13.0
- Authentication and authorization mechanisms have been revised.

### MapplsNearbyUI

#### 1.0.3 (07 Oct, 2026)

##### Changed
- Updated dependencies and build configuration for the legacy auth distribution.

#### 1.0.2 (25 Feb, 2025)

##### Changed
- 'bitcode' disabled to support Xcode 15.

### MapplsUIWidgets

#### 1.0.15 (06 Oct, 2026)

##### Changed
- Updated the release pipeline and build scripts for the MapplsUIWidgets SDK.

#### 1.0.14 (06 Oct, 2026)

##### Changed
- Restructured the project by flattening the directory layout and migrating dependency management from CocoaPods/Carthage to Swift Package Manager.

#### 1.0.13 (06 Apr, 2026)

##### Added
- Added venue highlight feature along with a sample.
- Added a delegate method to modify the request of autosuggest and text search.

##### Removed
- Removed the `hyperLocal` and `zoom` parameters from the request.
