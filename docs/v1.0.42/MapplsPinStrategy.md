[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# Mappls Pin Strategy in Mappls's Map SDK for iOS

## [Add Marker Using Mappls Pin](#Add-Marker-Using-Mappls-Pin)

A marker on Mappls Map can be added using only Mappls Pin. For this it will require an object of `MapplsPointAnnotation`.

To create object of `MapplsPointAnnotation` it will require Mappls Mappls Pin(unique code of a Place) in its initializer.

### Single Marker

**Swift**
```swift
let annotation11 = MapplsPointAnnotation(mapplsPin: "7gbcyf")
mapView.addMapplsAnnotation(annotation11, completionHandler: nil)
```

### Multiple Markers

**Swift**
```swift
var annotations = [MapplsPointAnnotation]()            
let mapplsPins = [ "mmi000", "7gbcyf", "5MEQEL", "k595cm"]
for mapplsPin in mapplsPins {
    let annotation = MapplsPointAnnotation(mapplsPin: mapplsPin)
    annotations.append(annotation)
}
self.mapView.addMapplsAnnotations(annotations, completionHandler: nil)
```
## [Set Map Center Using Mappls Pin](#Set-Map-Center-Using-Mappls-Pin)

Mappls's Map can be centered to a Place using its Mappls Pin.
Different functions are available to achieve this. Below are code snippets to use it.

**Swift**
```swift
mapView.setMapCenterAtMapplsPin("mmi000", animated: false, completionHandler: nil)
```

```swift
mapView.setMapCenterAtMapplsPin("mmi000", zoomLevel: 17, animated: false, completionHandler: nil)
```

```swift                
mapView.setMapCenterAtMapplsPin("mmi000", zoomLevel: 17, direction: 0, animated: false, completionHandler: nil)
```

## [Set Map View Bounds Using List of Mappls Pin](#Set-Map-View-Bounds-Using-List-of-Mappls-Pin)

Mappls's Map's bounds can be set to fit bounds for a list of Mappls Pins.
A method `showMapplsPins:` is available to achieve this. Below is code snipped to demonstrated its usage

**Swift**
```swift
let mapplsPins = ["mmi000", "7gbcyf", "5MEQEL", "k595cm"]
self.mapView.showMapplsPins(MapplsPins, animated: false, completionHandler: nil)
```
## [Distance Between Locations Using Mappls Pins](#Distance-Between-Locations-Using-Mappls-Pins)

Code snipet for getting distance between different locations using Mappls Pins is below. For more information please see [here](https://github.com/mappls-api/mappls-ios-sdk/docs/1.0.0/RESTAPIKit#Distance-Using-MapplsPin).

## [Directions Between Locations Using Mappls Pins](#Directions-Between-Locations-Using-Mappls-Pins)

Directions between different locations can be get using Mappls Pins. For more information please see [here](https://github.com/MapmyIndia/mapmyindia-maps-vectorSDK-iOS/wiki/REST-API-Kit#Routing-API) and [here](https://github.com/MapmyIndia/mapmyindia-maps-vectorSDK-iOS/wiki/REST-API-Kit#Directions-Using-Mappls-Pins).

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
