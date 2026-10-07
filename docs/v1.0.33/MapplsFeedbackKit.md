[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# MapplsFeedbackKit for iOS

## [Introduction](#Introduction)

Feedback Kit for IOS is a wrapper SDK for Mappls's feedback API. It allows developers to integrate feedback module in their application. Using feedback module user can submit location related feedback to Mappls's server.

**Note:** Sample for UI view controllers with source code is also provided by Mappls which user can directly use to show feedback screen. Information about how to use UI sample is also provided in this documentation.

If you don't want to implement own logic and use sample from Mappls Jump to Sample UI Kit section.

### [Version History](#Version-History)

| Version | Dated | Description |
| :------ | :---- | :---------- |
| `2.0.0` | 14 Nov, 2024 | URL property for icon is set in responnse of Report Categories master to use in UI. |
| `1.0.1` | 23 Sep, 2024 | Provision of callbacks is added by subscribing to different notifications. |
| `1.0.0` | 22 June, 2022 | Initial release. |

## [Setup your Project](#Setup-your-Project)

### [Using CocoaPods](#Using-CocoaPods)

To install the `MapplsFeedbackKit` using CocoaPods:

Create a Podfile with the following specification:

```
pod 'MapplsFeedbackKit', '2.0.0'
```

Run `pod repo update && pod install` and open the resulting Xcode workspace.

### [Authorization](#Authorization)

#### [MapplsAPICore](#MapplsAPICore)
It is required to set Mappls keys to use any MAPPL's SDK. Please refer the documenatation [here](MapplsAPICore.md)

## [Usage](#Usage)

**Steps to submit feedback:**

1. An authoraization key i.e moduleId (provided by Mappls) against which feedback will be submitted wiil be required to use this SDK .

1. List of categories need to be fetched first under which feedback will be submitted. For more informatatio see [here](#Get-Report-Categories).

    **Notes:**

    - Fetched report categories can be saved for offline use or to prevent fetching report categories multiple times.

    - It will require to separate out them on basis of parentId i.e Separate as Parent and Child Categories, where if parent Id is null means they are parent categories otherwise child of some parent category.
    **Note:** ParentId of a child category is reportId of parent category.

1. On basis of parent and child categories, different User Interfaces or scenarios can be designed as per requirements.

1. User must pass have location oordinate for which feedback will be submitted.

1. After selecting of parent and child category user must take some input as a text for feedback.

1. After Collection all values i.e Module Id, Location Coordinates, Parent Category, Child Category and Feedback Text, feedback can be submitted using functions available in this SDK. See [here](#Submit-Feedback).

## [Get Report Categories](#Get-Report-Categories)

Categories for reporting can be fetched using getReportCategories method of MapplsFeedBackKitManager class by using shared instance.
In response you will receive an error or an array of MapplsReportCategories. Yo will find below useful properties in reportCategories object which is an array of  `ParentCategories`:

- *ParentCategories*

- *ChildCategories*

- *SubChildCategories*

##### Swift

```swift
MapplsFeedBackKitManager.shared.getReportCategories { (reportCategories, error)  in
    if let error = error {
        print(error.localizedDescription)
        self.dismiss(animated: true, completion: nil)
    } else {
        let categories = reportCategories ?? [ParentCategories]()
        if categories.count > 0 {
            self.allReportCategories = categories
            print(self.allReportCategories.first?.id)
            self.currentStep = 1
        } else {
            print("No report categories found")
            self.dismiss(animated: true, completion: nil)
        }
}
```

## [Submit Feedback](#Submit-Feedback)

To submit feedback to Mappls's server you can use `saveUserData` function of `MapplsSaveUserDataAPIManager` class by using shared instance.

`saveUserData` function will accept an object of `MapplsSaveUserDataOptions` class.

To create instance of MapplsSaveUserDataOptions user provide following parameters.

### [Mandatory Parameters](#Mandatory-Parameters)
1. location(String) : It can be either Mappls Pin (The 6-digit alphanumeric code for any location) or coordinate (latitude, longitude) in `string` format.
1. parentCategory(Integer) : Parent category of the report. 
1. childCategory (Integer) : Child category of the report. 

### [Optional Parameters](#Optional-Parameters)
1. placeName(string) : Name of the place where the event is taking place. It should be derived on the basis of Mappls Pin and coordinates.
2. desription(String) : A description about your event. Min length 10 characters and Max length 250 characters.
3. subChildCategory(Integer)(Internal) : Sub Child category of the report. 
4. flag(Integer) : If navroute is active then 1 else 0. 
5. speed(Integer) : User's speed in kilometers. 
6. alt(Integer) : Altitude of the user’s location, in meters. 
7. quality(Integer) : Quality of user's location. 
8. bearing(Integer) : Bearing of the user’s location, in degrees. 
9. accuracy(Integer) : Accuracy of user's location. 
10. utc(Long) : Date time in unix timestamp format. 
11. expiry(Long) : Date time in unix timestamp format to set expiry for the report. 
12. zeroId(String) : to be used only incase of NAVIMAPS . 
13. pushEvent(Boolean)(internal) : to be used only when traffic events are to be pushed back to the traffic event editor. Allowed values: a) true 
b) false 
14. appVersion(String) : Version of the app 
15. osVersionoptional(String) : Version of the os 
16. deviceName(String) : Name of the device 



##### Swift

```swift
let saveOptions = MapplsSaveUserDataOptions(location: "MMI000", parentCategory: parentCategory.id ?? 0, childCategory: childCategory.id ?? 0, description: "This is descriptions", subChildCategory: self.selectedSubChildCategories?.id, accuracy: 3)

MapplsSaveUserDataAPIManager.shared.saveUserData(saveOptions, { (isSucess, error) in

    if let error = error {
        print(error.localizedDescription)
    } else if isSucess {
        print("feedback submited successfully")
        self.dismiss(animated: true, completion: nil)
    } else {
        print("No results")
    }
})
```

## [Callbacks](#Callbacks)

Different events can be tracked by subscribing to different notificaitons.

```swift
NotificationCenter.default.addObserver(self, selector: #selector(handleFeedbackSubmit), name: .feedbackSubmitSuccessNotification, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(handleFeedbackFailed), name: .feedbackSubmitFailedNotification, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(handleReportCategoriesFetchSuccess), name: .reportCategoriesFetchSuccessNotification, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(handleReportCategoriesFetchFailed), name: .reportCategoriesFetchFailedNotification, object: nil)
```

**feedbackSubmitSuccessNotification:**

Subscribe to this notification to get callback when report submitted successfully.

**feedbackSubmitFailedNotification:**

Subscribe to this notification to get callback when report submission get failed.

**reportCategoriesFetchSuccessNotification:**

Subscribe to this notification to get callback when report fetched successfully to show in feedback controller.

**reportCategoriesFetchFailedNotification:**

Subscribe to this notification to get callback when report fetching get failed.

***Note:*** Remember to remove observer when callbacks are no longer needed:

```swift
NotificationCenter.default.removeObserver(self, name: .feedbackSubmitSuccessNotification, object: nil)
NotificationCenter.default.removeObserver(self, name: .feedbackSubmitFailedNotification, object: nil)
NotificationCenter.default.removeObserver(self, name: .reportCategoriesFetchSuccessNotification, object: nil)
NotificationCenter.default.removeObserver(self, name: .reportCategoriesFetchFailedNotification, object: nil)
```

# [Mappls Feedback UI Kit](#Mappls-Feedback-UI-Kit)

A UI control `MapplsFeedbackUIKit` is available to use SDK MapplsFeedbackKit. To know more about it see [here](MapplsFeedbackUIKit.md).

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
