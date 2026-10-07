# Changes to the MapplsUIWidgets SDK for iOS

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
