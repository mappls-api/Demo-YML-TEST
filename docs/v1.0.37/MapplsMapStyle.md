[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# [Set Map Style](#Set-Map-Style)

Mappls offers a range of preset styles to rendering the map. The user has to retrieve a list of styles for a specific account. 
The listing api would help in rendering specific style as well as facilitate the switching of style themes. 

From the below reference code it would become quite clear that user has to specify style names and not URLs to use them. 
A default style is set for all account users to start with. 
To know more about available styles, kindly contact apisupport@mappls.com

**This feature is available from version v5.7.19**

## [List of Available Styles](#list-of-available-styles)

Explore and choose from our map style list on [Live Demo](https://www.mapmyindia.com/api/advanced-maps/WebSDK-LiveDemo/map_style)

Subscribe the delegate to get the list of available styles:

#### Swift
```
func didLoadedMapplsMapsStyles(_ mapView: MapplsMapView, styles: [MapplsMapStyle], withError error: Error?)
```

#### Objective C
```
- (void)didLoadedMapplsMapsStyles:(MapplsMapView *)mapView styles:(NSArray<MapplsMapStyle *> *)styles withError:(nullable NSError *)error;
```

`MapplsMapStyle` contains below parameters:

 1. `style_Description(String)`: Description of the style
 2. `displayName(string)`: Generic Name of style mostly used in Mappls content.
 3. `imageUrl(String)`: Preview Image of style
 4. `name(String)`: Name of style used to change the style.

## [Set Mappls Map Style](#set-Mappls-Map-Style)
To set MapplsMap style reference code is below:
#### Swift
```
mapView.setMapplsMapStyle("style Name")
```

#### Objective C
```
[self.mapView setMapplsMapStyle:@"Style Name"];
```

## [To enable/disable last selected style](#To-enable-last-selected-style)
To enable/disable loading of last selected style:

#### Swift
```
MapplsMapConfiguration.setIsShowPreferedMapStyle(false) // true is enable & false is disable(default value is true) 
``` 
#### Objective C
```
[MapplsMapConfiguration setIsShowPreferedMapStyle:false]; //true is enable & false is disable(default value is true)
```

## [didSetMapplsMapStyle](#did-Set-Mappls-Map-Style)
Tells the delegate that the style set by user is valid or not.
#### Swift
```
func didSetMapplsMapStyle(_ mapView: MapplsMapView, isSuccess: Bool, withError error: Error?)
```
#### Objective C
```
-(void)didSetMapplsMapStyle:(MapplsMapView *)mapView isSuccess:(BOOL)isSuccess withError:(nullable NSError *)error;
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
