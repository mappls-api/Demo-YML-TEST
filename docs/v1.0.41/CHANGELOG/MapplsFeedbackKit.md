# Changes to the MapplsFeedbackKit - SDK for iOS

## 2.0.1 - 21 Oct, 2026

- Builds against the legacy `MapplsAPICore` (`mappls-api-core-distribution`) `1.0.18`.
- SDK is distributed as an XCFramework through Swift Package Manager.
- Minimum supported iOS version is 15.0.

## 2.0.0 - 16 Nov, 2024

- `bitcode` is disabled to support Xcode 16.
- URL property for icon is set in responnse of Report Categories master to use in UI.

## 1.0.1 - 23 Sep, 2024

- Provision of callbacks is added by subscribing to different notifications `feedbackSubmitSuccessNotification`, `feedbackSubmitFailedNotification`, `reportCategoriesFetchSuccessNotification` and `reportCategoriesFetchFailedNotification`.

## 1.0.0 - 22 Jun, 2022

- Initial release.
