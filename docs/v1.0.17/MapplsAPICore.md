[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# [MapplsAPICore]()

## [Introduction](#Introduction)

This SDK provides core features for authentication and access for various Mappls's SDKs in a very simple way.
The preferred way of integrating the SDK can be found in the  below.

## [Authentication](#Authentication)

To initialize and authenticate any **Mappls's SDK**, it is required to set keys (provided by Mappls) in `MapplsAPICore` through `MapplsAccountManager` or `Info.plist`.

Mappls's Keys can be get from [here](http://about.mappls.com/api/signup) which is governed by the API [terms and conditions](https://about.mappls.com/api/terms-&-conditions).

## [Installation](#Installation)

This library is available through `CocoaPods`. To install, simply add the following line to your `podfile`:

```ruby
pod 'MapplsAPICore', '1.0.9'
```

## [Version History](#Version-History)

| Version | Dated | Description |
| :---- | :---- | :---- |
| `1.0.9 `| 22 Sep 2023 | - Bug fixes & Improvements.|
| `1.0.8 `| 18 Aug 2023 | - Bug fixes & Improvements.|
| `1.0.7 `| 07 Jun 2023 | - Bug fixes & Improvements.|
| `1.0.6 `| 30 May 2023 | - Domain of APIs changed.|
| `1.0.5 `| 30 Jan 2023 | - Error code opimization for initializing Map.|
| `1.0.4` | 09 Dec 2022 | - A custom property `modelName` of extension `UIDevice` is made public.|
| `1.0.3` | 13 Oct 2022 | - Some performance improvements and optimization.|

### [MapplsAccountManager](#MapplsAccountManager)

You can set required keys using class `MapplsAccountManager`.

 -  To access `MapplsAccountManager` addition to import statement for `MapplsAPICore` is required.

      Objective C
      ```objectivec
      #import <MapplsAPICore/MapplsAPICore.h>
      ```

      Swift
      ```swift
      import MapplsAPICore
      ```

-   Use below methods of `MapplsAccountManager` to set different keys as follows.

    Objective C
    ```objectivec
    [MapplsAccountManager setMapSDKKey:@"MAP_SDK_KEY"];
    [MapplsAccountManager setRestAPIKey:@"REST_API_KEY"];
    [MapplsAccountManager setClientId:@"CLIENT_ID"];
    [MapplsAccountManager setClientSecret:@"CLIENT_SECRET"];
    [MapplsAccountManager setGrantType:@"client_credentials"]; //optional
    ```
    Swift
    ```swift
    MapplsAccountManager.setMapSDKKey("MAP_SDK_KEY")
    MapplsAccountManager.setRestAPIKey("REST_API_KEY")
    MapplsAccountManager.setClientId("CLIENT_ID")
    MapplsAccountManager.setClientSecret("CLIENT_SECRET")
    MapplsAccountManager.setGrantType("client_credentials") //optional
    ```
  _Note: Add the above to your's application's initialization i.e `application:didFinishLaunchingWithOptions` method of AppDelegate_

### [Info Plist](#Info-Plist)

    You can set required Mappls's keys by application's `Info.plist`.

    To set different Mappls's keys add different keys in `Info.plist` and set value against each key.

    Below are different keys which can be added in `Info.plist`.

    -   `MapplsSDKKey`
    -   `MapplsRestKey`
    -   `MapplsClientId`
    -   `MapplsClientSecret`
    -   `MapplsGrantType`

Below is screenshot for reference.

[<img src="https://mmi-api-team.s3.amazonaws.com/Mappls-SDKs/Resources/set-keys-info-plist.png"  height="100"/> </p>](https://www.mapmyindia.com/api)


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
