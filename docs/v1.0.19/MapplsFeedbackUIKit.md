[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# MapplsFeedbackUIKit for iOS

## [Introduction](#Introduction)

FeedbackUI Kit for IOS is a UI kit to use wrapper for Mappls's feedback API. It allows developers to integrate feedback module in their application. Using feedback module user can submit location related feedback to Mappls's server.

**Note:** Sample for UI view controllers with source code is also provided by Mappls which user can directly use to show feedback screen. Information about how to use UI sample is also provided in this documentation.

If you don’t want to implement own logic and use sample from Mappls Jump to Sample UI Kit section.

### [Version History](#Version-History)

| Version | Dated | Description |
| :------ | :---- | :---------- |
| `1.0.0` | 22 June, 2022 | Initial release. |
| `1.0.1` | 14 Sept, 2022 | Bug fixes. |
| `1.0.2` | 23 Sep, 2022 | Added a Bool property `isShowStepProgress` to hide stepProgress.|

## [Setup your Project](#Setup-your-Project)

### [Using CocoaPods](#Using-CocoaPods)

To install the MapplsFeedbackUIKit using CocoaPods:

Create a Podfile with the following specification:

```
pod 'MapplsFeedbackUIKit', '1.0.1'
```

Run `pod repo update && pod install` and open the resulting Xcode workspace.

### [Authorization](#Authorization)

#### [MapplsAPICore](#MapplsAPICore)
It is required to set Mappls keys to use any MAPPL's SDK. Please refer the documenatation [here](MapplsAPICore.md)

## [Usage](#Usage)

`MapplsFeedbackUIKitManager` is the class which will help to use this UI Control.Access shared instance of that class and call `getViewController` method to get instance of ViewController and present or push according to requirement.

### [Properties](#Properties)
**isShowStepProgress**: It is a shared property use to hide stepProgress, its default value `true`

##### Objective-C

```objectivec
CLLocation *location = [[CLLocation alloc] initWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];

UINavigationController *navVC = [[MapplsFeedbackUIKitManager sharedManager] getViewControllerWithLocation:location];
[self presentViewController:navVC animated:YES completion:nil];
```

##### Swift

```swift
MapplsFeedbackUIKitManager.shared.getViewController(location: self.refLocations, speed: self.speed, alt: self.alt, bearing: self.bearing, accuracy: self.accuracy, appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, osVersionoptional: UIDevice.current.systemVersion, deviceName: UIDevice.current.name)
self.present(navVC, animated: true, completion: nil)
```

`MapplsFeedbackUIKit` implicitly use functionalities of MapplsFeedBackKitManager module and provides a beautiful user expereience to submit feedback.

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
