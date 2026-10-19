# Mappls iOS SDK 1.0.37

Documentation: [`docs/v1.0.37/README.md`](docs/v1.0.37/README.md)

## Updated SDKs since v1.0.36

- **MapplsAPIKit** 2.0.38 → 2.0.39
- **MapplsNearbyUI** 1.0.3 → 1.0.4
- **MapplsUIWidgets** 1.0.15 → 1.0.16

## Changelog

### MapplsAPIKit

#### 2.0.39 (19 Oct, 2026)

##### Added
- **Language support for routing (`RouteOptions.lang`).** Added a new optional `lang` (`String?`) request parameter to `RouteOptions`. When set, it is sent as the `lang` query parameter so turn-by-turn and visual routing instructions can be returned in the requested language. When left `nil`, the parameter is omitted and the server default is used.

##### Changed
- **`MapplsPOIAlongTheRouteOptions.responseLanguage` is now a `String?` (breaking).** The property changed from `Bool` to `String?`. Previously it was a flag that sent an empty `responseLang` query value; it now sends the language code you provide (for example `"hi"` or `"en"`). When `nil`, the `responseLang` parameter is omitted entirely.
  - Migration: replace `options.responseLanguage = true` with a language code, e.g. `options.responseLanguage = "hi"`, and remove any `options.responseLanguage = false` assignments (the default `nil` already skips the parameter).
- **Boolean flags on `RouteOptions` are now non-optional and Objective-C visible (breaking).** `instructions`, `skipWaypoints`, `tollPass`, and `eType` changed from optional `Bool?` to non-optional `@objc Bool` defaulting to `false`. Each flag is now included in the request only when set to `true`, and all four are accessible from Objective-C.
  - Migration: Swift callers that assigned `nil` should now rely on the `false` default; callers that read these as optionals should treat them as plain `Bool`.
- Removed the always-on `language` query parameter from the base `DirectionsOptions` request so routing language is controlled explicitly via `RouteOptions.lang` instead of being derived from the device locale on every request.

### MapplsNearbyUI

#### 1.0.4 (19 Oct, 2026)

##### Changed
- Updated minimum iOS deployment target to iOS 13.0.
- Updated dependency `MapplsAPIKit` to `2.0.39`.
- Updated dependency `MapplsUIWidgets` to `1.0.16`.

### MapplsUIWidgets

#### 1.0.16 (19 Oct, 2026)

##### Added
- Added a `global` property to `MapplsAutocompleteFilter` to request global autosuggest results.

##### Removed
- Removed the `hyperLocal` property from `MapplsAutocompleteFilter`.

##### Changed
- Bumped the minimum `MapplsAPIKit` dependency to `2.0.39`.
