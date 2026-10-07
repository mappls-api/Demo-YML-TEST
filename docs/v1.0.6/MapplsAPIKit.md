[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# [MapplsAPIKit (REST API Kit for iOS)]()

## [Introduction](#Introduction)

Our APIs, SDKs, and live updating map data available for [200+ countries & territories](https://github.com/MapmyIndia/mapmyindia-rest-api/blob/master/docs/countryISO.md) give developers tools to build better experiences across various platforms.

1. You can get your api key to be used in this document here: [https://apis.mappls.com/console/](https://apis.mappls.com/console/)

2. The sample code is provided to help you understand the basic functionality of Mappls REST APIs working on iOS native development platform. 

## [Installation](#Installation)

This library is available through `CocoaPods`. To install, simply add the following line to your `podfile`:

```ruby
pod 'MapplsAPIKit', '2.0.9'
```

Run pod repo update && pod install and open the resulting Xcode workspace.

### [Dependencies](#Dependencies)

This library depends upon `MapplsAPICore`. All dependent libraries will be automatically installed on using CocoaPods.

## [Version History](#Version-History)

| Version | Dated | Description |
| :---- | :---- | :---- |
| `2.0.10` | 30 Jan 2023 | - Error code opimization for initializing Map.|
| `2.0.9` | 02 Jan 2023 | - API wrapper added to get cost of tolls etc which can be consumed by Manager class `MapplsCostEstimationManager` and request class `MapplsCostEstimationOptions`.|
| `2.0.8` | 09 Dec 2022 | - Issue of incorrect `Lanes` is fixed. A bug of ETA refresh is fixed where driving profile was not dynamic based on route requested. Turf code is refactored.|
| `2.0.7` | 21 Oct 2022 | - Function added to calculate congestion delays. Host issue is resolved. Turf library's source code added.|
| `2.0.6` | 13 Oct 2022 | - Some performance improvements and optimization.|
| `2.0.5` | 28 Sept 2022 | - Added weather api.|
| `2.0.4` | 06 Sept 2022 | - Added userActivity and media in response of placeDetails.|
| `2.0.3` | 24 Aug 2022 | - added a parameter to set host and scheme in init method of manager class.|
| `2.0.2` | 22 Aug 2022 | - In response of Reverse Geocode `areaCode` is added and Fixed a crash while using shared instance of MapplsDirection class.|
| `2.0.1` | 05 Jul 2022 | In response of Reverse Geocode `Mappls Pin` is added.|
| `2.0.0` | 11 Jun 2022 | Initial release with `Mappls` branding and merging of Directions SDK. Supports Xcode 13+.|

## [Getting Started](#Getting-Started)

Mappls Map SDK for iOS lets you easily add Mappls Map and services to your own iOS app.It supports iOS SDK 9.0 and above and Xcode 10.1 or later. You can have a look at the map and features you will get in your own app by using the Mappls Map app for iOS. The SDK handles Map Display along with a bunch of controls and native gestures.

## [Authorization](#Authorization)

### [MapplsAPICore](#MapplsAPICore)
It is required to set Mappls keys and authenticate before using any Mappls SDK. Please see the reference [here](MapplsAPICore.md).

## [API Usage and Requirements](#API-Usage-and-Requirements)

The allowed SDK hits are described on the plans page. Note that your usage is shared between platforms, so the API hits you make from a web application, Android app or an iOS app all add up to your allowed daily limit.

## [Autosuggest API](#Autosuggest-API)

Get "type as you go" suggestion while searching for a location.

The Autosuggest API helps users to complete queries faster by adding intelligent search capabilities to your web or mobile app. This API returns a list of results as well as suggested queries as the user types in the search field.

For live demo click [LIVE DEMO](https://about.mappls.com/api/advanced-maps/doc/sample/mapmyindia-maps-auto-suggest-api-example.php)

The Autosuggest helps users to complete queries faster by adding intelligent search capabilities to your iOS mobile app. It takes a human readable query such as place name, address or Mappls Pin and returns a list of results.

Class used for Autosuggest search is `MapplsAutoSuggestManager`. Create a `MapplsAutoSuggestManager` object using your rest key or alternatively, you can place your rest key in the `MapplsRestKey` key of your application's Info.plist file, then use the shared instance of `MapplsAutoSuggestManager` class.

To perform auto suggest use `MapplsAutoSearchAtlasOptions` class to pass query parameter to get auto suggest search with an option to pass region in parameter `withRegion`, which is an enum of type `MapplsRegionType`. If no value is passed for region, It will take default value which is India.

`MapplsRegionType` is used to validate and get result for different countries availble with Mappls [200+ countries & territories](https://github.com/MapmyIndia/mapmyindia-rest-api/blob/master/docs/countryISO.md)

Additionally you can also set location and restriction filters in object of `MapplsAutoSearchAtlasOptions`. 

### Request Parameters

1.  **location:**  Location is required to get location bias autosuggest results.
2.  **zoom:**  takes the zoom level of the current scope of the map (min: 4, max: 18).
3.  **includeTokenizeAddress**: On setting value of this property to true it provides the different address attributes in a structured object in response.
4.  **pod**: It takes place type which helps in restricting the results to certain chosen type  
    Below mentioned are the codes for the pod -
    -   Sublocality
    -   Locality
    -   City
    -   Village
    -   Subdistrict
    -   District
    -   State
    -   Subsublocality
5.  **filter**: This helps you restrict the result either by mentioning a bounded area or to certain Mappls Pin. Below mentioned are both types whose instance can be set to this parameter -
    -   (a) `MapplsMapplsPinFilter`: to filter results on basis of Mappls Pin.
    -   (b) `MapplsBoundsFilter`: to filter results on basis of geo bound. It accepts a value of type `MapplsRectangularRegion`.
6. **hyperLocal**: This parameter lets the search give results that are hyper-localized to the reference location passed in the location parameter. This means that nearby results are given a higher ranking than results far from the reference location. Highly prominent results will still appear in the search results, however they will be lower in the list of results. This parameter will work ONLY in conjunction with the location parameter.
7.  **isBridgeEnabled:**  To get suggested searches in response. Value must be set `true` of this.

### Response Parameters

In response of auto suggest search either you will receive an error or an object of `MapplsAutoSuggestLocationResults`(derived from `MapplsLocationResults`) which contains an array of `MapplsAtlasSuggestion` (derived from `MapplsSuggestion`) and an array of suggested searches of type `MapplsSearchPrediction`.

***Note:*** As class of response object will be derived from `MapplsLocationResults`, You will need to cast it into `MapplsAutoSuggestLocationResults`.

You will find below useful properties in suggestion object :

1.  **type:**  type of location POI or Country or City
2.  **mapplsPin:**  Mappls Pin of the location 6-char alphanumeric.
3.  **placeAddress:**  Address of the location.
4.  **latitude:**  Latitude of the location.
5.  **longitude:**  longitude of the location.
6.  **entranceLatitude:**  entry latitude of the location
7.  **entrancelongitude:**  entry longitude of the location
8.  **placeName:**  Name of the location.
9.  **orderIndex:**  the order where this result should be placed
10. **addressTokens**:

    **houseNumber**: house number of the location.

	**houseName**: house name of the location.

	**poi**: name of the POI (if applicable)

	**street**: name of the street. (if applicable)

	**subSubLocality**: the sub-sub-locality to which the location belongs. (if applicable)

	**subLocality**: the sub-locality to which the location belongs. (if applicable)

	**locality**: the locality to which the location belongs. (if applicable)

	**village**: the village to which the location belongs. (if applicable)

	**subDistrict**: the sub-district to which the location belongs. (if applicable)

	**district**: the district to which the location belongs. (if applicable)

	**city**: the city to which the location belongs. (if applicable)

	**state**: the state to which the location belongs. (if applicable)

	**pincode**: the PIN code to which the location belongs. (if applicable)
  
***Note:*** Values of `latitude`, `longitude`, `entranceLatitude` and `entrancelongitude` will depend upon claims provided on `Keys`.

### [Code Samples]()

#### Objective C
```objectivec
MapplsAutoSuggestManager * autoSuggestManager = [MapplsAutoSuggestManager sharedManager];
// or
MapplsAutoSuggestManager *autoSuggestManager = [[MapplsAutoSuggestManager alloc] initWithRestKey:MapplsAccountManager.restAPIKey clientId:MapplsAccountManager.atlasClientId clientSecret:MapplsAccountManager.atlasClientSecret grantType:MapplsAccountManager.atlasGrantType];

MapplsAutoSearchAtlasOptions * autoSuggestOptions = [[MapplsAutoSearchAtlasOptions alloc] initWithQuery:@"mmi000" withRegion:MapplsRegionTypeIndia];
autoSuggestOptions.location = [[CLLocation alloc] initWithLatitude:28.2323234 longitude:72.3434123];
autoSuggestOptions.zoom = [[NSNumber alloc] initWithInt:5];
[autoSuggestManager getAutoSuggestionResultsWithOptions:autoSuggestOptions completionHandler:^(MapplsLocationResults * _Nullable locationResults, NSError * _Nullable error) {
	if (error) {
    	NSLog(@"%@", error);
    } else if (locationResults) {
        MapplsAutoSuggestLocationResults * results = (MapplsAutoSuggestLocationResults *) locationResults;
        if(results && results.suggestions) {
            for (MapplsAtlasSuggestion * suggestion in results.suggestions) {
                NSLog(@"Auto Suggest %@%@", suggestion.latitude, suggestion.longitude);
            }
        }
        if(results && results.suggestedSearches) {
            for (MapplsSearchPrediction * suggestion in results.suggestedSearches) {
                NSLog(@"Auto Suggest %@", suggestion.identifier);
            }
        }
    } else {
    	NSLog(@"No Results");
    }
}];
```
#### Swift
```swift
let autoSuggestManager = MapplsAutoSuggestManager.shared
//Or
let autoSuggestManager = MapplsAutoSuggestManager(restKey:
MapplsAccountManager.restAPIKey(), clientId:
MapplsAccountManager.atlasClientId(), clientSecret:
MapplsAccountManager.atlasClientSecret(), grantType:
MapplsAccountManager.atlasGrantType())

let autoSearchAtlasOptions = MapplsAutoSearchAtlasOptions(query: "mmi000",
withRegion: .india)
autoSearchAtlasOptions.location = CLLocation(latitude: 28.2323234, longitude: 72.3434123)
autoSearchAtlasOptions.zoom = 5
autoSuggestManager.getAutoSuggestionResults(autoSearchAtlasOptions) { (locationResults, error) in
	if let error = error {
		print("error: \(error.localizedDescription)")
	} else if let locationResults = locationResults as? MapplsAutoSuggestLocationResults {
		if let suggestions = locationResults.suggestions {
			for suggestion in suggestions {
				print("suggestion: \(suggestion.placeName)")
            }
        }
        if let suggestions = locationResults.suggestedSearches {
            for suggestion in suggestions {
                print("suggestedSearches: \(suggestion.identifier)")
            }
        }
    } else {
        print("No Results")
    }
}
```

For more details visit our [api reference documentation](https://about.mappls.com/api/advanced-maps/doc/autosuggest-api#/Autosuggest%20API/AutoSuggestAPI).

## [Reverse Geocoding API](#Reverse-Geocoding-API)

For live demo click [LIVE DEMO](https://about.mappls.com/api/advanced-maps/doc/sample/mapmyindia-maps-reverse-geocoding-rest-api-example)

Gets the nearest address for a given lat long combination.

Reverse Geocoding is a process to give the closest matching address to a provided geographical coordinates (latitude/longitude). Mappls's reverse geocoding API provides real addresses along with nearest popular landmark for any such geo-positions on the map.

Class used for geocode is `MapplsReverseGeocodeManager`. Create a `MapplsReverseGeocodeManager` object using your rest key or alternatively, you can place your rest key in the `MapplsRestKey` key of your application's Info.plist file, then use the shared instance of `MapplsReverseGeocodeManager` class.

To perform the translation use `MapplsReverseGeocodeOptions` class to pass coordinates as parameters to reverse geocode with an option to pass region in parameter `withRegion`, which is an enum of type `MapplsRegionType`. If no value is passed for region, It will take default value which is India.

`MapplsRegionType` is used to validate and get result for different countries. 

### Response Parameters

In response of geocode search either you will receive an error or an array of `MapplsGeocodedPlacemark`. Yo will find below useful properties in suggestion object:

-   **houseNumber:**  The house number of the location.
-   **houseName:**  The name of the location.
-   **poi:**  The name of the POI if the location is a place of interest (POI).
-   **poiDist:**  distance from nearest POI in metres.
-   **street:**  The name of the street of the location.
-   **streetDist:**  distance from nearest Street in metres.
-   **subSubLocality:**  The name of the sub-sub-locality where the location exists.
-   **subLocality:**  The name of the sub-locality where the location exists.
-   **locality:**  The name of the locality where the location exists.
-   **village:**  The name of the village if the location exists in a village.
-   **district:**  The name of the district in which the location exists.
-   **subDistrict:**  The name of the sub-district in which the location exists.
-   **city:**  The name of the city in which the location exists.
-   **state:**  The name of the state in which the location exists.
-   **pincode:**  The pin code of the location area.
-   **latitude:**  The latitude of the location.
-   **longitude:**  The longitude of the location.
-   **formattedAddress:**  The complete human readable address string that is usually the complete postal address of the result.
-   **areaCode:**  The area code of region.
-   **area:** in-case the co-ordinate lies in a country the name of the country would be returned or if the co-ordinate lies in an ocean, the name of the ocean will be returned.  

### Code Samples

#### Objective C
```objectivec
MapplsReverseGeocodeManager * reverseGeocodeManager = [MapplsReverseGeocodeManager sharedManager];
//Or
MapplsReverseGeocodeManager * reverseGeocodeManager = [[MapplsReverseGeocodeManager alloc] initWithRestKey:MapplsAccountManager.restAPIKey];
    
MapplsReverseGeocodeOptions *revOptions = [[MapplsReverseGeocodeOptions alloc] initWithCoordinate:CLLocationCoordinate2DMake(28.553291, 77.258876) withRegion:MapplsRegionTypeIndia];
    
[reverseGeocodeManager reverseGeocodeWithOptions:revOptions completionHandler:^(NSArray<MapplsGeocodedPlacemark *> * _Nullable placemarks, NSString * _Nullable attribution, NSError * _Nullable error) {
	if (error) {
		NSLog(@"%@", error);
	} else if (placemarks.count > 0) {
		NSLog(@"Reverse Geocode %@",
		placemarks[0].formattedAddress);
	} else {
		NSLog(@"No results");
	}
}];
```

#### Swift
```swift
let reverseGeocodeManager = MapplsReverseGeocodeManager.shared
//Or
let reverseGeocodeManager = MapplsReverseGeocodeManager(restKey: MapplsAccountManager.restAPIKey())
        
let revOptions = MapplsReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: 28.553291, longitude: 77.258876), withRegion: .india)
reverseGeocodeManager.reverseGeocode(revOptions) { (placemarks, attribution, error) in
	if let error = error {
		print("%@", error)
	} else if let placemarks = placemarks, !placemarks.isEmpty {
		print("Reverse Geocode: \(placemarks[0].formattedAddress)")
	} else {
		print("No results")
	}
}
```

For more details visit our [api reference documentation](https://about.mappls.com/api/advanced-maps/doc/reverse-geocoding-api#/Reverse%20Geocode%20API/ReverseGeocodeAPI).


## [Nearby API](#Nearby-API)

For live demo click [LIVE DEMO](https://about.mappls.com/api/advanced-maps/doc/sample/mapmyindia-maps-near-by-api-example)

Nearby Places API, enables you to add discovery and search of nearby places by searching for a generic keyword used to describe a category of places or via the unique code assigned to that category.

Class used for nearby search is `MapplsNearByManager`. Create a `MapplsNearByManager` object using your rest key or alternatively, you can place your rest key in the `MapplsRestKey` key of your application's Info.plist file, then use the shared instance of `MapplsNearByManager` class.

To perform nearby search use `MapplsNearbyAtlasOptions` class to pass keywords/categories and a reference location as parameters to get Nearby search results with an option to pass region in parameter `withRegion`, which is an enum of type `MapplsRegionType`. If no value is passed for region, It will take default value which is India.

`MapplsRegionType` is used to validate and get result for different countries. 

*Additionally you can also set location and zoom in object of `MapplsNearbyAtlasOptions` location coordinate can be set  in comma seprated format i.e `("latitue", "longitue")` or location can be Mappls Pin  for eg. `("MMI000")`*


### Request Parameters
1. **refLocation** A location provides the location around which the search will be performed it can be coordinte (latitude, longitude) or Mappls Pin in `String` format.

1.  **page:**  provides number of the page to provide results from.

2.  **sort:**  provides configured sorting operations for the client on cloud. Below are the available sorts:
		-  dist:asc & dist:desc - will sort data in order of distance from the passed location (default).
		-  name:asc & name:desc - will sort the data on alphabetically bases.

3.  **radius (integer):**  provides the range of distance to search over (default: 1000, min: 500, max: 10000).

4. **sortBy:** It is used to sort results based on value provided. It can accept object of `MapplsSortBy` or `MapplsSortByDistanceWithOrder`

5. **searchBy:** It is used to search places based on preference provided. It is of enum type `MapplsSearchByType`  its value can be either `.importance` or `.distance`

6. **filters:**   On basis of this only specific type of response returned. it can of type `MapplsNearbyKeyValueFilter` (derived from `MapplsNearbySearchFilter`).
MapplsNearbySearchFilter have following properties.
	- **filterKey:-** It takes  value for `key`  to filter result.
	- **filterValues:-** It takes an array of different query values.
	- **logicalOperator:-** `logicalOperator` of enum `MapplsLogicalOperator`  its default value is `and`.


	``` swift 
	let filter = MapplsNearbyKeyValueFilter(filterKey: "brandId", filterValues: [String,String])
	```

7.  **bounds (x1,y1;x2,y2):**  Allows the developer to send in map bounds to provide a nearby search of the geobounds. where x1,y1 are the latitude and langitude.

8.  **isRichData:** It is of type `Bool`. It allows some additional information to receive in `richInfo` parameter of response.

9.  **shouldExplain:** It is of type `Bool`.

10. **userName:** It is of type `String`. On basis of value of this some specific results bounded to a user.

11.  **pod**: It takes place type which helps in restricting the results to certain chosen type  
    Below mentioned are the codes for the pod -
    -   Sublocality
    -   Locality
    -   City
    -   Village    

### Response Parameters

You will find below useful properties in suggestion object :

-   **distance:**  provides the distance from the provided location bias in meters.
-   **mapplsPin:**  Mappls Pin, unique id of the location 6-char alphanumeric.
-   **email:**  Email for contact.
-   **entryLatitude:**  latitude of the entrance of the location.
-   **entryLongitude:**  longitude of the entrance of the location.
-   **keywords:**  provides an array of matched keywords or codes.
-   **landlineNo:**  Email for contact.
-   **latitude:**  Latitude of the location.
-   **longitude:**  longitude of the location.
-   **mobileNo :**  Phone number for contact.
-   **orderIndex:**  the order where this result should be placed
-   **placeAddress:**  Address of the location.
-   **placeName:**  Name of the location.
-   **type:**  Type of location POI or Country or City.
-   **city:**  Name of city.
-   **state:**  Name of state
-   **pincode:**  Pincode of area.
-   **categoryCode:**  Code of category with that result belongs to.
-   **richInfo:**  A dictionary object with dynamic information
-	**hourOfOperation:** A string value which describes hour of operation.
-	**addressTokens**:
	- **houseNumber**: house number of the location.
	- **houseName**: house name of the location.
	- **poi**: name of the POI (if applicable)
	- **street**: name of the street. (if applicable)
	- **subSubLocality**: the sub-sub-locality to which the location belongs. (if applicable)
	- **subLocality**: the sub-locality to which the location belongs. (if applicable)
	- **locality**: the locality to which the location belongs. (if applicable)
	- **village**: the village to which the location belongs. (if applicable)
	- **subDistrict**: the sub-district to which the location belongs. (if applicable)
	- **district**: the district to which the location belongs. (if applicable)
	- **city**: the city to which the location belongs. (if applicable)
	- **state**: the state to which the location belongs. (if applicable)
	- **pincode**: the PIN code to which the location belongs. (if applicable)
  -	**pageInfo**:
	- **pageCount**
	- **totalHits**
	- **totalPages**
	- **pageSize**

### Code Samples

#### Objective C
```objectivec
MapplsNearByManager * nearByManager = [MapplsNearByManager sharedManager];
//Or
MapplsNearByManager * nearByManager = [[MapplsNearByManager alloc] initWithRestKey:MapplsAccountManager.restAPIKey clientId:MapplsAccountManager.atlasClientId clientSecret:MapplsAccountManager.atlasClientSecret grantType:MapplsAccountManager.atlasGrantType];
    
NSString *refLocation = @"28.550667, 77.268959";
    
MapplsNearbyAtlasOptions *nearByOptions = [[MapplsNearbyAtlasOptions alloc] initWithQuery:@"EV Charging" location:refLocation withRegion:MapplsRegionTypeIndia];
    
[nearByManager getNearBySuggestionsWithOptions:nearByOptions completionHandler:^(MapplsNearbyResult * _Nullable result, NSError * _Nullable error) {
	if (error) {
		NSLog(@"%@", error);
	} else if (result.suggestions.count > 0) {
		NSLog(@"Nearby %@", result.suggestions[0].placeAddress);
	} else {
		NSLog(@"No results");
	}
}];
```
#### Swift
```swift
let nearByManager = MapplsNearByManager.shared
//Or
let nearByManager = MapplsNearByManager(restKey: MapplsAccountManager.restAPIKey(), clientId: MapplsAccountManager.atlasClientId(), clientSecret: MapplsAccountManager.atlasClientSecret(), grantType: MapplsAccountManager.atlasGrantType())
        
var refLocations: String!
refLocations = "28.543014, 77.242342"
let filter = MapplsNearbyKeyValueFilter(filterKey: "brandId", filterValues: ["Brand1", "Brand2"])
let sortBy = MapplsSortByDistanceWithOrder(orderBy: .ascending)

let nearByOptions = MapplsNearbyAtlasOptions(query:"EV Charging" , location: refLocations, withRegion: .india)
nearByOptions.filters = [filter]
nearByOptions.sortBy = sortBy
nearByOptions.searchBy = .importance
nearByManager.getNearBySuggestions(nearByOptions) { (result, error) in
	if let error = error {
		print("\(error.localizedDescription)")
	} else if let result = result, let suggestions = result.suggestions, !suggestions.isEmpty {
		print("Near by: \(suggestions[0].placeAddress)")
	} else {
		print("No results")
	}
}
```

 ### [NearBy using Mappls Pin](#NearBy-using-MapplsPin)

### Code Samples

 ```swift
let nearByManager = MapplsNearByManager.shared
//Or
let nearByManager = MapplsNearByManager(restKey: MapplsAccountManager.restAPIKey(), clientId: MapplsAccountManager.atlasClientId(), clientSecret: MapplsAccountManager.atlasClientSecret(), grantType: MapplsAccountManager.atlasGrantType())
        let nearByOptions = MapplsNearbyAtlasOptions(query: "Shoes", location: "MMI000", withRegion: .india)

nearByManager.getNearBySuggestions(nearByOptions) { (result, error) in
	if let error = error {
		print(error.localizedDescription)
	} else if let result = result, let suggestions = result.suggestions, !suggestions.isEmpty {
		print("Near by: \(suggestions[0].placeAddress)")
	} else {
		print("No results")
	}
}
```

For more details visit our [api reference documentation](https://about.mappls.com/api/advanced-maps/doc/nearby-api#/Nearby%20API/AtlasNearbyAPI).

## [Place Detail](#Place-Detail)

The Mappls Pin is a simple, standardised and precise PAN India digital address system. Every location has been assigned a unique digital address or an Mappls Pin. The Place Detail can be used to extract the details of a place with the help of its Mappls Pin i.e. a 6 digit code.

Class used for Mappls Pin search is `MapplsPlaceDetailManager`. Create a `MapplsPlaceDetailManager` object using your authenticated Mappls's keys or alternatively, you can use the shared instance of `MapplsPlaceDetailManager` class.

To perform Place Detail use `MapplsPlaceDetailOptions` class to pass digital address code (Mappls Pin) as parameters to get detail result with an option to pass region in parameter withRegion, which is an enum of type `MapplsRegionType`. If no value is passed for region, it will take default value which is India.

### Response Parameters

In response of Mappls Pin search either you will receive an error or an object of `MapplsPlaceDetail`.

-   **mapplsPin:**  The Mappls Pin assigned for a place in map database. A Mappls Pin is the digital identity for an address or business to identify its unique location.
-   **latitude:**  The latitude of the location.
-   **longitude:**  The longitude of the location.
-   **houseNumber:**  The house number of the location.
-   **houseName:**  The name of the location.
-   **poi:**  The name of the POI if the location is a place of interest (POI).
-   **street:**  The name of the street of the location.
-   **subSubLocality:**  The name of the sub-sub-locality where the location exists.
-   **subLocality:**  The name of the sub-locality where the location exists.
-   **locality:**  The name of the locality where the location exists.
-   **village:**  The name of the village if the location exists in a village.
-   **district:**  The name of the district in which the location exists.
-   **subDistrict:**  The name of the sub-district in which the location exists.
-   **city:**  The name of the city in which the location exists.
-   **state:**  The name of the state in which the location exists.
-   **pincode:**  The pin code of the location area.
-   **type:**  defines the type of location matched (HOUSE_NUMBER, HOUSE_NAME, POI, STREET, SUB_LOCALITY, LOCALITY, VILLAGE, DISTRICT, SUB_DISTRICT, CITY, STATE, SUBSUBLOCALITY, PINCODE)
-   **keyInfo:**  The dynamic custom information related to a place.

**Note: Not all response parameters are available by default. These parameters are available on demand as per mutually agreed use case. For details, please contact [Mappls API support](api_support@mappls.com).**

### Code Samples

#### Objective C
```objectivec
MapplsPlaceDetailManager * placeDetailManager = MapplsPlaceDetailManager.shared
//or
MapplsPlaceDetailManager * placeDetailManager = [[MapplsPlaceDetailManager alloc] initWithRestKey:MapplsAccountManager.restAPIKey clientId:MapplsAccountManager.atlasClientId clientSecret:MapplsAccountManager.atlasClientSecret grantType:MapplsAccountManager.atlasGrantType];

MapplsPlaceDetailOptions * placeOptions = [[MapplsPlaceDetailOptions alloc] initWithMapplsPin:@"mmi000" withRegion:MapplsRegionTypeIndia];

[placeDetailManager getResultsWithOptions:placeOptions completionHandler:^(MapplsPlaceDetail * _Nullable placeDetail, NSError * _Nullable error) {
	if (error) {
		NSLog(@"%@", error);
	} else if(placeDetail) {
		NSLog(@"Place DetailL: %@", placeDetail.address);
	} else {
		NSLog(@"No results");
	}
}];

#### Swift
```swift
let placeDetailManager = MapplsPlaceDetailManager.shared
let placeOptions = MapplsPlaceDetailOptions(mapplsPin: "mmi000", withRegion: .india)
placeDetailManager.getResults(placeOptions) { (placeDetail, error) in
	if let error = error {
		print(error)
	} else if let placeDetail = placeDetail, let latitude = placeDetail.latitude, let longitude = placeDetail.longitude {
		print("Place Detail : \(latitude),\(longitude)")
	} else {
		print("No results")
	}
}
```

## [Geocoding API](#Geocoding-API)

For live demo click [LIVE DEMO](https://about.mappls.com/api/advanced-maps/doc/sample/mapmyindia-atlas-geocoding-rest-api-example)

Get most accurate lat long combination for a given address

All mapping APIs that are used in mobile or web apps need some geo-position coordinates to refer to any given point on the map. Our Geocoding API converts real addresses into these geographic coordinates (latitude/longitude) to be placed on a map, be it for any street, area, postal code, POI or a house number etc.

Class used for geocode is `MapplsAtlasGeocodeManager`. To create instance of `MapplsAtlasGeocodeManager` initialize using your rest key, clientId, clientSecret , grantType **or** use shared instance of `MapplsAtlasGeocodeManager` after setting key values `MapplsRestKey`, `MapplsAtlasClientId`, `MapplsAtlasClientSecret`, `MapplsAtlasGrantType` in your application’s `Info.plist` file.

To perform geocode use `getGeocodeResults` method of instance of `MapplsAtlasGeocodeManager` class which accepts an instance of  `MapplsAtlasGeocodeOptions` class. To create instance of `MapplsAtlasGeocodeOptions`, pass any address as query parameters to geocode.

### Request Parameters

1. **`query`**: The address of a location (e.g. 237 Okhla Phase-III).

Additionally you can also set some other parameters in object of `MapplsAtlasGeocodeOptions` to get some specific results. Which are:  

2. **`maximumResultCount`**: The number of results which needs to be return in response.

### Response Parameters

In response of `geocode` search either you will receive an error or an array of `MapplsGeocodedPlacemark`. Yo will find below useful properties in suggestion object :

1. `houseNumber`: The house number of the location.
2. `houseName`: The name of the location.
3. `poi`: The name of the POI if the location is a place of interest (POI).
4. `street`: The name of the street of the location.
5. `subSubLocality`: The name of the sub-sub-locality where the location exists.
6. `subLocality`: The name of the sub-locality where the location exists.
7. `locality`: The name of the locality where the location exists.
8. `village`: The name of the village if the location exists in a village.
9. `district`: The name of the district in which the location exists.
10. `subDistrict`: The name of the sub-district in which the location exists.
11. `city`: The name of the city in which the location exists.
12. `state`: The name of the state in which the location exists.
13. `pincode`: The pin code of the location area.
14. `latitude`: The latitude of the location.
15. `longitude`: The longitude of the location.
16. `formattedAddress`: The complete human readable address string that is usually the complete postal address of the result.
17. `mapplsPin`: The Mappls Pin assigned for a place in map database. A Mappls Pin is the digital identity for an address or business to identify its unique location. For more information on Mappls Pin, click [here](https://about.mappls.com/app/features/mapplspin/).
18. `geocodeLevel`: It defines depth level of search for geocode.
  

### Code Samples

#### Objective C
```objectivec
MapplsAtlasGeocodeManager * atlasGeocodeManager = [MapplsAtlasGeocodeManager sharedManager];
// or
MapplsAtlasGeocodeManager * atlasGeocodeManager = [[MapplsAtlasGeocodeManager alloc] initWithRestKey:MapplsAccountManager.restAPIKey clientId:MapplsAccountManager.atlasClientId clientSecret:MapplsAccountManager.atlasClientSecret grantType:MapplsAccountManager.atlasGrantType];
    
MapplsAtlasGeocodeOptions *atlasGeocodeOptions = [[MapplsAtlasGeocodeOptions alloc] initWithQuery: @"237 Mappls" withRegion:MapplsRegionTypeIndia];
    
[atlasGeocodeManager getGeocodeResultsWithOptions:atlasGeocodeOptions completionHandler:^(MapplsAtlasGeocodeAPIResponse * _Nullable response, NSError * _Nullable error) {
	if (error) {
		NSLog(@"%@", error);
	} else if (response!= nil && response.placemarks.count > 0) {
		NSLog(@"Forward Geocode %@%@", response.placemarks[0].latitude, response.placemarks[0].longitude);
	} else {
		NSLog(@"No results");
	}
}];
```
#### Swift
```swift
let atlasGeocodeManager = MapplsAtlasGeocodeManager.shared
// or
let atlasGeocodeManager = MapplsAtlasGeocodeManager(restKey: MapplsAccountManager.restAPIKey(), clientId: MapplsAccountManager.atlasClientId(), clientSecret: MapplsAccountManager.atlasClientSecret(), grantType: MapplsAccountManager.atlasGrantType())

let atlasGeocodeOptions = MapplsAtlasGeocodeOptions(query: "237 Mappls", withRegion: .india)

atlasGeocodeManager.getGeocodeResults(atlasGeocodeOptions) { (response, error) in
	if let error = error {
		NSLog("%@", error)
	} else if let result = response, let placemarks = result.placemarks, placemarks.count > 0 {
		print("Atlas Geocode: \(placemarks[0].latitude),\(placemarks[0].longitude)")
	} else {
		print("No results")
	}
}
```
For more details visit our [api reference documentation](https://about.mappls.com/api/advanced-maps/doc/geocoding-api#/Geocode%20API/AtlasGeocodeAPI).


## [Routing API](#Routing-API)

For live demo click [LIVE DEMO](https://about.mappls.com/api/advanced-maps/doc/sample/mapmyindia-maps-route-adv-api-example)

Get optimal & alternate routes between various locations with or without considering live traffic

Routing and displaying driving directions on map, including instructions for navigation, distance to destination, traffic etc. are few of the most important parts of developing a map based application. This REST API calculates driving routes between specified locations including via points based on route type(optimal or shortest) and includes delays for traffic congestion.

Use `Directions` to get route between locations. You can use it either by creating object using your rest key **or** use shared instance of `Directions` class by setting rest key in the `MapplsRestKey` key of your application’s `Info.plist` file.

#### Swift
```swift
let directions = Directions.shared
```

#### Objective-C
```objc
MapplsDirections *directions = [MapplsDirections sharedDirections];
```

To perform this operation use object of `RouteOptions` class as request to pass source location and destination locations and other parameters.

### Request Parameters

To use **Route with traffic based ETA** feature, to get duration inclusive of traffic for a distance between locations use parameter resourceIdentifier as described below:

- `resourceIdentifier:` This property is type of enum `MapplsDirectionsResourceIdentifier` with acceptable values `routeAdv`, `routeETA` and `routeTraffic`. The default value of this property is `routeAdv`.

To choose **Travelling Mode** use parameter profileIdentifier as described below:

- `profileIdentifier:` This property is type of enum `MapplsDirectionsProfileIdentifier` with acceptable values `driving`, `biking`, `walking` and `trucking`. The default value of this property is `driving`.

**Additionally** you can set some more parameters on instance of `RouteOptions` to get filtered/specific results as :

1. `routeType`: It is type of enum  `MapplsRouteType` which can accept values `quickest`, `shortest`, `none`. By default its value is `none`.
2. `region`: It is type of enum `MapplsRegionType`. It is used to validate and get result for different countries. Currently five countries are supported including India which are Sri Lanka, India, Bhutan, Bangladesh, Nepal.

**Note**: If you are using **Routing with traffic** `routeType` and `region` values are not considered. Traffic is only available in India and only optimal route calculation is allowed with traffic.

### Steps to get directions

- To get directions create an array of `Waypoint` class, add two objects of `Waypoint` class to this array to get route path. For origin position also set heading of instance of `Waypoint` class.
- Next create an instance of `RouteOptions` class by passing waypoints created in previous step.
```swift
let options = RouteOptions(waypoints: [Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.551078, longitude: 77.268968), name: "Mappls"), Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.565065, longitude: 77.234193), name: "Moolchand")])
```
- Use `Directions` singleton class from `Directions` framework to get available routes.
- You can plot polylines on map for available routes by using Map framework. 

### [Directions Using Mappls Pins](#Directions-Using-MapplsPins)

An object of Waypoint can be created using coordinate as well as [Mappls Pin](#https://about.mappls.com/app/features/mapplspin/) (unique identifier of place).

```swift
Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.551078, longitude: 77.268968), name: "Mappls")

or

Waypoint(mapplsPin: "MMI000", name: "Mappls")
```

### Code Samples

#### Swift
```swift
let waypoints = [
    Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.551078, longitude: 77.268968), name: "Mappls"),
    Waypoint(coordinate: CLLocationCoordinate2D(latitude: 28.565065, longitude: 77.234193), name: "Moolchand"),
]

let options = RouteOptions(waypoints: waypoints, resourceIdentifier: .routeAdv, profileIdentifier: .driving)
options.includesSteps = true

let task = Directions.calculate(options) { (waypoints, routes, error) in
    guard error == nil else {
        print("Error calculating directions: \(error!)")
        return
    }

    if let route = routes?.first, let leg = route.legs.first {
        print("Route via \(leg):")

        let distanceFormatter = LengthFormatter()
        let formattedDistance = distanceFormatter.string(fromMeters: route.distance)

        let travelTimeFormatter = DateComponentsFormatter()
        travelTimeFormatter.unitsStyle = .short
        let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)

        print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")

        for step in leg.steps {
            print("\(step.instructions)")
            let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
            print("— \(formattedDistance) —")
        }
    }
}
```

#### Objective-C
```objc
NSArray<MapplsWaypoint *> *waypoints = @[
    [[MapplsWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(28.551078, 77.268968) coordinateAccuracy:-1 name:@"Mappls"],
    [[MapplsWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(28.565065, 77.234193) coordinateAccuracy:-1 name:@"Moolchand"],
];
MapplsRouteOptions *options = [[MapplsRouteOptions alloc] initWithWaypoints:waypoints
                                                  resourceIdentifier:MapplsDirectionsResourceIdentifierRouteETA
                                                  profileIdentifier:MapplsDirectionsProfileIdentifierDriving];
options.includesSteps = YES;

NSURLSessionDataTask *task = [directions calculateDirectionsWithOptions:options
                                                      completionHandler:^(NSArray<MapplsWaypoint *> * _Nullable waypoints,
                                                                          NSArray<MapplsRoute *> * _Nullable routes,
                                                                          NSError * _Nullable error) {
    if (error) {
        NSLog(@"Error calculating directions: %@", error);
        return;
    }

    MapplsRoute *route = routes.firstObject;
    MapplsRouteLeg *leg = route.legs.firstObject;
    if (leg) {
        NSLog(@"Route via %@:", leg);

        NSLengthFormatter *distanceFormatter = [[NSLengthFormatter alloc] init];
        NSString *formattedDistance = [distanceFormatter stringFromMeters:leg.distance];

        NSDateComponentsFormatter *travelTimeFormatter = [[NSDateComponentsFormatter alloc] init];
        travelTimeFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleShort;
        NSString *formattedTravelTime = [travelTimeFormatter stringFromTimeInterval:route.expectedTravelTime];

        NSLog(@"Distance: %@; ETA: %@", formattedDistance, formattedTravelTime);

        for (MapplsRouteStep *step in leg.steps) {
            NSLog(@"%@", step.instructions);
            NSString *formattedDistance = [distanceFormatter stringFromMeters:step.distance];
            NSLog(@"— %@ —", formattedDistance);
        }
    }
}];
```

### [**Usage with other Mappls Libraries**](Usage-with-other-Mappls-Libraries)

#### [**Drawing Route on mappls's Map**](Drawing-Route-on-Mappls's-Map)

Refer the code below to draw the route on a map:

```swift
// main.swift

if route.coordinateCount > 0 {
    // Convert the route’s coordinates into a polyline.
    var routeCoordinates = route.coordinates!
    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)

    // Add the polyline to the map and fit the viewport to the polyline.
    mapView.addAnnotation(routeLine)
    mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
}
```

```objc
// main.m

if (route.coordinateCount) {
    // Convert the route’s coordinates into a polyline.
    CLLocationCoordinate2D *routeCoordinates = malloc(route.coordinateCount * sizeof(CLLocationCoordinate2D));
    [route getCoordinates:routeCoordinates];
    MGLPolyline *routeLine = [MGLPolyline polylineWithCoordinates:routeCoordinates count:route.coordinateCount];

    // Add the polyline to the map and fit the viewport to the polyline.
    [mapView addAnnotation:routeLine];
    [mapView setVisibleCoordinates:routeCoordinates count:route.coordinateCount edgePadding:UIEdgeInsetsZero animated:YES];

    // Make sure to free this array to avoid leaking memory.
    free(routeCoordinates);
}
```

## [Driving Distance Time Matrix API](#Driving-Distance-Time-Matrix-API)

For live demo click [LIVE DEMO](https://about.mappls.com/api/advanced-maps/doc/sample/mapmyindia-maps-distance-matrix-api-example)

Get driving distance & time from a point to multiple destination

Adding driving distance matrix API would help to add predicted travel time & duration from a given origin point to a number of points. The Driving Distance Matrix API provides driving distance and estimated time to go from a start point to multiple destination points, based on recommended routes from Mappls Map and traffic flow conditions.

Class used for driving distance is `MapplsDrivingDistanceMatrixManager`. Create a `MapplsDrivingDistanceMatrixManager` object using your rest key or alternatively, you can place your rest key in the `MapplsRestKey` key of your application’s `Info.plist` file, then use the shared instance of `MapplsDrivingDistanceMatrixManager` class.

To perform this operation use `MapplsDrivingDistanceMatrixOptions` class to pass center location and points parameters.

To use API **Distance Matrix with traffic** to get duration inclusive of traffic for a distance between locations use parameter `resourceIdentifier` as described below:

- `resourceIdentifier:` This property is type of enum `MapplsDistanceMatrixResourceIdentifier` with acceptable values `default`, `eta` and `traffic`. The default value of this property is `default`.

To choose **Travelling Mode** use parameter profileIdentifier as described below:

- `profileIdentifier:` This property is type of enum `MapplsDirectionsProfileIdentifier` with acceptable values `driving`, `biking`, `walking` and `trucking`. The default value of this property is `driving`.

### Request Parameters

Additionally you can pass some other parameters to get filtered/specific results. Which are as :

1.  **routeType:**  It is type of enum `DistanceRouteType`.
2.  **region:**  It is type of enum `MapplsRegionType`. It is used to validate and get result for different countries. Currently five countries are supported including India which are Sri Lanka, India, Bhutan, Bangladesh, Nepal.
3. **sourceIndexes**: It is an array of int which specifie index of  the source locations
4. **destinationIndexes**: It is an array of int which specifie index of  the destinations locations.

**Note**: If you are using **Distance Matrix with traffic** `routeType` and `region` values are not considered. Traffic is only available in India and only optimal route calculation is allowed with traffic.

### Response Parameters

In response either you will receive an error or an object of  `MapplsDrivingDistanceMatrixResponse` where structure of object is as described below:

1. `responseCode`: API status code.
2. `version`: API’s version information
3. `results`: Array of results, each consisting of the following parameters
	- `code`: if the request was successful, code is “ok”.
	- `durations`: duration in seconds for source to secondary locations in order as passed.
	- `distances`: distance in meters for source to secondary locations in order as passed.

### Code Samples

**Objective C**
```objectivec
MapplsDrivingDistanceMatrixManager *distanceMatrixManager = [MapplsDrivingDistanceMatrixManager sharedManager];
    
MapplsDrivingDistanceMatrixOptions *distanceMatrixOptions = [[MapplsDrivingDistanceMatrixOptions alloc] initWithCenter:[[CLLocation alloc] initWithLatitude: 28.543014 longitude:77.242342] points:[NSArray arrayWithObjects: [[CLLocation alloc] initWithLatitude:28.520638 longitude:77.201959], [[CLLocation alloc] initWithLatitude:28.511810 longitude: 77.252773], nil] withRegion:MapplsRegionTypeIndia];
    
[distanceMatrixManager getResultWithOptions:distanceMatrixOptions completionHandler:^(MapplsDrivingDistanceMatrixResponse * _Nullable result, NSError * _Nullable error) {
	if (error) {
		NSLog(@"%@", error);
	} else if (result != nil  && result.results != nil) {
		NSArray<NSNumber *> *durations = result.results.durations.firstObject;
        NSArray<NSNumber *> *distances = result.results.distances.firstObject;
        
        NSUInteger pointCount = [distanceMatrixOptions points].count;
        for (NSUInteger i = 0; i < pointCount; i++) {
        	if (i < durations.count && i < distances.count) {
                NSLog(@"Driving Distance Matrix ETA %lu duration: %@, distance: %@", (unsigned long)i, durations[i], distances[i]);
            }
        }
    } else {
        NSLog(@"No results");
    }
}];

```
**Swift**
```swift
let distanceMatrixManager = MapplsDrivingDistanceMatrixManager.shared
let distanceMatrixOptions = MapplsDrivingDistanceMatrixOptions(center: CLLocation(latitude: 28.543014, longitude: 77.242342), points: [CLLocation(latitude: 28.520638, longitude: 77.201959), CLLocation(latitude: 28.511810, longitude: 77.252773)])
distanceMatrixOptions.profileIdentifier = .driving
distanceMatrixOptions.resourceIdentifier = .eta
distanceMatrixManager.getResult(distanceMatrixOptions) { (result, error) in
	if let error = error {
		NSLog("%@", error)
	} else if let result = result, let results = result.results, let durations = results.durations?[0], let distances = results.distances?[0] {
			let pointCount = distanceMatrixOptions.points?.count ?? -1
			for i in 0..<pointCount {
				if i < durations.count && i < distances.count {
					print("Driving Distance Matrix ETA \(i): duration: \(durations[i]) distance: \(distances[i])")
            	}
        	}
    	} else {
    	print("No results")
	}
}
```

### [Distance Using Mappls Pin](#Distance-Using-MapplsPin)

**Code snipet for getting distance between different locations using Mappls Pin is below.**

```swift
	let distanceMatrixManager = MapplsDrivingDistanceMatrixManager.shared
    et distanceMatrixOptions = MapplsDrivingDistanceMatrixOptions(locations: ["JIHGS1", "17ZUL7", "77.242342,28.543014", "17ZUL7"], withRegion: .india)
	distanceMatrixOptions.profileIdentifier = .driving
    if isETA {
        distanceMatrixOptions.resourceIdentifier = .eta
    }
    distanceMatrixOptions.sourceIndexes = [0,1]
    distanceMatrixOptions.destinationIndexes = [2,3]
    distanceMatrixManager.getResult(distanceMatrixOptions) { (result, error) in
        if let error = error {
            NSLog("%@", error)
        } else if let result = result, let results = result.results, let durations = results.durationsAPI?[0], let distances = results.distancesAPI?[0] {
			let pointCount = distanceMatrixOptions.locations?.count ?? -1
			for i in 0..<pointCount {
				if i < durations.count && i < distances.count {
					let duration = durations[i].intValue
					let distance = distances[i].intValue
					print("Driving Distance Matrix\(isETA ? " ETA" : "") \(i): duration: \(duration) distance: \(distance)")
				}
			} else {
				print("No results")
			}
  	   }
	}
```

For more details visit our [api reference documentation](https://about.mappls.com/api/advanced-maps/doc/driving-distance-matrix-api).

## [POI Along The Route API](#POI-Along-The-Route-API)

With POI Along the Route API user will be able to get the details of POIs of a particular category along his set route. The main focus of this API is to provide convenience to the user and help him in locating the place of his interest on his set route.

Class used to get list of POI along a route is `MapplsPOIAlongTheRouteManager`. Create an object of this class using Mappls's API Keys or alternatively use shared instance of `MapplsPOIAlongTheRouteManager` class.

**Note:** To use shared SDK must be initilized by setting Mappls's API Acesss Keys using class `MapplsAccountManager` of framework `MapplsAPIKit`. For more information please see [here](https://github.com/mappls-api/mappls-ios-sdk/blob/main/docs/v1.0.0/MapplsAPICore.md).

### Request Parameters

`MapplsPOIAlongTheRouteOptions` is request class which will be used to pass all required and optional parameters. So it will be require to create an instance of `MapplsPOIAlongTheRouteOptions` and pass that instance to `getPOIsAlongTheRoute` function of `MapplsPOIAlongTheRouteManager`.

#### Mandatory Parameters:
1.  **path:** This parameter takes the encoded route along which POIs to be searched. It is of type `String`.
1.  **category:** The POI category code to be searched. Only one category input supported. It is of type `String`.

#### Optional Parameters:
Additionally you can pass some other parameters to get filtered/specific results. Which are as :-

1.  **sort:**  It is of type `Bool`. Gets the sorted POIs along route.
1.  **geometries:**  It is of enum type `MapplsPolylineGeometryType`, default value is `polyline5`. Values of enum specifies type of geometry encoding.
1.  **buffer:** It is of type `Int`. Buffer of the road.
1. **page:**  It is of type `Int`. Used for pagination. By default, a request returns maximum 10 results and to get the next 10 or so on pass the page value accordingly. Default is 1.

### Response Parameters:

In callback of `getPOIsAlongTheRoute` function it will either return an error object of type 'NSError' or an array of type `MapplsPOISuggestion`. Below is list of parameters of `MapplsPOISuggestion`:

- **distance**: distance of the POI.
- **mapplsPin:** Mappls Pin of the POI
- **poi:** Name of the POI
- **subSubLocality:** Subsublocality of the POI
- **subLocality:** Sublocality of the POI
- **locality:** Locality of the POI
- **city:** City of the POI
- **subDistrict:** Sub district of the POI
- **district:** District of the POI
- **state:** State of the POI
- **popularName:** Popular name of the POI
- **address:** Address of the POI
- **telephoneNumber:** Telephone number of the POI
- **email:** Email of the POI
- **website:** Website of the POI
- **latitude:** Latitude of the POI
- **latitudeObjC:** `latitude` only while coding in Objective-C.
- **longitude:** Longitude of the POI
- **longitudeObjC:** `longitude` only while coding in Objective-C.
- **entryLatitude:** Entry latitude of the POI
- **entryLatitudeObjC:** `entryLatitude` only while coding in 
- **entryLongitude:** Entry longitude of the POI
- **entryLongitudeObjC:** `entryLongitude` only while coding in Objective-C.
- **brandCode:** Brand id of the POI

**Swift**

```swift
let poiAlongTheRouteManager = MapplsPOIAlongTheRouteManager.shared
let routePath = "mfvmDcalvMB?B?@EB}@lABzABrBDAaAFoDFuCFuC@{@@m@DoAFu@D_@VmAFWHSHKBCFCbA]n@S`@IX?^BdAL|ANtCV~ANXBfBDfBBl@Bp@BrA@Pa@FKHMf@@`CHXDLBJFHJHRbD@`D@Z?h@@f@@h@@bAB^@jDDlBB~@BT@N?dDDV?x@Bt@@dCFdCFzB@nD?N?|BEzBEzBE`@AJ?lCOxCMfAClCGnCIlCIlCIhDKfDIhDIzCK|AG|AEbBG`A@d@FVD^FjARlBVn@D`AD|@Fn@DnCZnCZtBTH@J?V@`A@lC@nC@lCB`AGNCTCPEl@SRI|@a@~BqAb@OZGt@E|BEl@AxA?|@?pA@T?V@bCB`AJNBn@L^NpAl@t@`@d@V~BlA`CnA~BnA`A`@VJd@NXF~@JN@xBBL?hA?x@Ar@?x@A@?vCAvCAvCAxCAj@F`@Fd@Nf@RrAn@|@b@dBz@fBz@nBfAJF~Ax@`CfAXLRHp@XtCpAtCrAf@V|@Rf@Px@TxAZF`BL`BLZEPERGNKPQR_@BaBPeEHeAXo@NcDLaDNaDNaDAkB?kAKqDIoD_@mAI{BI{BGgBIgBGiBCm@ASAi@Cu@Cc@Ag@Aa@GgBGgBGkBAu@IeCAUJARARA~@GB?f@C|AK`BIbBIt@IPCPCZO`@[FKLOR]Vk@Pi@DUL{@D[P}CP{C@i@@a@Ae@EiBCiBAyC?_ACaB?QAeBAgB?WB_@BSDSDOTu@dA{Cr@sBRi@JU^q@j@cATYZ_@TUbBsAHIhA}@jA_AlAaA`Ay@bAy@d@c@pAgAv@q@`AcA^_@tAoAVSVQLGdAg@f@Yz@e@W_@KSWIoAuCmAwCLMBCDCNE@AJ?H@F@v@fBGNGb@WYfAcALI@C@CBADCD@JBDBBBBD@D?DDLBFJNFDHDF@J@|CKbCItAEHCHA@EBEDCDABAF?D@DB@BDH@D?JADL@l@?j@BbAGGcAGiACc@Cm@C["
let poiAlongTheRouteOptions = MapplsPOIAlongTheRouteOptions(path: routePath, category: "FODCOF")
poiAlongTheRouteOptions.buffer = 300

poiAlongTheRouteManager.getPOIsAlongTheRoute(poiAlongTheRouteOptions) { (suggestions, error) in
	if let error = error {

	} else if let suggestions = suggestions {
		for suggestion in suggestions {
            print("POI Along \(suggestion.latitude) \(suggestion.longitude)")
        }
	}            
}
```

**Objective-C**

```objectivec
MapplsPOIAlongTheRouteManager * poiAlongTheRouteManager = [MapplsPOIAlongTheRouteManager sharedManager];
NSString *routePath = @"mfvmDcalvMB?B?@EB}@lABzABrBDAaAFoDFuCFuC@{@@m@DoAFu@D_@VmAFWHSHKBCFCbA]n@S`@IX?^BdAL|ANtCV~ANXBfBDfBBl@Bp@BrA@Pa@FKHMf@@`CHXDLBJFHJHRbD@`D@Z?h@@f@@h@@bAB^@jDDlBB~@BT@N?dDDV?x@Bt@@dCFdCFzB@nD?N?|BEzBEzBE`@AJ?lCOxCMfAClCGnCIlCIlCIhDKfDIhDIzCK|AG|AEbBG`A@d@FVD^FjARlBVn@D`AD|@Fn@DnCZnCZtBTH@J?V@`A@lC@nC@lCB`AGNCTCPEl@SRI|@a@~BqAb@OZGt@E|BEl@AxA?|@?pA@T?V@bCB`AJNBn@L^NpAl@t@`@d@V~BlA`CnA~BnA`A`@VJd@NXF~@JN@xBBL?hA?x@Ar@?x@A@?vCAvCAvCAxCAj@F`@Fd@Nf@RrAn@|@b@dBz@fBz@nBfAJF~Ax@`CfAXLRHp@XtCpAtCrAf@V|@Rf@Px@TxAZF`BL`BLZEPERGNKPQR_@BaBPeEHeAXo@NcDLaDNaDNaDAkB?kAKqDIoD_@mAI{BI{BGgBIgBGiBCm@ASAi@Cu@Cc@Ag@Aa@GgBGgBGkBAu@IeCAUJARARA~@GB?f@C|AK`BIbBIt@IPCPCZO`@[FKLOR]Vk@Pi@DUL{@D[P}CP{C@i@@a@Ae@EiBCiBAyC?_ACaB?QAeBAgB?WB_@BSDSDOTu@dA{Cr@sBRi@JU^q@j@cATYZ_@TUbBsAHIhA}@jA_AlAaA`Ay@bAy@d@c@pAgAv@q@`AcA^_@tAoAVSVQLGdAg@f@Yz@e@W_@KSWIoAuCmAwCLMBCDCNE@AJ?H@F@v@fBGNGb@WYfAcALI@C@CBADCD@JBDBBBBD@D?DDLBFJNFDHDF@J@|CKbCItAEHCHA@EBEDCDABAF?D@DB@BDH@D?JADL@l@?j@BbAGGcAGiACc@Cm@C[";
MapplsPOIAlongTheRouteOptions * poiAlongTheRouteOptions = [[MapplsPOIAlongTheRouteOptions alloc] initWithPath:routePath category:@"FODCOF"];
poiAlongTheRouteOptions.buffer = 300;
[poiAlongTheRouteManager getPOIsAlongTheRoutekWithOptions:poiAlongTheRouteOptions completionHandler:^(NSArray<MapplsPOISuggestion *> * _Nullable suggestions, NSError * _Nullable error) {
    if (error) {
            
    } else if (suggestions) {
        for (MapplsPOISuggestion *suggestion in suggestions) {
            NSLog(@"POI Along %@%@ %@ %@", suggestion.latitudeObjC, suggestion.longitudeObjC, suggestion.mapplsPin, suggestion.distanceObjC);
        }
    }
}];
```

<br/>

For more details visit our [api reference documentation](https://about.mappls.com/api/advanced-maps/doc/poi-along-the-route)

## [Nearby Reports API](#Nearby-Reports-API)

Nearby Reports enables the user to get required reports related to traffic, safety, community issues etc on the basis of input bound.

Class used to get list of Nearby Reports API is `MapplsNearbyReportManager`. Create an object of this class using Mappls's API Keys or alternatively use shared instance of `MapmyIndidiaNearbyReportManager` class.

**Note:** To use shared SDK must be initilized by setting Mappls's API Acesss Keys using class `MapplsAccountManager` of framework `MaplsAPIKit`. For more information please see [here](https://github.com/mappls-api/mappls-ios-sdk/blob/main/docs/v1.0.0/MapplsAPICore.md).

### Request Parameters

`MapplsNearbyReportOptions` is request class which will be used to pass all required and optional parameters. So it will be require to create an instance of `MapplsNearbyReportOptions` and pass that instance to `getNearbyReportResult` function of `MapmyIndidiaNearbyReportManager`.

#### Mandatory Parameters:
1.  **bound:** This parameter takes bound. It is of type `MapplsRectangularRegion` which is s a rectangular bounding box for a geographic region. whic contains following parameters
	a. bottomRight :- Coordinate at the bottomRight corner which is of type `CLLocationCoordinate2D`
	b. topLeft:- Coordinate at the northeast corner which is of type `CLLocationCoordinate2D`

### Response Parameters:

In callback of `getPOIsAlongTheRoute` function it will either return an error object of type 'NSError' or an array of type `MapplsNearbyReportResponse`. Below is list of parameters of `MapplsNearbyReportResponse`:

- **`id`(String)**: Id of the report.
- **`latitude`(Double):** Latitude of the report.
- **`longitude`(Double):** Longitude of the report.
- **`category`(String):** Report category
- **`createdOn`(Int):** Timestamp when event created

**Swift**
```swift
let nearbyReportManager = MapplsNearbyReportManager.shared
let topleft = CLLocationCoordinate2D(latitude: 28.0, longitude: 78.32)
let bottomRight = CLLocationCoordinate2D(latitude: 34.0, longitude: 78.32)

let bound = MapplsRectangularRegion(topLeft: topleft, bottomRight: bottomRight)
let option = MapplsNearbyReportOptions(bound: bound)
nearbyReportManager.getNearbyReportResult(option) { (response, error) in
	if let error = error {
		print("error: \(error.localizedDescription)")
	} else {
		if let res: MapplsNearbyReportResponse = response, let totalItem = res.pagination?.totalItems {
			if let reports = res.reports {
				for i in reports {
					if let lat = i.latitude, let long = i.longitude {
						let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
						print("Reported Coordinate: \(coordinate)")
					}
				}
			}
			print("Total item : \(totalItem)")
		}
	}
}
```


## [Current Weather Condition API](#Current-Weather-Condition-API)

API enables the developer to access current weather condition around whole India. This also enable developer to fetch current
1. Air quality index
2. Temperature
3. Humidity
4. Wind
5. Visibility 

Class used to get list of Current Weather Condition API is `MapplsWeatherManager`. Create an object of this class using Mappls's API Keys or alternatively use shared instance of `MapplsWeatherManager` class.

**Note:** To use shared SDK must be initilized by setting Mappls's API Acesss Keys using class `MapplsAccountManager` of framework `MaplsAPIKit`. For more information please see [here](https://github.com/mappls-api/mappls-ios-sdk/blob/main/docs/v1.0.0/MapplsAPICore.md).

### Request Parameters

`MapplsWeatherRequestOptions` is request class which will be used to pass all required and optional parameters. So it will be require to create an instance of `MapplsWeatherRequestOptions` and pass that instance to `getResults` function of `MapplsWeatherManager`.

#### Mandatory Parameters:
1. `location`: It is of type `CLLLocation` which takes `Latitude` and `longitude` of place

#### Optional Parameter
1. `tempUnit (String)`: Unit of temperature. **Below are the available value:**
	- "C" celcius(°C)
	- "F" farenheit (F)
2.  `theme (MapplsIconTheme)`: This parameter is used to define the theme of icon. **Below are the available value:**
	- MapplsIconThemeDark
	- MapplsIconThemeLight 
3.  `size (MapplsWeatherIconSize )`: This parameter is used to define the size of icon. **Below are the available value:**
	- MapplsWeatherIconSize36PX (Default)
	- MapplsWeatherIconSize24PX 
4. `unitType (MapplsWeatherForcastUnitType)`: This parameter defines the unit type on the basis of which weather forecast information is sought for. **Below are the available value:**
	- MapplsWeatherForcastUnitTypeDay
	- MapplsWeatherForcastUnitTypeHour
5. `unit (string)`: This parameter is the value for which forecast information is sought for. Valid values are:
	- For Days
        - `1`
        - `5`
        - `10`
	- For Hours
        - `1`
        - `24`


### Response Parameters:

In callback of `getResults` function it will either return an error object of type `NSError` or an array of type `MapplsWeatherResponse`. Below is list of parameters of `MapplsWeatherResponse`:

## Response parameters
1. `data` (`MapplsWeatherData`)

#### MapplsWeatherData result parameters:
1. `temperature` (`MapplsWeatherTemperature`)
    #### MapplsWeatherTemperature result parameters:
    1. `value` (`NSNumber`): Temperature value.For eg:31.3
    2. `unit` (`String`): Temperature unit.For eg:"°C"

2. `weatherCondition` (`MapplsWeatherCondition`): Weather condition info

    #### MapplsWeatherCondition result parameters:
    1. `weatherId` (`NSNumber`): Id of Weather condition. For eg:5
    2. `weatherText` (`String`): Weather condition info text.For eg:"Hazy sunshine"
    3. `weatherDescription` (`String`): Description of weather For eg: "Total cloud cover between 20%-60%"
    4. `weatherIcon` (`String`): Weather condition icon url.
    5. `realFeelWeatherText` (`String`):Description of weather For eg:"Feels Like 41.0 °C"

    
3. `airQuality` (`MapplsAirQuality`): Air Quality info
    #### AirQuality result parameters:
    1. `airQualityIndex` (`NSNumber`): Give the value of air quality index. For eg:104
    2. `airQualityIndexText` (`String`): Description for AQI given. For eg: "Unhealthy for Sensitive Groups"
    3. `airQualityIndexUnit` (`String`): Gives the values of airquality index unit. For eg: "PM2.5"

4. `humidity` (`MapplsHumidity`): MapplsHumidity info

    #### MapplsHumidity result parameters:
    1. `relHumidity` (`NSNumber`): Provides the value for humidity. For Eg: 65
    2. `indoorRelHumidity` (`NSNumber`): Provide value for indoor relative humidity . For eg: 65

5. `wind` (`MapplsWind`): Mappls Info

    #### Mappls result parameters:
    1. `windSpeed`(`NSNumber`):For Eg:12.8
    2. `windSpeedUnit` (`String`):For Eg: "KM/H"
    3. `windAngle` (`NSNumber`):For Eg: 338
    4. `windAngleUnit` (`String`): For Eg: "NNW"

6. `visibility` (`MapplsVisibility`): MapplsVisibility Info
    #### MapplsVisibility result parameters:
    1. `value` (`NSNumber`): Visibilty value. For eg: 2
    2. `unit` (`String`): Unit of Visibilty value. For eg: "KM"

7. `forecastData`: This feature is available for your solutions to get forecast details. The API is able to populate current weather condition and `forecast` of `1`, `5` & `10` days (depending on input)or hours based forecast for `1` hr and `24` hrs.

    #### MapplsForecastData result parameters:
    1. `hour`(`String`): Value Returned when request is made for hours. For eg: "26/09/2022 18:00",
    2. `date` (`String`): Value Returned when request is made for multiple day/days. For eg: "28/09/2022",
    3. `day` (`String`): Represents day name when request is made for multiple day/days. For eg: "Wednesday".
    4. `temperature` (`MapplsWeatherTemperature`):

        -  `minTemperature`(`NSNumber`): Minimum temperature value for the day/night.For eg:31.3 
        -  `minTemperatureUnit` (`String`): Minimum Temperature Unit. For eg:"°C"
        - `maxTemperature` (`NSNumber`): Maximum Temperature value for the day/night.For eg:31.3
        - `maxTemperatureUnit` (`String`): Maximum Temperature Unit. For eg:"°C"

    5. `weatherCondition` (`MapplsWeatherCondition`)

        -  `weatherIdDay` (`NSNumber`): Shows the ID of the day  For Eg: 1
        -  `weatherTextDay` (`String`): Shows the forcast description for the day For Eg: "Sunny"
        -  `weatherIconDay` (`String`): Shows the forcast icon for day For Eg: "1.png"
        -  `weatherIdNight` (`NSNumber`): Shows the ID of the night  For Eg: 33
        -  `weatherTextNight` (`String`): Shows the forcast description for the night For Eg: "Clear"
        -  `weatherIconNight` (`String`): Shows the forcast icon for the night For Eg: "33.png"

**Swift**
```swift
    let location = CLLocation(latitude: 28.787, longitude: 77.7873)
    let options = MapplsWeatherRequestOptions(location: location)
    // for 5 day weather forcast
    options.unitType = .day
    options.unit = "5"
    
    // for icon theme
    options.theme = .light
    MapplsWeatherManager.shared.getResults(options) { weatherResponse, error in
        if let error = error {
            print("error: \(error.localizedDescription)")
        } else {
            if let temp = weatherResponse?.data?.temperature?.temperature , let unit = weatherResponse?.data?.temperature?.temperatureUnit {
                print("current temperature: \(temp) \(unit)")
            }
            
		if let forcast = weatherResponse?.data?.forecastData {
            	for forecastData in forcast {
                    if let day = forecastData.day, let date = forecastData.date {
                        print("day: \(forecastData.day) Date: \(date)")
                    }
                }
            }
        }
    }
```
**Objective-c**

```objc
	MapplsWeatherManager * manager = [MapplsWeatherManager sharedManager];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:28.00 longitude:78.00];
    MapplsWeatherRequestOptions *options = [[MapplsWeatherRequestOptions alloc] initWithLocation:location];
    options.theme = MapplsIconThemeLight;
    options.unitType = MapplsWeatherForcastUnitTypeHour;
    options.unit = @"5";
    [manager getResultsWithOptions:options completionHandler:^(MapplsWeatherResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil ) {
            NSLog(@"error: %@", error.localizedDescription);
        } else {}
            NSLog(@"temperature %@", response.data.temperature.temperature);
            NSLog(@"temperatureUnit %@", response.data.temperature.temperatureUnit);
        
            for (MapplsForecastData* weatherForcast in response.data.forecastData){
                NSLog(@"day %@", weatherForcast.day);
                NSLog(@"date %@", weatherForcast.date);
            }
        }
    }];
