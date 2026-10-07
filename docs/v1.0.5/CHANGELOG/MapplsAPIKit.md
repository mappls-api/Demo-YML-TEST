# Changes to the MapplsAPIKit SDK for iOS

## 2.0.9 - 02 Jan, 2023

### Added
- API wrapper added to get cost of tolls etc which can be consumed by Manager class `MapplsCostEstimationManager` and request class `MapplsCostEstimationOptions`.

## 2.0.8 - 09 Dec, 2022

### Fixed
- Issue of incorrect `Lanes` is fixed.
- A bug of ETA refresh is fixed where driving profile was not dynamic based on route requested.
- Turf code is refactored.

## 2.0.7 - 21 Oct, 2022

### Added
- Turf library related claasses are added.
- To get congestion delays for a route, a helper function `getCongestionDelays` added in class of MapplsDirectionUtility.

### Fixed
- For some of API managers host was not setting correctly on passing programmatically.

## 2.0.6 - 13 Oct, 2022

### Added
- A new property `richInfoDictionary` is added in response class of place detail request.
- As a new enum `MapplsRawInfoType` is added in Core SDK, A function `getRawInfo` is added in response class of place detail request to get specific dictionary object based on type.

### Changed
- Timeout interval is reduced for some of APIs to improve performance.

## 2.0.5 - 05 sept, 2022

### Added

- Introduced MapplsWeatherAPI. 


## 2.0.4 - 06 sept, 2022

### Added

- added a userActivity and media in respnse of placeDetails apis.

## 2.0.3 - 24 Aug, 2022

### Added

- added a parameter to set host and scheme in init method of manager class.

## 2.0.2 - 22 Aug, 2022

### Added

- In response of Reverse Geocode `areaCode` is added.

### Fixed

- Fixed a crash while using sharedInstance of `MapplsDirection` class.

## 2.0.1 - 05 Jul, 2022

### Added

- In response of Reverse Geocode `Mappls Pin` is added.

## 2.0.0 - 11 Jun, 2022

Initial version of `MapplsAPIKit`.

**Changes Since last version released:**

### Merged

- Direction/Route API sdk is merged into this and upcoming updates no longer will be avaialable separately.
- Dependency of `MapplsAPICore` is added.