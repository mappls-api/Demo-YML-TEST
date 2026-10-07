[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# Mappls Nearby Search Widget for iOS

## [Introduction](#Introduction)

The MapplsNearbyUI makes it easy to integrate a widget with your iOS application. The Nearby Search widget provided as a means to enable radially search for Nearby Places on Mappls Map.

The widget offers the following basic functionalities:

- Ability to search for nearby places directly with Mappls Map visual interface.

- A single method to initiate nearby search across all categories of places available on Mappls.

- Ability to get information from Mappls Nearby Search widget through a callback.

## [Widget Preview](#Widget)

![](https://mmi-api-team.s3.amazonaws.com/moveSDK/ios/resources/MapmyIndiaNearbyUI/MapmyIndiaNearbyUI.gif)

<br> This can be done by following simple steps.

**Step 1:-**
## [Installation](#Installation)


This widget can be installed using CocoaPods. It is available with the name `MapplsNearbyUI`.

### [Using CocoaPods](#Using-CocoaPods)

Create a Podfile with the following specification:

```
pod 'MapplsNearbyUI', '1.0.0'
```

Run `pod repo update && pod install` and open the resulting Xcode workspace.

### [Version History](#Version-History)

| Version | Dated | Description | 
| :---- | :---- | :---- |
| `1.0.0` | 14 June 2022 | Initial Mappls NearbyUI Release.|

<br>

#### [Dependencies](#Dependencies)

This library depends upon several Mappls's own libraries. All dependent libraries will be automatically installed using CocoaPods.

Below are list of dependencies which are required to run this SDK:

- [MapplsAPICore](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPICore.md)
- [MapplsAPIKit](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPIKit.md)
- [MapplsMap](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsMap.md)
- [MapplsUIWidgets](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsUIWidgets.md)

#### [Authorization](#Authorization)

##### [MapplsAPICore](#MapplsAPICore)
It is required to set Mappls keys to use any Mappls SDK. Please refer the documentation [here](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPICore.md).

**Step 2:-**
## [Launching with default configuration](#Launching-with-default-configuration)


### [MapplsNearbyCategoriesViewController](#MapplsNearbyCategoriesViewController)

`MapplsNearbyCategoriesViewController` is type of UIViewController which is entry ViewController for MapplsNearbyUI SDK. 

```swift
let nearbyUI = MapplsNearbyCategoriesViewController()
self.navigationController?.pushViewController(nearbyUI, animated: false)
```
Thats all ! you are now ready with the MapplsNearbyUI widget within your app.

To enhance further and making UI as per your own requirements, refer to the section below:

#### [Properties of MapplsNearbyCategoriesViewController](#Properties-of-MapplsNearbyCategoriesViewController)

 - **nearbyCategories:** - An array of an object of type `MapplsNearbyCategories` which will help to make your own custom categories to show on `MapplsNearbyCategoriesViewController`.

It can be used as follows.
``` swift
    var  nearbyCategories = [MapplsNearbyCategories]()

    let  selectedImage = UIImage(named: "placePickerMarker")?.withRenderingMode(.alwaysTemplate)
    let categoriesImage = UIImage(named: "Coffee")

    let coffeeCategory = MapplsNearbyCategories(title: "Coffee", selectedBackgroundColor: selectedColor, unselectedBackgroundColor: .white, selectedImage: selectedImage ?? UIImage(), unselectedImage: selectedImage ?? UIImage(), unselectedTextColor: .black, selectedTextColor: .white, isSelected: true, categoryKeywords: ["FODCOF"], mapNearbyCategoryIcon: categoriesImage)

    nearbyCategories.append(coffeeCategory)

    nearbyUI.nearbyCategories = nearbyCategories

```

 - **nearbyCategoryConfiguration:-** A object of type `MapplsNearbyCategoryConfiguration` which will be required to set the UI Configuration of `MapplsNearbyCategoriesViewController` 

 - **nearbyConfiguration:-** A object of type [MapplsNearbyConfiguration](#MapplsNearbyConfiguration) which will be required in `MapplsNearbyMapViewController` to  configure the UI components and nearby request parametes.
 

- **delegate:-** A delegate object of type `MapplsNearbyCategoriesViewControllerDelegate` to provide different callbacks as per different actions of MapplsNearbyUI.

### [MapplsNearbyCategoriesViewControllerDelegate](#MapplsNearbyCategoriesViewControllerDelegate)

It is a protocol class that will be used for callback methods as shown below:

#### Call Back Handler
``` swift
    /// A delegate method which will be called when the user click next button in `MapplsNearbyCategoriesViewController` class
    /// - Parameters:
    ///   - refLocation: It is location selected from place picker  or your current location or location provided by used as refLocation.
    ///   - selectedCategories: It is the array of `MapplsNearbyCategories` items selected from the categories
    ///   - error: This will show an error message in case of any failure in `MapplsNearbyCategoriesViewController` class on next button clicked.
   
    func didNextButtonClicked(refLocation: String?, selectedCategories: [MapplsNearbyCategories]?, error: String? )
 ```

``` swift
    /// A delegate method will be called when the nearby icon is taped on the map. It will return a nearby response for the taped icon.
    /// - Parameter place: A concrete subclass of `MapplsSuggestion` to represent suggestedLocations object in results of  requests.
   
    func didSelectNearbyIcon(place: MapplsAtlasSuggestion)
 ```

 ``` swift
    /// A delegate method will be called when the nearby result in ListView is tapped. It will return a nearby response for the tapped item.
    /// - Parameter place: A concrete subclass of `MapplsSuggestion` to represent suggestedLocations object in results of  requests.
   
    func didSelectNearbySuggestionFromTable(place: MapplsAtlasSuggestion)
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
