[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# MapplsRasterCatalogue Plugin for iOS

##  **DigitalSky Airspace Layers**

## [Introduction](#Introduction)

This is an easy & FREE to integrate DigitalSky Airspace zones layers widget by Mappls.

The drone airspace map is an interactive map of India that demarcates the yellow and red zones across the country. 

The airspace map may be modified by authorised entities from time to time.
Anyone planning to operate a drone should mandatorily check the latest airspace map for any changes in zone boundaries.

Follow the below steps to integrate the plugin


## [Installation](#Installation)


This plugin can be installed using CocoaPods. It is available with the name `MapplsRasterCatalogue`.

### [Using CocoaPods](#Using-CocoaPods)

Create a Podfile with the following specification:

```
pod 'MapplsRasterCatalogue', '0.1.0'
```

Run `pod repo update && pod install` and open the resulting Xcode workspace.

### [Version History](#Version-History)

| Version | Dated | Description | 
| :---- | :---- | :---- |
| `0.1.0` | 18 Jul 2022 | Initial version release. |

#### [Dependencies](#Dependencies)

This library depends upon several Mappls's own libraries. All dependent libraries will be automatically installed using CocoaPods.

Below are list of dependencies which are required to run this SDK:

- [MapplsAPICore](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPICore.md)
- [MapplsAPIKit](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPIKit.md)
- [MapplsMaps](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsMap.md)

## [Authorization](#Authorization)

### [MapplsAPICore](#MapplsAPICore)
It is required to set MAPPLS's keys to use any MAPPL's SDK. Please see [here](MapplsAPICore.md) to achieve this.

## [Precap](#Precap)

### [RasterCatalogue Layer Types](#Geoanalytics-Layer-Types)

An enum `MapplsRasterCatalogueLayerType` can be used to get different types of layers. Below are different types which are available:

1.  `MapplsRasterCatalogueLayerTypeInternationalBoundary25KM` -  Depicts International Boundary of India
2.  `MapplsRasterCatalogueLayerTypeAirport8To12KMYellow` - This Yellow zone is the airspace above 400 feet in a designated green zone; above 200 feet in the area located between 8-12 km from the perimeter of an operational airport
3.  `MapplsRasterCatalogueLayerTypeAirport5To8KM` - This Yellow zone is the airspace above 400 feet in a designated green zone; above 200 feet in the area located between 5-8 km from the perimeter of an operational airport
4.  `MapplsRasterCatalogueLayerTypeAirport0To5KM` - Shows zone is the ‘no-drone zone’ within which drones can be operated only after a permission from the Central Government.

**Now that you’re all caught up with the features, let's get down right to them and look at how you can integrate our RasterCatalogue plugin to add data on your map in few simple steps.**

## [Initialization MapplsRasterCatalogue Plugin ](#Initialization-MapplsGeoanalyticsPlugin)

```swift
var rasterCataloguePlugin : MapplsRasterCataloguePlugin = MapplsRasterCataloguePlugin(mapView: mapView)
```

## [Use of RasterCatalogue API](#Use-of-RasterCatalogue-API)

Use instance of `MapplsRasterCataloguePlugin` to show response of RasterCatalogue API as Map Layers.

#### [MapplsRasterCatalogueLayerOptions](#MapplsGeoanalyticsLayerRequest)

Below are parameters of `MapplsRasterCatalogueLayerOptions` class.

- **layerType** (mandatory): It is an enum of type `MapplsRasterCatalogueLayerType`. 

- **crossOrigin** (optional): It is of type `String`. For more info see [here](#MapplsGeoanalyticsGeobound).

- **transparent** (optional): It is  type `Bool`. its default value is `true`.

- **zIndex** (optional): It is of type `BOOL`. its default value is 0

### Step 2 - Adding RasterCatalogue layer on Map

A function `addRasterCatalogueLayer` available in `MapplsRasterCataloguePlugin` which accepts request of type `MapplsRasterCatalogueLayerOptions`.
Plugin internally consume that request to get response and plot layer on Map accordingly.

``` swift 
let request = MapplsRasterCatalogueLayerOptions(layerType: .airport5To8KM)
self.rasterCataloguePlugin.addRasterCatalogueLayer(request)
```

### Other Methods Available:

**1. Remove RasterCatalogue Layer**

`removeRasterCatalogueLayer` is a function which accepts request of type `MapplsRasterCatalogueLayerOptions` to remove related layer from map.

``` swift
let request = MapplsRasterCatalogueLayerOptions(layerType: .airport5To8KM)
geoanalyticsPlugin.removeRasterCatalogueLayer(layerRequestState))
```

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
