# Mappls iOS SDK 1.0.36

Documentation: [`docs/v1.0.36/README.md`](docs/v1.0.36/README.md)

## What's included

- **MapplsAPICore** 1.0.18
- **MapplsAPIKit** 2.0.38
- **MapplsAnnotationExtension** 1.0.3
- **MapplsDirectionUI** 1.0.11
- **MapplsDrivingRangePlugin** 1.0.2
- **MapplsFeedbackKit** 2.0.0
- **MapplsFeedbackUIKit** 2.0.0
- **MapplsGeoanalytics** 1.0.0
- **MapplsGeofenceUI** 1.0.1
- **MapplsIntouch** 1.0.1
- **MapplsMap** 6.0.2
- **MapplsNearbyUI** 1.0.3
- **MapplsTrackingPlugin** 1.0.0
- **MapplsUIWidgets** 1.0.15

## Changelog by module

### MapplsAPICore — 1.0.18 (23 Jul 2026)

### Changes
- Improvements and Bug Fixes.

### MapplsAPIKit — 2.0.38 (25 Sep, 2026)

### Added
- Added a `responseLanguage` option to `MapplsNearbyAtlasOptions`, `MapplsTextSearchAtlasOptions`, and `MapplsPOIAlongTheRouteOptions` to request the response in a specified language.
- Added a `lang` property to the AutoSuggest (`MapplsAutoSuggestLocationResults`) and Nearby (`NearbyResult`) responses indicating the language of the returned results.
- Added an `isKeyword` property to `MapplsPlaceExplanation`.
### Changed
- Renamed the `searchType` request parameter to `global` in `MapplsAutoSearchAtlasOptions`, `MapplsNearbyAtlasOptions`, `MapplsAtlasGeocodeOptions`, and `MapplsReverseGeocodeOptions`.
### Removed
- Removed the unused internal `AutoSuggestResult` struct.

### MapplsAnnotationExtension — 1.0.3 (23 Jul 2026)

### Changes
- Updated Map SDK.

### MapplsDirectionUI — 1.0.11 (07 Oct, 2026)

### Added
- Added support for latest Mappls SDKs.

### MapplsDrivingRangePlugin — 1.0.2 (29 Jun, 2023)

#### Changed

- API wrappers are moved to MapplsAPIKit and so minimum dependency changed.

### MapplsFeedbackKit — 2.0.0 (16 Nov, 2024)

- URL property for icon is set in responnse of Report Categories master to use in UI.

### MapplsFeedbackUIKit — 2.0.0 (16 Nov, 2024)

- UI screen is changed.
- URL property for icon is used to show icon for Report Categories.

### MapplsGeoanalytics — 1.0.0 (20 Jun, 2022)

### Changed

- Initial Mappls release.

### MapplsGeofenceUI — 1.0.1 (01 Nov, 2022)

### Changed

- Bug fixes due to dependency of APIKit version 2.0.7

### MapplsIntouch — 1.0.1 (24 Mar, 2023)

### Fixes

- Some fixes are done in result of `getDevices` and `getLocationsEvent`.

### MapplsMap — 6.0.2 (23 July 2026)

### Changes
- Bug fixes and improvementes.

### MapplsNearbyUI — 1.0.3 (07 Oct, 2026)

### Changed
- Updated dependencies and build configuration for the legacy auth distribution.

### MapplsTrackingPlugin — 1.0.0 (23 Dec, 2025)

### Changed

- Initial Mappls release.

### MapplsUIWidgets — 1.0.15 (06 Oct, 2026)

### Changed
- Updated the release pipeline and build scripts for the MapplsUIWidgets SDK.