```

## [Congestion Delays](#Congestion-Delays)

To get congestion delays for a route, a helper function `getCongestionDelays` added in class of MapplsDirectionUtility.

**`getCongestionDelays`**

**Parameters:**
- route: An instance of 'Route'.
- fromLocation: Location coordinate from which congestion is to be calculate on a route. The coordinate should lie on line of coordinates of route.
- uptoDistane: Distance in meters, upto which congestion is to be calculate on a route
- minCongestionDelay: Minimum delay in minutes, greater than that only congestion will be returned. This value should be greated then or equal to 1.

**Returns:**
Will return an array of `CongestionDelayInfo` which contains delay in seconds and center coordinate.

**Swift**

```swift
let congestionDelays = MapplsDirectionsUtility().getCongestionDelays(forRoute: route, fromLocation: currentLocation, uptoDistane: 50, minCongestionDelay: 5)
```

<br><br><br>

## Our many happy customers:

![](https://www.mapmyindia.com/api/img/logos1/PhonePe.png)![](https://www.mapmyindia.com/api/img/logos1/Arya-Omnitalk.png)![](https://www.mapmyindia.com/api/img/logos1/delhivery.png)![](https://www.mapmyindia.com/api/img/logos1/hdfc.png)![](https://www.mapmyindia.com/api/img/logos1/TVS.png)![](https://www.mapmyindia.com/api/img/logos1/Paytm.png)![](https://www.mapmyindia.com/api/img/logos1/FastTrackz.png)![](https://www.mapmyindia.com/api/img/logos1/ICICI-Pru.png)![](https://www.mapmyindia.com/api/img/logos1/LeanBox.png)![](https://www.mapmyindia.com/api/img/logos1/MFS.png)![](https://www.mapmyindia.com/api/img/logos1/TTSL.png)![](https://www.mapmyindia.com/api/img/logos1/Novire.png)![](https://www.mapmyindia.com/api/img/logos1/OLX.png)![](https://www.mapmyindia.com/api/img/logos1/sun-telematics.png)![](https://www.mapmyindia.com/api/img/logos1/Sensel.png)![](https://www.mapmyindia.com/api/img/logos1/TATA-MOTORS.png)![](https://www.mapmyindia.com/api/img/logos1/Wipro.png)![](https://www.mapmyindia.com/api/img/logos1/Xamarin.png)

<br>

For any queries and support, please contact:

[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="40"/> </p>](https://about.mappls.com/api/)

Email us at [apisupport@mappls.com](mailto:apisupport@mappls.com)

![](https://www.mapmyindia.com/api/img/icons/support.png)
[Support](https://about.mappls.com/contact/)
Need support? contact us!

<br></br>

[<p align="center"> <img src="https://www.mapmyindia.com/api/img/icons/stack-overflow.png"/> ](https://stackoverflow.com/questions/tagged/mappls-api)[![](https://www.mapmyindia.com/api/img/icons/blog.png)](https://about.mappls.com/blog/)[![](https://www.mapmyindia.com/api/img/icons/gethub.png)](https://github.com/mappls-api)[<img src="https://mmi-api-team.s3.ap-south-1.amazonaws.com/API-Team/npm-logo.one-third%5B1%5D.png" height="40"/> </p>](https://www.npmjs.com/org/mapmyindia) 

[<p align="center"> <img src="https://www.mapmyindia.com/june-newsletter/icon4.png"/> ](https://www.facebook.com/Mapplsofficial)[![](https://www.mapmyindia.com/june-newsletter/icon2.png)](https://twitter.com/mappls)[![](https://www.mapmyindia.com/newsletter/2017/aug/llinkedin.png)](https://www.linkedin.com/company/mappls/)[![](https://www.mapmyindia.com/june-newsletter/icon3.png)](https://www.youtube.com/channel/UCAWvWsh-dZLLeUU7_J9HiOA)

<div align="center">@ Copyright 2022 CE Info Systems Pvt. Ltd. All Rights Reserved.</div>

<div align="center"> <a href="https://about.mappls.com/api/terms-&-conditions">Terms & Conditions</a> | <a href="https://www.mappls.com/about/privacy-policy">Privacy Policy</a> | <a href="https://www.mappls.com/pdf/mappls-sustainability-policy-healt-labour-rules-supplir-sustainability.pdf">Supplier Sustainability Policy</a> | <a href="https://www.mappls.com/pdf/Health-Safety-Management.pdf">Health & Safety Policy</a> | <a href="https://www.mappls.com/pdf/Environment-Sustainability-Policy-CSR-Report.pdf">Environmental Policy & CSR Report</a>

<div align="center">Customer Care: +91-9999333223</div>
