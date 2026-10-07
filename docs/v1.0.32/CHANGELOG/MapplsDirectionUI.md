# Changes to the MapplsDirectionUI SDK for iOS

## 1.0.9 - 17 Dec, 2024

### Added
- Added support for letest Mappls SDKs.
- Added provision to change the base url of routing and search apis.
- direction list ui enchancement
- added support for manuever image

## 1.0.8 - 27 Dec, 2023

### Added
- Added dotted polyline for walking profile.

### Fixed
- Bug fixes.

## 1.0.7 - 11 Oct, 2023

### Added
- Added support for `Light`, `Dark` and `Auto` theme 
- Fixed a crash on route preview.



## 1.0.6 - 24 Aug, 2023

### Added
- Added callbacks 'removeViaPointButtonClicked' which called on click of clear button.
- Added callback function 'expandView' which called on expanding collapsed view in case of via points.

### Fixed 
- Fixed an issue where on click of button of "View on Map", It was calling function multiple times.
- On removing via point route is refreshed.
- Delegate function 'addViaPointButtonClicked' is called on click of '+' button.

## 1.0.5 - 02 Aug, 2023

### Added
- Added a drivingMode selector view  
- added support for landscape mode
- added `MapplsDirectionUIConfiguration` class to configure `DirectionViewController`.

### Fixed 
- Route first step is added in direction list.
 

## 1.0.4 - 03 May, 2023
### Added
- Added a retry UI on direction screen 
- Added a delegate to provide option for route request


## 1.0.3 - 03 May, 2023
### Added
- Added a retry UI on direction screen 
- Added a delegate to provide option for route request

### Fixed

- Fixed UI on preview screen.


## 1.0.2 - 17 April, 2023

### Changed

- added a parameter `viewController` of type `UIViewController` in a delegate function (didRequestForStartNavigation) of `MapplsDirectionViewController`

### Added:

- Added a overlay screen while requesting for route
- Some UI Enchancment
- Introduced a property `shouldShowTollCostEstimation` to show toll information its default value is `false`
- Introduced a property `shouldShowRouteReportSummary` to show routeReportSummary information, its default value is `false`
- Introduced a property `isShowCongestionDelayOnRoute` to show congestion delay information on route, its default value is `false`

### Fixed
- Bug fixes and improvements.

## 1.0.1 - 22 Jun, 2022

### Changed

- Added Objective c support. and Added directionListDefault button.

## 1.0.0 - 14 Jun, 2022

### Changed

- Initial release as per Mappls branding.
  
