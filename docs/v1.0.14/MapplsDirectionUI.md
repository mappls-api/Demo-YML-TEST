[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# MapplsDirectionUI for iOS

## [Introduction](#Introduction)

MapplsDirectionUI SDK provides the UI components to quickly integrate Route API from MapplsAPIKit framework in iOS application. It offers the following basic functionalities:

1. Takes support of Mappls's Place search for searching locations of origin, destinations and via points.
2. It allows to use origin and destinations in Mappls's digital address (semicolon separated) Mappls Pin or WGS 84 geographical coordinates both.
3.  The ability to set the vehicle profile like driving, and biking.
4. Easily set the resource for traffic and ETA information.

For details, please contact apisupport@mappls.com.

## [Installation](#Installation)

This plugin can be installed using CocoaPods. It is available with name `MapplsDirectionUI`.

### [Using CocoaPods](#Using-CocoaPods)

To install the MapplsDirectionUI using CocoaPods:

Create a Podfile with the following specification:

```
pod 'MapplsDirectionUI', '1.0.5'
```

Run `pod repo update && pod install` and open the resulting Xcode workspace.

#### [Dependencies](#Dependencies)

This library depends upon several Mappls's own and third party libraries. All dependent libraries will be automatically installed using CocoaPods.

Below are list of dependcies which are required to run this SDK:

- [MapplsAPICore](MapplsAPICore.md)
- [MapplsAPIKit](MapplsAPIKit.md)
- [MapplsMaps](MapplsMap.md)
- [MapplsUIWidgets](MapplsUIWidgets.md)

### [Version History](#Version-History)

| Version | Dated | Description |
| :---- | :---- | :---- |
| `1.0.5` | 02 Aug 2023 | - Added a drivingMode selector view and improvements. |
| `1.0.4` | 10 Jun 2023 | Improvements and bug fixes. |
| `1.0.3` | 03 May 2023 | added a delegate to set route option and bug fixes. |
| `1.0.2` | 17 Apr 2023 | Imporvements and bug fixes. |
| `1.0.1` | 22 June 2022 | Added Objective c support. and Added directionListDefault button.|
| `1.0.0` | 14 June 2022 | Initial MapplsDirectionUI version. |

## [Authorization](#Authorization)

### [MapplsAPICore](#MapplsAPICore)
It is required to set MAPPLS's keys to use any MAPPL's SDK. Please see [here](MapplsAPICore.md) to achieve this.

## [Usage](#Usage)

The MapplsDirectionUI makes it easy to integrate Route from MapplsAPIKit SDK to your iOS application. It gives you all the tools you need to add Directions related UI components to your application.


### [MapplsDirectionsViewController](#MapplsDirectionsViewController)

`MapplsDirectionsViewController` is type of UIViewController which you can use to show screen for getting input from user to choose origin and destination and show routes after that.

```swift
let directionVC = MapplsDirectionViewController(for: [MapplsDirectionLocation]())
self.navigationController?.pushViewController(directionVC, animated: false)
```

As from above code you can see it requires an array of object type `MapplsDirectionLocation`. It can be an blank array to launch screen without any chosen locations.

Also you can pass fixed locations and launch instnace of `MapplsDirectionViewController`, as shown in below code:

```swift
var locationModels = [MapplsDirectionLocation]()
let source = MapplsDirectionLocation(location: "77.2639,28.5354", displayName: "Govindpuri", displayAddress: "", locationType: .suggestion)
        
let viaPoint = MapplsDirectionLocation(location: "12269L", displayName: "Sitamarhi", displayAddress: "", locationType: .suggestion)
        
let destination = MapplsDirectionLocation(location: "1T182A", displayName: "Majorganj", displayAddress: "", locationType: .suggestion)
        
self.locationModels.append(source)
self.locationModels.append(viaPoint)
self.locationModels.append(destination)
let directionVC = MapplsDirectionViewController(for: self.locationModels)
directionVC.profileIdentifier = .driving
directionVC.attributationOptions = [.congestionLevel]
directionVC.resourceIdentifier = .routeETA
self.navigationController?.pushViewController(directionVC, animated: false)
```


Objective-c
```swift
MapplsDirectionViewController * directionVC = [[MapplsDirectionViewController alloc]init];
directionVC.delegate = self;
directionVC.modalPresentationStyle = UIModalPresentationFullScreen;
[self presentViewController:directionVC animated:false completion:nil];

OR

MapplsDirectionLocation* source = [[MapplsDirectionLocation alloc] initWithLocation:@"78.00,28.00" displayName:@"haridwar" displayAddress:@"" locationType:0];
MapplsDirectionLocation* destination = [[MapplsDirectionLocation alloc] initWithLocation:@"1T182A" displayName:@"Majorganj" displayAddress:@"" locationType:1];

NSArray<MapplsDirectionLocation *>* locations = [[NSArray<MapplsDirectionLocation *> alloc] initWithObjects:current,destination, nil];

MapplsDirectionViewController * directionVC = [[MapplsDirectionViewController alloc]initFor:locations style:nil];

directionVC.delegate = self;
directionVC.modalPresentationStyle = UIModalPresentationFullScreen;
[self presentViewController:directionVC animated:false completion:nil];



```
#### [Configuration](#Configuration)

Here are the properties use to configure `MapplsDirectionViewController` route.

##### [Profile Identifier](Profile-Identifier)
It is instance of enum DirectionsProfileIdentifier which can accepts values driving, walking, biking, trucking. By default its value is driving.

##### [Resource Identifier](Resource-Identifier) 
It is instance of enum DirectionsResourceIdentifier which can accepts values routeAdv, routeETA. By default its value is routeAdv.

Note: To use RouteETA ‘resourceIdentifier’ should be routeETA and ‘profileIdentifier’ should be driving. In response of RouteETA a unique identifier to that request will be received which can be get using parameter routeIdentifier of object Route.

##### [AttributeOptions](AttributeOptions)
AttributeOptions for the route. Any combination of `AttributeOptions` can be specified.
By default, no attribute options are specified.

##### [IncludesAlternativeRoutes](IncludesAlternativeRoutes)
 A Boolean value indicating whether alternative routes should be included in the response.
The default value of this property is `true`.


##### [autocompleteViewController](autocompleteViewController)
MapplsAutocompleteViewController provides an interface that displays a table of autocomplete predictions that updates as the user enters text. Place selections made by the user are returned to the app via the `MapplsAutocompleteViewControllerResultsDelegate`.


##### [autocompleteAttributionSetting](autocompleteAttributionSetting)
AutocompleteAttributionSetting allow to change the appearance of the logo in `MapplsAutocompleteViewController`

##### [autocompleteFilter](autocompleteFilter)
This property represents a set of restrictions that may be applied to autocomplete requests. This allows customization of autocomplete suggestions to only those places that are of interest.

##### [routeShapeResolution](routeShapeResolution)
 A `routeShapeResolution` indicates the level of detail in a route’s shape, or whether the shape is present at all its default value is `.full`

##### [includesSteps](includesSteps)
A Boolean value indicating whether `MapplsRouteStep` objects should be included in the response. its default value is `true`.

##### [isShowStartNavigation](isShowStartNavigation)
To show the Start Navigation button if the origin is current location.

##### [shouldShowDrivingModeSelector](shouldShowDrivingModeSelector)
`shouldShowDrivingModeSelector` is a property which is use to show the driving mode at the run time. Its default value is `false`

```swift
MapplsDirectionUIConfiguration.shared.shouldShowDrivingModeSelector = false
```

##### [shouldShowRouteReportSummary](shouldShowRouteReportSummary)
`shouldShowRouteReportSummary` is a property which is use to show route report summary on the route. its default value is `false`

```swift
MapplsDirectionUIConfiguration.shared.shouldShowRouteReportSummary = false
```

##### [shouldShowTollCostEstimation](shouldShowTollCostEstimation)
`shouldShowTollCostEstimation` is a property which is use to show route toll cost estimation button. its default value is `false`

```swift
MapplsDirectionUIConfiguration.shared.shouldShowTollCostEstimation = false
```

##### [isShowCongestionDelayOnRoute](isShowCongestionDelayOnRoute)
`isShowCongestionDelayOnRoute` is a property which is use to show congestion delay on the route.
     to show Congestion delay on map `attributationOptions` should must be set to `[ .congestionLevel, .expectedTravelTime, .baseDuration]`

```swift
MapplsDirectionUIConfiguration.shared.isShowCongestionDelayOnRoute = false
```


##### [shouldAllowToAddViapoint](isShowCongestionDelayOnRoute)
`shouldAllowToAddViapoint` is a property which for enable or disable user to add via point.

```swift
let directionVC = MapplsDirectionViewController()
directionVC.shouldAllowToAddViapoint = true
```

<br><br>




`MapplsDirectionViewController` is created using several UI components whose appearance can be changed according to user requirements. Some of them are listed as below:

- `MapplsDirectionTopBannerView`
- `MapplsDirectionBottomBannerView`

### [MapplsDirectionViewControllerDelegates](#MapplsDirectionViewControllerDelegates)

It is a protocol class which will be used for callback methods as shown below:

### Call Back Handler
Swift
```swift
/// This meathod will be called when back button is clicked in `TopBannerView`
1. didRequestForGoBack(for view: MapplsDirectionTopBannerView)

```

```swift
/// The meathod will be called when  add viapoint button will clicked in `TopBannerView`.
2. didRequestForAddViapoint(_ sender: UIButton,for isEditMode: Bool)

```

```swift
/// The meathod will be called when  Directions button will clicked in `BottomBannerView`.
3. didRequestDirections()

```

```swift
//The meathod will be called when  start button will clicked in `BottomBannerView`.
4. didRequestForStartNavigation(for routes: [Route], viewController: UIViewController, locations: [MapplsDirectionLocation], selectedRouteIndex: Int, error: NSError)

```

```swift
// The meathod will be called when  user click on auto search result
5. didDirectionsAutocomplete(viewController: MapplsAutocompleteViewController, withPlace place: MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType)

```

```swift
//  The meathod will be called when  user click on auto search favourite places
6. didDirectionsAutocomplete(viewController: MapplsAutocompleteViewController, withFavouritePlace place: MapplsUIWidgetAutosuggestFavouritePlace)

```


### [MapplsDirectionTopBannerView](#MapplsDirectionTopBannerView)

 `MapplsDirectionTopBannerView` is type of UIView which show the source, destination and viapoint locations at the top of `MapplsDirectionViewController`

This class accepts array of `MapplsDirectionLocation` from which it set value of source, destination and viapoint.


### [MapplsDirectionBottomBannerView](#MapplsDirectionBottomBannerView)

 `MapplsDirectionBottomBannerView` is class of type UIView, it used for showing the route information i.e ArivalTime, DistanceRemening, TimeRemening.

 To use this class it takes  we need to call a function `updateBottomBanner` which accepts three parameters i.e route, selectedRoute, locationModel.

-  **route:** It  is an array of the Routes which is required to update bottom banner view.
 - **selectedRoute:** If you have multiple routes then it will give the selected route in `Integer`
 - **locationModel:** LocationModel is an array of the type  `MapplsDirectionLocation`  which is required to manage bottom banner view.

<br><br><br>

## Our many happy customers:

![](https://www.mapmyindia.com/api/img/logos1/PhonePe.png)![](https://www.mapmyindia.com/api/img/logos1/Arya-Omnitalk.png)![](https://www.mapmyindia.com/api/img/logos1/delhivery.png)![](https://www.mapmyindia.com/api/img/logos1/hdfc.png)![](https://www.mapmyindia.com/api/img/logos1/TVS.png)![](https://www.mapmyindia.com/api/img/logos1/Paytm.png)![](https://www.mapmyindia.com/api/img/logos1/FastTrackz.png)![](https://www.mapmyindia.com/api/img/logos1/ICICI-Pru.png)![](https://www.mapmyindia.com/api/img/logos1/LeanBox.png)![](https://www.mapmyindia.com/api/img/logos1/MFS.png)![](https://www.mapmyindia.com/api/img/logos1/TTSL.png)![](https://www.mapmyindia.com/api/img/logos1/Novire.png)![](https://www.mapmyindia.com/api/img/logos1/OLX.png)![](https://www.mapmyindia.com/api/img/logos1/sun-telematics.png)![](https://www.mapmyindia.com/api/img/logos1/Sensel.png)![](https://www.mapmyindia.com/api/img/logos1/TATA-MOTORS.png)![](https://www.mapmyindia.com/api/img/logos1/Wipro.png)![](https://www.mapmyindia.com/api/img/logos1/Xamarin.png)

<br>

For any queries and support, please contact:

[<img src="https://mmi-api-team.s3.amazonaws.com/Mappls-SDKs/Resources/mappls-logo.png" height="40"/> </p>](https://about.mappls.com/api/)

Email us at [apisupport@mappls.com](mailto:apisupport@mappls.com)

![](https://www.mapmyindia.com/api/img/icons/support.png)
[Support](https://about.mappls.com/contact/)
Need support? contact us!

<br></br>

[<p align="center"> <img src="https://www.mapmyindia.com/api/img/icons/stack-overflow.png"/> ](https://stackoverflow.com/questions/tagged/mappls-api)[![](https://www.mapmyindia.com/api/img/icons/blog.png)](https://about.mappls.com/blog/)[![](https://www.mapmyindia.com/api/img/icons/gethub.png)](https://github.com/mappls-api)[<img src="https://mmi-api-team.s3.ap-south-1.amazonaws.com/API-Team/npm-logo.one-third%5B1%5D.png" height="40"/> </p>](https://www.npmjs.com/org/mapmyindia) 

[<p align="center"> <img src="https://www.mapmyindia.com/june-newsletter/icon4.png"/> ](https://www.facebook.com/Mapplsofficial)[![](https://www.mapmyindia.com/june-newsletter/icon2.png)](https://twitter.com/mappls)[![](https://www.mapmyindia.com/newsletter/2017/aug/llinkedin.png)](https://www.linkedin.com/company/mappls/)[![](https://www.mapmyindia.com/june-newsletter/icon3.png)](https://www.youtube.com/channel/UCAWvWsh-dZLLeUU7_J9HiOA)

<div align="center">@ Copyright 2020 CE Info Systems Pvt. Ltd. All Rights Reserved.</div>

<div align="center"> <a href="https://about.mappls.com/api/terms-&-conditions">Terms & Conditions</a> | <a href="https://www.mappls.com/about/privacy-policy">Privacy Policy</a> | <a href="https://www.mappls.com/pdf/mappls-sustainability-policy-healt-labour-rules-supplir-sustainability.pdf">Supplier Sustainability Policy</a> | <a href="https://www.mappls.com/pdf/Health-Safety-Management.pdf">Health & Safety Policy</a> | <a href="https://www.mappls.com/pdf/Environment-Sustainability-Policy-CSR-Report.pdf">Environmental Policy & CSR Report</a>

<div align="center">Customer Care: +91-9999333223</div>
