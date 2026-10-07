[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# MapplsUIWidgets - UI Components SDK for iOS 

## [Introduction](#Introduction)
The MapplsUIWidgets SDK for iOS allows you can build rich apps by quickly implement reday made UI components. Currently this SDK have a widget for Searching a place using [AutoSuggest API](https://about.mappls.com/api/advanced-maps/doc/autosuggest-api).

### [Dependencies](#Dependencies)

This library depends upon several Mappls's own libraries. All dependent libraries will be automatically installed using CocoaPods.

Below are list of dependencies which are required to run this SDK:

- [MapplsAPICore](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPICore.md)
- [MapplsAPIKit](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPIKit.md)
- [MapplsMap](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsMap.md)
- [MapplsUIWidgets](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsUIWidgets.md)

## [Installation](#Installation)

This library is available through `CocoaPods`. To install, simply add the following line to your `podfile`:

```ruby
pod 'MapplsUIWidgets', '1.0.2'
```
On running `pod install` command it will automatically download and setup `MapplsUIWidgets` and dependent frameworks.

### [Version History](#Version-History)

| Version | Dated | Description |
| :---- | :---- | :---- |
| `1.0.2` | 02 May, 2023 | Added `debounceInterval` property in `MapplsAutocompleteViewController` class and added `responseLanguage` property in `MapplsAutocompleteFilter` class.|
| `1.0.1` | 03 Sept, 2022 | Added hyperLocal property.|
| `1.0.0` | 12 June, 2022 | Initial Mappls UIWidget Release.|

## [Authorization](#Authorization)

### [MapplsAPICore](#MapplsAPICore)
It is required to set Mappls keys to use any Mappls SDK. Please refer the documentation [here](MapplsAPICore.md).

## [Autocomplete](#Autocomplete)

<img src = "https://mmi-api-team.s3.amazonaws.com/moveSDK/ios/resources/MapmyIndiaUIWidgets/Autocomplete/defaultAutocompleteVC.gif" width = "250" style="margin-left: 50px;" align = "right"/>

The autocomplete service in the SDK for iOS returns place predictions in response to user search queries. As the user types, the autocomplete service returns suggestions for places such as businesses, addresses and points of interest.

You can add autocomplete to your app in the following ways:

Add an autocomplete UI control to save development time and ensure a consistent user experience.

Get place predictions programmatically to create a customized user experience.

### Add an autocomplete UI control

The autocomplete UI control is a search dialog with built-in autocomplete functionality. As a user enters search terms, the control presents a list of predicted places to choose from. When the user makes a selection, a MapplsAtlasSuggestion instance is returned, which your app can then use to get details about the selected place.

* [Add a full screen control](#Add-a-full-screen-control)
* [Add a results controller](#Add-a-results-controller)
* [Use a table data source](#Use-a-table-data-source)

### [Add a full-screen control](#Add-a-full-screen-control)

Use the full-screen control when you want a modal context, where the autocomplete UI temporarily replaces the UI of your app until the user has made their selection. This functionality is provided by the MapplsAutocompleteViewController class. When the user selects a place, your app receives a callback.

To add a full-screen control to your app:

1. Create a UI element in your main app to launch the autocomplete UI control, for example a touch handler on a UIButton.
1. Implement the MapplsAutocompleteViewControllerDelegate protocol in the parent view controller.
1. Create an instance of MapplsAutocompleteViewController and assign the parent view controller as the delegate property.
1. Add a [MapplsAutocompleteFilter](#MapplsAutocompleteFilter) to constrain the query to a particular type of place.
1. Present the MapplsAutocompleteViewController using [self presentViewController...].
1. Handle the user's selection in the didAutocompleteWithPlace delegate method.
1. Dismiss the controller in the didAutocompleteWithPlace, didFailAutocompleteWithError, and wasCancelled delegate methods.

The following example demonstrates one possible way to launch MapplsAutocompleteViewController in response to the user tapping on a button.

```swift
import UIKit
import MapplsUIWidgets

class ViewController: UIViewController {

  override func viewDidLoad() {
    makeButton()
  }

  // Present the Autocomplete view controller when the button is pressed.
  @objc func autocompleteClicked(_ sender: UIButton) {
    let autocompleteController = MapplsAutocompleteViewController()
    autocompleteController.delegate = self

    // Specify a filter.
    let filter = MapplsAutocompleteFilter()
    autocompleteController.autocompleteFilter = filter

    // Display the autocomplete view controller.
    present(autocompleteController, animated: true, completion: nil)
  }

  // Add a button to the view.
  func makeButton() {
    let btnLaunchAc = UIButton(frame: CGRect(x: 5, y: 150, width: 300, height: 35))
    btnLaunchAc.backgroundColor = .blue
    btnLaunchAc.setTitle("Launch autocomplete", for: .normal)
    btnLaunchAc.addTarget(self, action: #selector(autocompleteClicked), for: .touchUpInside)
    self.view.addSubview(btnLaunchAc)
  }

}

extension ViewController: MapplsAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func didAutocomplete(viewController: MapplsAutocompleteViewController, withPlace place: MapplsAtlasSuggestion) {
    print("Place name: \(place.placeName)")
    print("Place mapplsPin: \(place.mapplsPin)")
    dismiss(animated: true, completion: nil)
  }

  func didFailAutocomplete(viewController: MapplsAutocompleteViewController, withError error: NSError) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(viewController: MapplsAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(viewController: MapplsAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(viewController: MapplsAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
```

#### [SwiftUI Full Screen Control](#SwiftUI-Full-Screen-Control)

##### [Create Autosuggest View Controller](#Create-Autosuggest-View-Controller)

1. In your project, add new SwiftUI View and name it MapplsAutocompleteViewControllerSwiftUIView.swift
2. In order to use native UIKit view controller in `SwiftUI` view, you must use [UIViewControllerRepresentable](https://developer.apple.com/documentation/swiftui/uiviewcontrollerrepresentable) wrapper. The instance of custom type which adopts UIViewControllerRepresentable protocol is responsible for creation and management a UIViewController object in your SwiftUI interface.
    ```swift
    struct MapplsAutocompleteViewControllerSwiftUIWrapper: UIViewControllerRepresentable {
        ...
    }
    ```
3. The UIViewControllerRepresentable requires to implement makeUIViewController(context:) method that creates the instance of with the desired UIKit view. Add the following code to create map view instance
    ```swift
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<MapplsAutocompleteViewControllerSwiftUIWrapper>) -> MapplsAutocompleteViewController {
        let autocompleteViewController = MapplsAutocompleteViewController()        
        autocompleteViewController.delegate = context.coordinator
        return autocompleteViewController
    }
    ```
4. The UIViewControllerRepresentable view also requires to implement updateUIViewController(_:context:) which is used to configure the newly created instance. To show autosuggest only We dont need to configure anything so we will keep it empty.
    ```swift
    func updateUIViewController(_ uiViewController: MapplsAutocompleteViewController, context: UIViewControllerRepresentableContext<MapplsAutocompleteViewControllerSwiftUIWrapper>) {

    }
    ```
5. To use selected place from results of autosuggest add below property code as shown above:
    ```swift
    @Binding var placeSuggestion: MapplsAtlasSuggestion?
    ```
6. Use below code to create `SwiftUIView` to consume in another View.
    ```swift
    struct MapplsAutocompleteViewControllerSwiftUIView: View {
      @Binding var placeSuggestion: MapplsAtlasSuggestion?
    
      var body: some View {
        MapplsAutocompleteViewControllerSwiftUIWrapper(placeSuggestion: $placeSuggestion)
            .navigationBarHidden(true)
      }
    }
    ```

##### [Respond To Autosuggest Events](#Respond-To-Autosuggest-Events)

In order to respond to Autosuggest events, for example perform an action on selecting a result from Autosuggest's results. In SwiftUI, a Coordinator can be used with delegates, data sources, and user events. The UIViewControllerRepresentable protocol defines makeCoordinator() method which creates coordinator instance. Add the following code to declare coordinator class:

```swift
class Coordinator: NSObject, UINavigationControllerDelegate, MapplsAutocompleteViewControllerDelegate {
        var parent: MapplsAutocompleteViewControllerSwiftUIWrapper
        
        init(_ parent: MapplsAutocompleteViewControllerSwiftUIWrapper) {
            self.parent = parent
        }
        
        func didAutocomplete(viewController: MapplsAutocompleteViewController, withSuggestion suggestion: MapplsSearchPrediction) {
            
        }
        
        func didAutocomplete(viewController: MapplsAutocompleteViewController, withPlace place: MapplsAtlasSuggestion) {
            DispatchQueue.main.async {
                print(place.description.description as Any)
                self.parent.presentationMode.wrappedValue.dismiss()
                self.parent.placeSuggestion = place
            }
        }
        
        func didFailAutocomplete(viewController: MapplsAutocompleteViewController, withError error: NSError) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(viewController: MapplsAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
```

And then add the following method to the `MapplsAutocompleteViewControllerSwiftUIWrapper`:

```swift
func makeCoordinator() -> MapView.Coordinator {
    Coordinator(self)
}
```

**Note:** Reference coordinator is set using below code in above class.

```swift
autocompleteViewController.delegate = context.coordinator
```

### [Add a results controller](#Add-a-results-controller)

Use a results controller when you want more control over the text input UI. The results controller dynamically toggles the visibility of the results list based on input UI focus.

To add a results controller to your app:

1. Create a MapplsAutocompleteResultsViewController.
1. Implement the MapplsAutocompleteResultsViewControllerDelegate protocol in the parent view controller and assign the parent view controller as the delegate property.
1. Create a UISearchController object, passing in the MapplsAutocompleteResultsViewController as the results controller argument.
1. Set the MapplsAutocompleteResultsViewController as the searchResultsUpdater property of the UISearchController.
1. Add the searchBar for the UISearchController to your app's UI.
1. Handle the user's selection in the didAutocompleteWithPlace delegate method.

There are several ways to place the search bar of a UISearchController into your app's UI:

* [Add a search bar to the navigation bar](#Add-a-search-bar-to-the-navigation-bar)
* [Add a search bar to the top of a view](#Add-a-search-bar-to-the-top-of-a-view)

#### [Add a search bar to the navigation bar](#Add-a-search-bar-to-the-navigation-bar)

The following code example demonstrates adding a results controller, adding the searchBar to the navigation bar, and handling the user's selection:

```swift
class ViewController: UIViewController {

  var resultsViewController: MapplsAutocompleteResultsViewController?
  var searchController: UISearchController?
  var resultView: UITextView?

  override func viewDidLoad() {
    super.viewDidLoad()

    resultsViewController = MapplsAutocompleteResultsViewController()
    resultsViewController?.delegate = self

    searchController = UISearchController(searchResultsController: resultsViewController)
    searchController?.searchResultsUpdater = resultsViewController

    // Put the search bar in the navigation bar.
    searchController?.searchBar.sizeToFit()
    navigationItem.titleView = searchController?.searchBar

    // When UISearchController presents the results view, present it in
    // this view controller, not one further up the chain.
    definesPresentationContext = true

    // Prevent the navigation bar from being hidden when searching.
    searchController?.hidesNavigationBarDuringPresentation = false
  }
}

// Handle the user's selection.
extension ViewController: MapplsAutocompleteResultsViewControllerDelegate {
  func didAutocomplete(resultsController: MapplsAutocompleteResultsViewController, withPlace place: MapplsAtlasSuggestion) {
    searchController?.isActive = false
    // Do something with the selected place.
    print("Place name: \(place.placeName)")
    print("Place mapplsPin: \(place.mapplsPin)")
  }

  func didFailAutocomplete(resultsController: MapplsAutocompleteResultsViewController, withError error: NSError) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictionsForResultsController(resultsController: MapplsAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictionsFor(resultsController: MapplsAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
```

**Note:** For the search bar to display properly, your app's view controller must be enclosed within a [UINavigationController](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UINavigationController_Class/).

#### [Add a search bar to the top of a view](#Add-a-search-bar-to-the-top-of-a-view)

The following code example shows adding the searchBar to the top of a view.

```swift
import UIKit
import MapplsUIWidgets

class ViewController: UIViewController {

  var resultsViewController: MapplsAutocompleteResultsViewController?
  var searchController: UISearchController?
  var resultView: UITextView?

  override func viewDidLoad() {
    super.viewDidLoad()

    resultsViewController = MapplsAutocompleteResultsViewController()
    resultsViewController?.delegate = self

    searchController = UISearchController(searchResultsController: resultsViewController)
    searchController?.searchResultsUpdater = resultsViewController

    let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))

    subView.addSubview((searchController?.searchBar)!)
    view.addSubview(subView)
    searchController?.searchBar.sizeToFit()
    searchController?.hidesNavigationBarDuringPresentation = false

    // When UISearchController presents the results view, present it in
    // this view controller, not one further up the chain.
    definesPresentationContext = true
  }
}

// Handle the user's selection.
extension ViewController: MapplsAutocompleteResultsViewControllerDelegate {
  func didAutocomplete(resultsController: MapplsAutocompleteResultsViewController, withPlace place: MapplsAtlasSuggestion) {
    searchController?.isActive = false
    // Do something with the selected place.
    print("Place name: \(place.placeName)")
    print("Place mapplsPin: \(place.mapplsPin)")
  }

  func didFailAutocomplete(resultsController: MapplsAutocompleteResultsViewController, withError error: NSError) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictionsForResultsController(resultsController: MapplsAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictionsFor(resultsController: MapplsAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
```

### [Use a table data source](#Use-a-table-data-source)

You can use the MapplsAutocompleteTableDataSource class to drive the table view of a UISearchDisplayController.

To use MapplsAutocompleteTableDataSource to display a search controller:

1. Implement the MapplsAutocompleteTableDataSourceDelegate and UISearchDisplayDelegate protocols in the parent view controller.
1. Create a MapplsAutocompleteTableDataSource instance and assign the parent view controller as the delegate property.
1. Create an instance of UISearchDisplayController.
1. Add the searchBar for the UISearchController to your app's UI.
1. Handle the user's selection in the didAutocompleteWithPlace delegate method.
1. Dismiss the controller in the didAutocompleteWithPlace, didFailAutocompleteWithError, and wasCancelled delegate methods.

The following code example demonstrates using the MapplsAutocompleteTableDataSource class to drive the table view of a UISearchDisplayController.

```swift
import UIKit
import MapplsUIWidgets

class ViewController: UIViewController, UISearchDisplayDelegate {

  var searchBar: UISearchBar?
  var tableDataSource: MapplsAutocompleteTableDataSource?
  var searchDisplayController: UISearchDisplayController?

  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar = UISearchBar(CGRect(x: 0, y: 0, width: 250.0, height: 44.0))

    tableDataSource = MapplsAutocompleteTableDataSource()
    tableDataSource?.delegate = self

    searchDisplayController = UISearchDisplayController(searchBar: searchBar!, contentsController: self)
    searchDisplayController?.searchResultsDataSource = tableDataSource
    searchDisplayController?.searchResultsDelegate = tableDataSource
    searchDisplayController?.delegate = self

    view.addSubview(searchBar!)
  }

  func didUpdateAutocompletePredictionsForTableDataSource(tableDataSource: MapplsAutocompleteTableDataSource) {
    // Turn the network activity indicator off.
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    // Reload table data.
    searchDisplayController?.searchResultsTableView.reloadData()
  }

  func didRequestAutocompletePredictionsFor(tableDataSource: MapplsAutocompleteTableDataSource) {
    // Turn the network activity indicator on.
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    // Reload table data.
    searchDisplayController?.searchResultsTableView.reloadData()
  }

}

extension ViewController: MapplsAutocompleteTableDataSourceDelegate {
  func didAutocomplete(tableDataSource: MapplsAutocompleteTableDataSource, withPlace place: MapplsAtlasSuggestion) {
    searchDisplayController?.active = false
    // Do something with the selected place.
    print("Place name: \(place.name)")
    print("Place address: \(place.formattedAddress)")
    print("Place attributions: \(place.attributions)")
  }

  func didFailAutocomplete(tableDataSource: MapplsAutocompleteTableDataSource, withError error: NSError) {
    // TODO: Handle the error.
    print("Error: \(error.description)")
  }
}
```

### [Get place predictions programmatically](#Get-place-predictions-programmatically)

You can create a custom search UI as an alternative to the UI provided by the autocomplete widget. To do this, your app must get place predictions programmatically. Your app can get a list of predicted place names and/or addresses by using Mappls's library `MapplsAPIKit`. For more information [Goto](#MapplsAPIKit-SDK).


### [MapplsAutocompleteFilter](#MapplsAutocompleteFilter)

This class represents a set of restrictions that may be applied to autocomplete requests. This allows customization of autocomplete suggestions to only those places that are of interest.

#### Parameters:

**origin:**

A location to use as a hint when looking up the specified address.

This property prioritizes results that are close to a specific location, which is typically the user’s current location. If the value of this property is nil – which it is by default – no specific location is prioritized.

**zoom:**

Zoom level to a location to use as a hint when looking up the specified address.

**attributions:**

It allows to get tokenize address in response. By default its value is `false`. If value true is passed then only in response of MapplsAtlasSuggestion addressTokens will be recieved which is of type MapplsAddressTokens

**resultPlaceType:**

On basis of this only specific type of Places in response will be returned.

Its data type is MapplsPodType which is derived from [MapplsAPIKit](#MapplsAPIKit-SDK)

**searchAreaRestrictions:**

On basis of this only specific type of response returned.

This can be set either an object of MapplsMapplsPinFilter or MapplsBoundsFilter. Which are derived from [MapplsAPIKit](#MapplsAPIKit-SDK)

**country:**

This is used to bias your search related to country region. Its datatype is MapplsRegionType(from [MapplsAPIKit](#MapplsAPIKit-SDK)). By default it sets to India region only.
Currently supported countries are Sri-Lanka, India, Bhutan, Bangladesh, Nepal. Default is India if none is provided


## [Place Picker View](#Place-Picker-View)

<!-- <img src="https://mmi-api-team.s3.amazonaws.com/moveSDK/ios/resources/MapmyIndiaUIWidgets/PlacePicker/placepicker.gif" width = "250"  style="margin-left: 50px;" /><br><br> -->

<img src="https://mmi-api-team.s3.amazonaws.com/moveSDK/ios/resources/MapmyIndiaUIWidgets/PlacePicker/placePicker.gif" width = "250"  style="margin-left: 30px; margin-right: 30px" align = "right" /><br>

The Place Picker View is a UIView component that allows a user to pick a Place using an interactive map.

Users can select a location which from center of map after succesfully reverse geocoding that location.

`PlacePickerView` is class whose instance can be created and can be added to ViewController. Below is sample code to understand:

**Swift**

```swift
import UIKit
import MapplsMap
import MapplsUIWidgets

class PlacePickerViewExampleVC: UIViewController {
    var mapView: MapplsMapView!
    var placePickerView: PlacePickerView!    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapplsMapView()
        // Do any additional setup after loading the view.
        placePickerView = PlacePickerView(frame: self.view.bounds, parentViewController: self, mapView: mapView)
        placePickerView.delegate = self
        self.view.addSubview(placePickerView)
    }
}

extension PlacePickerViewExampleVC: PlacePickerViewDelegate {
    func didFailedReverseGeocode(error: NSError?) {
        if let error = error {
            // failed for error
        } else {
            // No results found
        }
    }
    
    func didPickedLocation(placemark: MapplsGeocodedPlacemark) {
        // Add your code on successfully selecting location from picker view.
    }
    
    func didReverseGeocode(placemark: MapplsGeocodedPlacemark) {
        // Add your code on successfully retrieving a new location
    }
}
```

### [PlacePickerViewDelegate](#PlacePickerViewDelegate)

As from above sample code `PlacePickerViewDelegate` is a protocol class which provides different delegate methods which can be used according to requirements.

### [Customize Place Picker](#Customize-Place-Picker)

On adding instance of `PlacePickerView` it will load a default view with a map marker image on map But default view can be modified with help of some properties which are described as below:

**markerView:**

View of marker on map can be ovrriden by using property 'markerView'. This is type of UIView so it can accept custom designed view and UIImageView as well.

```swift
let customView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 200))
customView.backgroundColor = .red            
placePickerView.markerView = customView
```

**isMarkerShadowViewHidden:**

A shadow of marker is shows by defualt on dragging map. Visibility of this shadow can be changed by using property 'isMarkerShadowViewHidden'.

```swift
placePickerView.isMarkerShadowViewHidden = true
```

**searchButtonBackgroundColor:**

Background color of search button can be changed by using property 'searchButtonBackgroundColor'.

```swift
placePickerView.searchButtonBackgroundColor = .yellow
```

**searchButtonImage:**

Image of search button can be changed by using property 'searchButtonImage'.

```swift
placePickerView.searchButtonImage = UIImage(named: "userSearch")!
```

**isSearchButtonHidden:**

Visibility of search button can be changed by using property 'isSearchButtonHidden'.

```swift
placePickerView.isSearchButtonHidden = true
```

**placeNameLabelTextColor:**

Font color of label of name of place can be changed by using property 'placeNameLabelTextColor'.

```swift
placePickerView.placeNameLabelTextColor = .blue
```

**addressLabelTextColor:**

Font color of label of address of place can be changed by using property 'addressLabelTextColor'.

```swift
placePickerView.addressLabelTextColor = .green
```

**pickerButtonTitleColor:**

Font color of titile of button of select a location to pick can be changed by using property 'pickerButtonTitleColor'.

```swift
placePickerView.pickerButtonTitleColor = .blue
```

**pickerButtonBackgroundColor:**

Background color of button of select a location to pick can be changed by using property 'pickerButtonBackgroundColor'.

```swift
placePickerView.pickerButtonBackgroundColor = .blue
```

**pickerButtonTitle:**

Title of button of select a location to pick can be changed by using property 'pickerButtonTitle'.

```swift
placePickerView.pickerButtonTitle = "Pick it"
```

**infoLabelTextColor:**

Font color of label of tip info at bottom can be changed by using property 'infoLabelTextColor'.

```swift
placePickerView.infoLabelTextColor = .green
```

**infoBottomViewBackgroundColor:**

Background color of container of label of tip info at bottom can be changed by using property 'infoBottomViewBackgroundColor'.

```swift
placePickerView.infoBottomViewBackgroundColor = .green
```

**placeDetailsViewBackgroundColor:**

Background color of container of location info at bottom can be changed by using property 'placeDetailsViewBackgroundColor'.

```swift
placePickerView.placeDetailsViewBackgroundColor = .green
```

**isBottomInfoViewHidden:**

Visibility of tip info at bottom can be changed by using property 'isBottomInfoViewHidden'.

```swift
placePickerView.isBottomInfoViewHidden = true
```

**isBottomPlaceDetailViewHidden:**

Visibility of container of location info at bottom can be changed by using property 'isBottomPlaceDetailViewHidden'.

```swift
placePickerView.isBottomPlaceDetailViewHidden = true
```

**isInitializeWithCustomLocation:**

Initial location of place picker can be set by setting center of map but it will also required to set value of property 'isInitializeWithCustomLocation' to true.

```swift
placePickerView.isInitializeWithCustomLocation = true
placePickerView.mapView.setCenter(CLLocationCoordinate2DMake(28.612936, 77.229546), zoomLevel: 15, animated: false)
```

## [Autocomplete Attribution Appearance](#Autocomplete-Attribution-Appearance)

### [MapplsAttributionsSettings](#MapplsAttributionsSettings)

A class `MapplsAttributionsSettings` is exist which represents a set of settings that can be applied to autocomplete to control appearance (Content Length, Size, Horizontal Content Alignment and Vertical Placement) of attribution. Appearance of attribution on can be controlled by different properties of `MapplsAttributionsSettings`.

<img src="https://mmi-api-team.s3.amazonaws.com/moveSDK/ios/resources/MapmyIndiaUIWidgets/Autocomplete/attributionHorizontalContentAlignment.gif" width = "300"  style="margin-left: 30px; margin-right: 30px" align = "right" /><br>


#### Parameters:

**attributionSize:**

Size of attribution can be controlled by setting different values of this property. It is type of an enum `MapplsContentSize`. Which can be set to `small`, `medium` or `large`. By default it's value is `medium`.

**attributionHorizontalContentAlignment:**

Horizontal alignment of content of attribution can be controlled by setting different values of this property. It is type of an enum `MapplsHorizontalContentAlignment`. Which can be set to `left`, `center` or `right`. By default it's value is `center`.

**attributionVerticalPlacement:**

Placement (either before or after of autocomplete's results) of attribution can be controlled by setting different values of this property. It is type of an enum `MapplsVerticalPlacement`. Which can be set to `before` or `after`. By default it's value is `before`.


A property `attributionSettings` of type `MapplsAttributionsSettings` is exists in each class `MapplsAutocompleteTableDataSource`, `MapplsAutocompleteViewController`, `MapplsAutocompleteResultsViewController` and `PlacePickerView` whose values can be set in different scenarios accordingly.

Code snippet to configure appearance of attribution in `MapplsAutocompleteViewController` is below:

```swift
let vc = MapplsAutocompleteViewController()
vc.attributionSettings.attributionSize = .small
vc.attributionSettings.attributionHorizontalContentAlignment = .left
vc.attributionSettings.attributionVerticalPlacement = .after
```

Code snippet to configure appearance of attribution of Autocomplete in `PlacePickerView` is below:

```swift
placePickerView = PlacePickerView(frame: self.view.bounds, parentViewController: self, mapView: mapView)

let attributionSettings = MapplsAttributionsSettings()
attributionSettings.attributionSize = .small
attributionSettings.attributionHorizontalContentAlignment = .left
attributionSettings.attributionVerticalPlacement = .after
        
placePickerView.autocompleteAttributionSettings = attributionSettings
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
