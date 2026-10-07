[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# Interactive Layers Plugin - Mappls Map

## [Introduction](#Introduction)

It is a guide to display Interactive Layers(such as Covid WMS Layers) on Mappls's Map.

In the current scenario, where social distancing is paramount, technology is playing a key role in maintaining daily communication and information transfer. Mappls is serving individuals, companies and the government alike, to spread critical information related to COVID-19 through deeply informative, useful and free-to-integrate geo-visualized COVID-19 Layers in your application.

Following this COVID - 19 guide it will be possible to display different Covid 19 related areas, zone and location on Mappls's Map<sup>[[1]](#1)</sup> for iOS. [MapplsMap SDK for iOS](https://github.com/mappls-api/mappls-ios-sdk) is SDK to display map on iOS platform.

It would be extremely helpful for people who are looking forward to joining offices or visiting markets etc. This tool can help you check the zone and other details of any area.

## [Getting Started](#Getting-Started)

### [Get Layers](#Get-Layers)

On launch of Mappls's Map<sup>[[1]](#1)</sup>, List of available layers can be fetched/refreshed from server by calling method `getCovidLayers` of map object. Layers can be accessed by property `interactiveLayers` of map as explained in section [Access Layers](#Access-Layers).

A delegate method `mapViewInteractiveLayersReady` will be called when it successfully fetches list of layers from server. This method can be accessed by refereing delegate of map object to any ViewController and implementing protocol class `MapplsMapViewDelegate`. Go to section [Layers Ready Callback](#Layers-Ready-Callback) for more details.

#### [Map Auhtorizaton](#Map-Auhtorizaton)

Map Authorization is part of MapplsMap SDK. Map will only display if your keys are provisoned to display map.

A delegate method `authorizationCompleted` from Maps SDK is called onece it checks for Map Authorization.

This delegate method is called when Maps authorization process completes. In delegate method a boolean property `isSuccess` receives which represents is authorization successed or not.

**Note:** `getCovidLayers` function will only work if Map SDK is authenticated. So best place to call this function is in delegate method `authorizationCompleted`.

##### Objective-C

```objectivec
- (void)mapView:(MapplsMapView *)mapView authorizationCompleted:(BOOL)isSuccess
{
    if(isSuccess) {
        [self.mapView getCovidLayers];
    }
}
```

##### Swift

```swift
func mapView(_ mapView: MapplsMapView, authorizationCompleted isSuccess: Bool) {
    if isSuccess {
        self.mapView.getCovidLayers()
    }
}
```

### [Layers Ready Callback](#Layers-Ready-Callback)

Delegate method `mapViewInteractiveLayersReady` is called when it successfully fetches list of layers after calling function `getCovidLayers`.

So get ready your application once pointer comes to this delegate method.

A scenario can be made in application to allow or disallow to access WMS layers using this deleage method. Please see below code for reference:

##### Objective-C

```objectivec
- (void)mapViewInteractiveLayersReady:(MapplsMapView *)mapView
{
    // Put your logic here to allow to access WMS layers, either by some boolean property or by setting visiblity of a button as it is demonstrated in sample.
    if (self.mapView.interactiveLayers && self.mapView.interactiveLayers.count > 0) {
        [_covid19Button setHidden:NO];
    }
}
```

##### Swift

```swift
func mapViewInteractiveLayersReady(_ mapView: MapplsMapView) {
    // Put your logic here to allow to access WMS layers, either by some boolean property or by setting visiblity of a button as it is demonstrated in sample.
    if self.mapView.interactiveLayers?.count ?? 0 > 0 {
        covid19Button.isHidden = false
    }
}
```

### [Access Layers](#Access-Layers)

List of available layers can be accessed using porperty `interactiveLayers` which is type of an array of `MapplsInteractiveLayer` class.

**Note:** Fetching of list of layers will only succeed if your `Authorization keys` for map are `provisoned` to get these layers otherwise this will be an empty list.

##### Objective-C

```objectivec
NSArray<MapplsInteractiveLayer *> *interactiveLayers = self.mapView.interactiveLayers;
```

##### Swift

```swift
let interactiveLayers = self.mapView.interactiveLayers
```

`MapplsInteractiveLayer` class has two properties `layerId` and `layerName`.

`layerId` is unique identifier for a layer using which a layer can be shown or hide on map

`layerName` is display name for a layer which can be used to show in a list or label.

### [Access Visible Layers](#Access-Visible-Layers)

List of available layers can be accessed using porperty `visibleInteractiveLayers`.

##### Objective-C

```objectivec
NSArray<MapplsInteractiveLayer *> *visibleInteractiveLayers = self.mapView.visibleInteractiveLayers;
```

##### Swift

```swift
let visibleInteractiveLayers = self.mapView.visibleInteractiveLayers
```

### [Show or Hide Layer](Show-or-Hide-Layer)

A Covid WMS layer can be shown or hide from map using helper function available.

#### [Show Layer](#Show-Layer)

A Covid WMS layer can be shown on map by calling a function `showInteractiveLayerOnMapForLayerId`. This function accepts a string value which must be layerId of one of object from list of interactive layers.

##### Objective-C

```objectivec
[self.mapView showInteractiveLayerOnMapForLayerId:@"pass-unique-layerId-here"];
```

##### Swift

```swift
mapView.showInteractiveLayerOnMap(forLayerId: "pass-unique-layerId-here")
```

#### [Hide Layer](#Hide-Layer)

A Covid WMS layer can be hide from map by calling a function `hideInteractiveLayerFromMapForLayerId`. This function accepts a string value which must be layerId of one of object from list of interactive layers.

##### Objective-C

```objectivec
[self.mapView hideInteractiveLayerFromMapForLayerId:@"pass-unique-layerId-here"];
```

##### Swift

```swift
mapView.hideInteractiveLayerFromMap(forLayerId: "pass-unique-layerId-here")
```

## [Covid Related Information](#Covid-Related-Information)

On tap on Map object covid related information for visible codvid layers will we fetched from server.

Information from top visible covid layer, will be received in delegate method `didDetectCovidInfo`, which is part of MapplsMapViewDelegate protocol class.

`didDetectCovidInfo` delegate methods will return an object of `MapplsCovidInfo` class which can be used to display different information. It will return `nil` if no info exists.

##### Objective-C

```objectivec
- (void)didDetectCovidInfo:(MapplsCovidInfo *)covidInfo
{
    if (covidInfo) {
    }
}
```

##### Swift

```swift
func didDetect(_ covidInfo: MapplsCovidInfo?) {
    if let covidInfo = covidInfo {
    }
}
```

## [Map Marker for Covid Related Information](#Map-Marker-for-Covid-Related-Information)

A marker at tapped location can be plotted on map after succesfully query covid related WMS layers.

Marker can be allowed or disallowed to plot on map by setting value of boolean property `shouldShowPopupForInteractiveLayer`. To allow to show marker set its value to `true`. By default it is false, means no marker shows on tap of covid WMS Layers.

Below is code for refrence to create a toggle button to enable or disable Covid Marker:

##### Objective-C

```objectivec
- (IBAction)covidMarkerToggleButtonPressed:(UIButton *)sender {
    BOOL newState = !_covidMarkerToggleButton.isSelected;
    [_covidMarkerToggleButton setSelected:newState];
    [_mapView setShouldShowPopupForInteractiveLayer:newState];
}
```

##### Swift

```swift
@IBAction func covidMarkerToggleButtonPressed(_ sender: UIButton) {
    let newState = !sender.isSelected;
    covidMarkerToggleButton.isSelected = newState
    self.mapView.shouldShowPopupForInteractiveLayer = newState
}
```

## [References](#References)

##### [1](#1)

A Mappls's map component which is part of [MapplsMap SDK for iOS](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsMap.md).

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
