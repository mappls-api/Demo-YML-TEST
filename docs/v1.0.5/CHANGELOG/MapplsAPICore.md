# Changes to the MapplsAPICore SDK for iOS

## 1.0.4 - 09 Dec, 2022

### Changed
- A custom property `modelName` of extension `UIDevice` is made public.

## 1.0.3 - 13 Oct, 2022

### Changed
- Timeout interval is reduced for some of APIs to improve performance.
- A new enum `MapplsRawInfoType` is added.

## 1.0.2 - 23 Aug, 2022

### Fixed
- Fixed a crash while using `MapplsTokenAuthenticationAPISharedManager` in `MapplsLicenseInterceptor` class.

## 1.0.1 - 17 Aug, 2022

### Added
- Introduced a property `isEnableLogging` In MapplsAccountManager
- On the based of Who am i respose region is set in MapplsAccountManage.

## 1.0.0 - 10 June, 2022

Initial version of `MapplsAPICore`.