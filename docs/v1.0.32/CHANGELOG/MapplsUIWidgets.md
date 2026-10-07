# Changes to the MapplsUIWidgets SDK for iOS

## 1.0.10 - 17 Dec, 2024

### Added
- Added option to set base url for search and reversegeocode

## 1.0.9 - 24 Oct, 2024

### Added
- Bitcode disabled to support Xcode 16.

### Changed
- For PlacePicker set property 'attributions' of 'MapplsAutocompleteFilter' to true by default.
- In PlacePicker on Autosuggest logic is improved to set name of place.


## 1.0.8 - 09 Oct, 2024

### Added
- Support is added for Landscape mode.

### Fixed
- Bugs fixed.

## 1.0.7 - 17 Sep, 2024

### Added
- In Autosuggest Widget, option to set type of logo is added. A in class of `MapplsAttributionsSettings` whose instance is used to configure Autosuggest Widget.

## 1.0.6 - 08 May, 2024

### Added
- Option to show building boundry for sselected place.

### Changed
- Logic is optimized to show name and address of place.

## 1.0.5 - 28 Nov, 2023

### Added
- Added a provision to change highlighted color of cell.

## 1.0.4 - 11 June, 2023

### Added
- Added a `theme` property in init function of `MapplsAutocompleteViewController` its default value is `auto` it expeted values are auto, day, night
- Added callback for selected favourite item.


## 1.0.3 - 02 June, 2023

### Added
- Added functionality to show favourites/custom places in Autosuggest Widget. 
- Added callback for selected favourite item.

### Changed

- Callbacks are modified of selected place of autosuggest. One property `resultType` of type `MapplsAutosuggestResultType`is added in delegate function. See documentation for more details.

## 1.0.2 - 02 May, 2023

### Added
- Added `debounceInterval` property in `MapplsAutocompleteViewController` class. its default value is `0` its value is in milisecond
- Added `responseLanguage` property in `MapplsAutocompleteFilter` class.

## 1.0.1 - 03 sept, 2022

### Added
- Added `hyperLocal` property in `MapplsAutocompleteFilter` class.

## 1.0.0 - 12 June, 2022

### Changed

- Initial MAPPLS's release with renaming.
- One Dependency `MapplsAPICore` is added along with `MapplsAPIKit` and `MapplsMap`.
