[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# MapplsDrivingRangePlugin for iOS

## [Introduction](#Introduction)

The MapplsDrivingRangePlugin allows you to plot driving range area to drive based on time or distance on Mappls's vector map component.

The plugin offers the following basic functionalities:

- Get and Plot driving range as polygon on map.

- Update driving range on map.

- Clear already plotted driving range on map.

**This can be done by following simple steps.**

**Step 1:-**
## [Installation](#Installation)

This plugin can be installed using CocoaPods. It is available with name `MapplsDrivingRangePlugin`.

### [Using CocoaPods](#Using-CocoaPods)

Create a Podfile with the following specification:

```cocoapods
pod 'MapplsDrivingRangePlugin', '1.0.0'
```

Run `pod repo update && pod install` and open the resulting Xcode workspace.

### [Version History](#Version-History)

| Version | Dated         | Description |
|:--------|:--------------|:------------|
| `1.0.0` | 14 June, 2022 | Initial release  |

#### [Dependencies](#Dependencies)

This library depends upon several Mappls's own libraries. All dependent libraries will be automatically installed using CocoaPods.

Below are list of dependcies which are required to run this SDK:

- [MapplsAPIKit](MapplsAPIKit.md)
- [MapplsMap](MapplsMap.md)

### [Authorization](#Authorization)

#### [MapplsAPICore](#MapplsAPICore)
It is required to set Mappls keys to use any MAPPL's SDK. Please refer the documenatation [here](MapplsAPICore.md).

**Step 2:-**
## [Plugin Initialization](#Plugin-Initialization)

### [MapplsDrivingRangePlugin](#MapplsDrivingRangePlugin)

`MapplsDrivingRange` is the main class which is need to initialize to use different functionality of plugin. It requires an instance of MapplsMapView.

It allows you to plot driving range area to drive based on time or distance.

```swift
var drivingRangePlugin = MapplsDrivingRange(mapView: self.mapView)

self.drivingRangePlugin.delegate = self // optional
```

**Step 3:-**
## [Get And Plot Driving Range](#Get-And-Plot-Driving-Range)

A function `getAndPlotDrivingRange` of instance of `MapplsDrivingRange` will be used to get driving range and plot on map. This function will accept an instance of `MapplsDrivingRangeOptions` as request to get driving range.

Below is code for reference:

```swift
let location = CLLocation(latitude: 28.551060, longitude: 77.268989)
        
let contours = [MapplsDrivingRangeContours(value: 2)]
let rangeInfo = MapplsDrivingRangeRangeTypeInfo(rangeType: .distance, contours: contours)
        
let drivingRangeOptions = MapplsDrivingRangeOptions(location: location, rangeTypeInfo: rangeInfo)
        
self.drivingRangePlugin.getAndPlotDrivingRange(options: drivingRangeOptions)
```

## [Additional Features](#Additional-Features)

### [Clear Driving Range](#Clear-Driving-Range)

Plotted driving range on Map can be removed by calling function `clearDrivingRangeFromMap`.

Below is line of code to use it:

```swift
drivingRangePlugin.clearDrivingRangeFromMap()
```

### [Update Driving Range](#Update-Driving-Range)

Plotted driving range on map can be upated by calling function `getAndPlotDrivingRange` again with new request object (instance of MapplsDrivingRangeOptions).

Below is some code for reference:

```swift
let location = CLLocation(latitude: 28.612972, longitude: 77.233529)
        
let contours = [MapplsDrivingRangeContour(value: 15)]
let rangeInfo = MapplsDrivingRangeRangeTypeInfo(rangeType: .time, contours: contours)
        
let speedInfo = MapplsDrivingRangeOptimalSpeed()
        
let drivingRangeOptions = MapplsDrivingRangeOptions(location: location, rangeTypeInfo: rangeInfo, speedTypeInfo: speedInfo)
        
self.drivingRangePlugin.getAndPlotDrivingRange(options: drivingRangeOptions)
```

## [Reference](#Reference)

### [MapplsDrivingRangePluginDelegate](#MapplsDrivingRangePluginDelegate)

It is a protocol class which provides different callbacks of events of `MapplsDrivingRange`.

Below are different callback functions avaialble:

#### [drivingRange(_:didFailToGetAndPlotDrivingRange:)](#drivingRange(_:didFailToGetAndPlotDrivingRange:))

Called when the plugin fails to get and plot driving range.

**DECLARATION**

```swift
optional func drivingRange(_ plugin: MapplsDrivingRange, didFailToGetAndPlotDrivingRange error: Error)
```

**PARAMETERS**

- **plugin:-** The plugin that has calculated a driving range.

- **error:-** An error raised during the process of obtaining a new route.


#### [drivingRangeDidSuccessToGetAndPlotDrivingRange(_:)](#drivingRangeDidSuccessToGetAndPlotDrivingRange(_:))

Called when the plugin succeed to get and plot driving range on map.

**DECLARATION**

```
@objc optional func drivingRangeDidSuccessToGetAndPlotDrivingRange(_ plugin: MapplsDrivingRange)
```

**PARAMETERS**

- **plugin:-** The plugin that has calculated a driving range.

### [MapplsDrivingRangeOptions](#MapplsDrivingRangeOptions)

It is a structure that specifies the criteria for request for geting polygons as range to drive based on time or distance.

It contains following properties.

- **name:-** It is of type `String` used for name of the isopolygon request. If name is specified, the name is returned with the response.

- **location:-** It is of type `CLLocation`, Center point for range area that will surrounds the roads which can be reached from this point in specified time range(s).

- **drivingProfile:-** It is of type `MapplsDirectionProfileIdentifier`. Driving profile for routing engine. Default value is `auto`.

- **speedTypeInfo:-** It is of protocol type `MapplsDrivingRangeSpeed`. It is used to calculate the polygon. Instance of `MapplsDrivingRangeSpeedOptimal`, `MapplsDrivingRangeSpeedPredictiveFromCurrentTime` or `MapplsDrivingRangePredictiveSpeedFromCustomTime` can be set.

- **rangeTypeInfo:-** It is of type `MapplsDrivingRangeRangeTypeInfo`. To specify the type of range which is used to calculate the polygon.

- **isForPolygons:-** A Boolean value to determine whether to return geojson polygons or linestrings. The default is true.

- **isShowLocations:-** A boolean indicating whether the input locations should be returned as MultiPoint features: one feature for the exact input coordinates and one feature for the coordinates of the network node it snapped to. The default is false.

- **denoise:-** A floating point value from 0 to 1 (default of 1) which will be used to remove smaller contours. Default value is 0.5.

- **generalize:-** A floating point value in meters used as the tolerance for Douglas-Peucker generalization. Default value is 1.2


### [MapplsDrivingRangeRangeTypeInfo](#MapplsDrivingRangeRangeTypeInfo)

Use instance of it to set speed type in instance of `MapplsDrivingRangeOptions`.

It contains following properties.

- **rangeType:-** It is type of enum `MapplsDrivingRangeRangeType`. It specify the type of range which is used to calculate the polygon. Acceptable values are time and distance. Default value is time

- **contours:-** An array of contour (of type `MapplsDrivingRangeContour`) objects Each contour object is combination of value and colorHexString. There must be minimum one item in the array if not set by default one value will be passed with default value.

Below is line of code to initilize instance of it:

```swift
let contours = [MapplsDrivingRangeContour(value: 2)]
let rangeInfo = MapplsDrivingRangeRangeTypeInfo(rangeType: .time, contours: contours)
```

### [MapplsDrivingRangeContour](#MapplsDrivingRangeContour)

Use instance of it to set speed type in instance of `MapplsDrivingRangeOptions`.

It contains following properties.

- **value:-** It is of type `Int`. It's value be considered as time or distance depending upon type of Range in instance of `MapplsDrivingRangeRangeTypeInfo`. If type of range is time then value will considered in minute/s where default value will be 15 and maximun acceptable value will be 120. If type of range is distance then value will considered in kilometer/s where default value will be 1 and maximun acceptable value will be 100.

- **colorHexString:-** It is of type `String`. It specify the color for the output of the contour. Pass a hex value, such as `ff0000` for red. If no color is specified, default color will be assigned.

Below is line of code to initilize instance of it:

```swift
let contour = MapplsDrivingRangeContour(value: 15)
```

### [MapplsDrivingRangeOptimalSpeed](#MapplsDrivingRangeOptimalSpeed)

It is a structure to specify the type of speed to use to calculate the polygon.
Type of speed will be optimal.

Use instance of it to set speed type in instance of `MapplsDrivingRangeOptions`.

Below is line of code to initilize instance of it:

```swift
let speedInfo = MapplsDrivingRangeOptimalSpeed()
```

### [MapplsDrivingRangePredictiveSpeedFromCurrentTime](#MapplsDrivingRangePredictiveSpeedFromCurrentTime)

It is a structure to specify the type of speed and timestamp to use to calculate the polygon. Type of speed will be predicitve and timestamp will be current.

Use instance of it to set speed type in instance of `MapplsDrivingRangeOptions`.

Below is line of code to initilize instance of it:

```swift
let speedInfo = MapplsDrivingRangePredictiveSpeedFromCurrentTime()
```

### [MapplsDrivingRangePredictiveSpeedFromCustomTime](#MapplsDrivingRangePredictiveSpeedFromCustomTime)

It is a structure to specify the type of speed and timestamp to use to calculate the polygon. Type of speed will be predicitve and timestamp will be required to initialize instance of this.

Use instance of it to set speed type in instance of `MapplsDrivingRangeOptions`.

Below is line of code to initilize instance of it:

```swift
let speedInfo = MapplsDrivingRangePredictiveSpeedFromCustomTime(timestamp: 1633684669)
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
