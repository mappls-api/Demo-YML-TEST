# Changes to the MapplsMap SDK for iOS

## 5.13.8 - 30 May, 2023

### Added
- Domain of APIs changed.

## 5.13.7 - 02 May, 2023

### Optimization

- Performance improvements and optimization.
- fixed retry handler.

## 5.13.6 - 20 Mar, 2023

### Optimization

-  Performance improvements and optimization.

## 5.13.5 - 31 Jan, 2023

### Added

- A class `MapplsMapAuthenticator` can be used to initialize SDK using the method `initializeSDKSession`.

## 5.13.4 - 13 Oct, 2022

### Added
- On tap of any label on map delegate function `didTapPlaceWithMapplsPin` will be called to return `mapplsPin`.

### Changed
- An issue is fixed where tiles were not loading on initializing map at particular location.
- An issue is fixed where `didFinishLoadingStyle` function was calling two times on map initialization.
- Timeout interval is reduced for some of APIs to improve performance.

## 5.13.3 - 08 Sep, 2022

An issue resolved where tiles were not loading on CarPlay when phone is in locked state.

## 5.13.2 - 18 Aug, 2022

A Bug Resolved, session was not resetting if already a session is running. |

## 5.13.1 - 20 Jul, 2022

### Changed

- A Bug resolved of an error of "Duplicate bundle identifier of `MapmyIndiaAPIKit`" shows while uploading build on App Store.

## 5.13.0 - 11 Jun, 2022

Initial version of `MapplsMap`.

- Dependencies are `MapplsAPICore` and `MapplsAPIKit`.