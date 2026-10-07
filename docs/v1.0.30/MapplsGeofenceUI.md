[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# MapplsGeofenceUI Plugin for iOS

## [Introduction](#Introduction)
Mappls Geofence Plugin SDK provides the functionalities to create a geofence in circle and polygon shape.

## [Getting Started](#Getting-Started)

Anyone can integrate the Mappls Geofence Plugin by following simple steps.Please note that this Plugin for iOS supports iOS SDK 9.0 and above. 

To integrate Geofence SDK, it is important to pass an object of **MapplsMapView** which is part of Mappls's MapplsMap SDK.

## Step 1 :-  [Setup your Project](#Setup-your-Project)

1. To start with,  MapplsAPIKit and MapplsMap frameworks are required to be added in your project. These are available on Cocoapods and it can be accessed by using below pod commands.

    ```cocoapods
    pod 'MapplsGeofenceUI', '1.0.1'
    ```

    **Note:** Mappls's SDK keys will required to initialize MapplsMap SDK. 
    
    Fore more information on setting Click [here](https://github.com/mappls-api/mappls-ios-sdk/).
    user can get the keys by login/signup on Mappls's developer [Dashboard](https://about.mappls.com/api/signup).

    **Below are commands to install SDK using Cocoapods:**

    - `cd Your Project path`
    - `pod init`
    - `pod install`
    - `open your xcworkspace`

### [Version History](#Version-History)

| Version | Dated | Description |
| :---- | :---- | :---- |
| `1.0.1` | 01 Nov, 2022 | Bug fixes due to dependency of APIKit version 2.0.7 |
| `1.0.0` | 10 June, 2022 | Initial Mappls Release |

## Step 2 :-  [Authorization](#Authorization)

### [MapplsAPICore](#MapplsAPICore)
It is required to set Mappls keys to use any MAPPL's SDK. Please refer the documentatation [here](MapplsAPICore.md).

## Step 3 :-  [Initialization of GeofenceViewUI](#Initialization)

To Initialize, add **MapplsGeofenceUI** and **MapplsMap Framework** in your controller File.

```swift
import MapplsMap
import MapplsGeofenceUI
var geofenceView: MapplsGeofenceView!
 override func viewDidLoad() {
        super.viewDidLoad()
  // If you're on a background thread and want to execute code on the main thread, you need to call async()
 DispatchQueue.main.async {
let geofenceInstance: MapplsGeofenceView =  {
geofenceView = MapplsGeofenceView.init(geofenceframe: self.view.bounds)
geofenceView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 return geofenceView
}()
geofenceInstance.delegate = self
self.view.addSubview(geofenceInstance)
}
}
``` 

User must implement the **MapplsGeofenceViewDelegate** protocol class to use delegate methods of MapplsGeofenceView

```
 geofenceInstance.delegate = self
 ```

**Thats All!** The plugin is added in your application. 

This highly customizable plugin offers a wide range of properties can be edited based on the requirements of the users. Lets have alook at them.

## [Customizing the Geofence using various properties](##Customizing):

1. **Set Geofence Mode:** To set Geofence mode as a circle or a polygon

    ```swift
    geofenceView.setMode(mode: .circle)
    ```

2. **Show/Hide Default Slider:** To show/hide CircleSlider. Defaults to true.

    ```swift
    geofenceView.isShowDefaultSliderForCircle = false
    ```
3. **Mode Panel:** To show/hide modePanel for Circle and Polygon. Defaults to true.

    ```swift
    geofenceView.isShowDefaultModePanel = false
    ```

4. **Polygon Delete Button Image:** To change PolygonDelete button default image
 
    ```swift
    geofenceView.deleteBtnDefaultImage = UIImage(named: "")
    ```
5. **Polygon Drag Point To Move DeleteImage:** To change polygonDeleteImage while dragging to any point.
 
    ```swift
    geofenceView.deleteBtnDeleteImage = UIImage(named: "")
    ```
6. **Circle Fill Color:** To set fill color of circle
 
    ```swift
    geofenceView.circlefillColor = .red
    ```
7. **Circle Stroke Color :** To set the stroke color of the circle.
 
    ```swift
    geofenceView.circleStrokeColor = .red
    ```
8. **Polygon Fill Color :**  To set the fill color of the polygon

    ```swift
    geofenceView.polygonFillColor = .red
    ```

9. **Polygon Stroke Color:** To set the stroke of the polygon
    
    ```swift
    geofenceView.polygonStrokeColor = .red
    ```
10. **Polygon ToolTipBackgroundColor:** To change top instruction tool tip Background Color.

    ```swift
    geofenceView.toolTipBackgroundColor = .blue
    ```
11. **Marker Fill Color :** To change Marker Annotation Color.

    ```swift
    geofenceView.markerFillColor = .blue
    ```

12. **Marker Stroke Color :** To change Polygon Marker Stroke Color.

    ```swift
    geofenceView.markerStrokeColor = .blue
    ```
13. **Mid Marker Fill Color :**  To change Polygon Mid Marker Color.

    ```swift
    geofenceView.midMarkerFillColor = .blue
    ```
14. **Circle Slider MinTrack Color :** To change CircleSlider MinTrackColor by using this property. Defaults to blue color.

    ```swift
    geofenceView.sliderMinTrackColor = .blue
    ```
15. **Circle Slider MaxTrack Color :** To change CircleSlider MaxTrackColor by using this property. Defaults to Grey color.

    ```swift
    geofenceView.sliderMaxTrackColor = .blue
    ```
16. **Circle Slider ThumbTint Color :** To  change CircleSlider ThumbTintColor by using this property. Defaults to white.

    ```swift
    geofenceView.sliderThumbTintColor = .blue
    ```

17. **Dragging Edges line Color :** To set geofence Dragging Edges line Color.

    ```swift
    geofenceView.draggingEdgesLineColor = .red
    ```
18. **Geofence Stroke Width :** To set geofence Stroke width.

    ```swift
    geofenceView.geofenceStrokeWidth = 2.5
    ```
19. **Geofence Circle Center marker Image :** To  set the Circle Center marker Image.

    ```swift
        geofenceView.circleCenterMarker = UIImage(named: "image")
    ```
20. **Geofence sketch board overlay :** To  set sketch board overlay color.

    ```swift
    geofenceView.polygonDrawingOverlayColor = .red
    ```
21. **Dynamic zoom level adjustment :** 
To  set zoom of map.

    ```swift
    geofenceView.mapview.zoomlevel = 18
    ```
22. **DefaultOverlayToolTipView :** To  remove default overlay tool tip view.

    ```swift
    geofenceView.showHideDefaultOverlayIcons = true
    ```
23. **BackgroundOvarlayColor :** To  set polygon background overlay color.

    ```swift
    geofenceView.polygonDrawingOverlayColor = UIColor.clear
    ```
24. **IsShowDeleteControl :** To  remove DeleteControlPoint.. Defaults to true.

    ```swift
    geofenceView.IsShowDeleteControl = false
    ```
25. **Polygon Direction :** To  set polygon direction in Clockwise, anticlockwise or None. If set clockwise,the current points will convert in clockwise shape.

    ```swift
    geofenceView.convertPointsToClockWise(pointsType: .clockWise)
    ```

26. **Circle Radius :** To  set the radius of the circle .

    ```swift
    // user can pass your slider value over here 
    geofenceView.circleRadius = slider.value
    ```
27. **Circle Minimum Radius :** To set the minimum value of the circle in the slider.

    ```swift
    geofenceView.circleMinRadius = Double(slider.minimumValue)
    ```
28. **Circle Maximum Radius :** To set the maximum value of the circle in the slider.

    ```swift
    geofenceView.circleMaxRadius = Double(slider.maximumValue)
    ```

29. **Geofence Anchor Point :** To  set Geofence tip marker(Anchor Point) with the help of this property. Default property value is (x=0,y=0). For top tip marker user can set cgpoint value as  below example.

    ```swift
      geofenceView.setGeofenceAnchorPoint = CGPoint(x: 0.5, y: 1.0)
    ```

30. **Circle Proposed Radius :** It is the dotted line draw around a circle when user moves the slider value. Code to use this feature is as follows :

    ```swift
    @IBAction func btnSliderValueChanged(_ sender: UISlider, forEvent event: UIEvent) {
            
      if let touchEvent = event.allTouches?.first {
        switch touchEvent.phase {
          case .began:
          print("Slider Began")
          break
        // handling the drag began
          case .moved:
          print("Slider Moved")
          
          geofenceView.circleProposedRadius = Double(sender.value)

          break
          // handling the drag moved
        case .ended:
        print("Slider Ended") 

          geofenceView.circleRadius = Double(sender.value)

        break
        handle drag ended
        default:
        break
      }
    }
    ```

31. **Circle Center Coordinate :** To set center of circle using coordinates.

    ```swift
    geofenceView.setCircleCenterCoordinate(coordinate: CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025))
    ```

32. **Geofence Polygon Drawing Enabled :** To  enable or disable the polygon drawing board.

    **Note:** *While using Polygon Mode and using setMode functions, it resets property `isPolygonDrawingEnabled` to true. Value of this property must be considered on receiving callback using delegate method geofenceShapeDidChanged.*

    ```swift
    geofenceView.isPolygonDrawingEnabled = true
    ```

33. **Polygon Drawing Stroke Width :** To set the width of stroke of drawing board while creating polygon geofence. Default value is 2.

    ```swift
    geofenceView.polygonDrawingStorkeWidth = 2
    ```

34. **Polygon Drawing Stroke Color :** To set the color of stroke of drawing board while creating polygon geofence.

    ```swift
    geofenceView.polygonDrawingStrokeColor = UIColor.gray
    ```

35. **Change Polygon's Mid Marker Image :** To change image of marker in the middle of polygon edge lines.

    ```swift
    geofenceView.midMarkerViewImage = UIImage(named: "pinMid")
    ```

36. **Change Polygon's Creation Mode :** Polygon can be created either by free hand drawing on a drawing overlay or by simply tapping on the map. 

    As suggested by name itself, it is property is used change mode of creating polygon.Default to `draw`.

    **Note:** *On setting its value to `tap`, value of `isPolygonDrawingEnabled` will be changed to false automatically.*

    ```swift
    geofenceView.polygonCreationMode = .tap
    ```
    
37. **Auto Hide Edge Markers :** Control points of polygon while dragging are visible by default so the value remains false. To hide them, user can set below property to true.

    ```swift
    geofenceView.isHiddenPolygonControlPoints = true
    ```

38. **MapplsGeofenceViewDelegate :** It is a protocol class which will be used for callback methods as shown below:

    **1. Call Back Handler :** Geofence's Shape object can be queried by using this protocol.
    Geofence shape data will return in following case.

    - When CircleSlider Value Changed.
    - When circle centre points changed.
    - When set radius changed.
    - When free hand drawing finished.
    - When polygon point dragging finished.
    - When any polygon point to move and Delete.
    - When Geofence Circle did end dragging. 

    ```swift
    geofenceShapeDidChanged(_ shape: MapplsGeofenceShape)
    ```

     **2. Mode Callback :** It basically returns your current mode like circle or polygon

    ```swift
    geofenceModeChanged (mode: MapplsOverlayShapeGeometryType)
    ```

    **3. Circle Radius Changed :** To  get circle radius changed value in this delegate method.

    ```swift
    circleRadiusChanged(radius: Double) 
    ```
    **3. Circle Radius Changed :** To get if circle did end dragging.

    ```swift
    didDragGeofence(isdragged: Bool)
    ```

39. **Custom Marker on Geofence View :** 
For adding custom marker on geofence view, we have created one class in sample `Custom geofence annotation`. This class is inherited with `MGLPointAnnotation` and  `GeofenceAnnotation`.

    Basically **geofence Annotation** is protocol class that contain annotation image. User can set image by using this property  `geofenceAnnotationImage`.

    **Note** *- To help more, we are showing one marker on the top right corner in the sample app (ClassCustomGeofenceVC)*.


     To Check this, Refer to the code below after creating Polygon Click marker button:

    ```swift
    // Use this class to test marker on map.
    let annotation = CustomGeofenceAnnotation()
    annotation.title = ""
    annotation.coordinate = coordinate
    if let image = UIImage(named: "pin.png") {
    annotation.geofenceAnnotationImage = image
    } 
    geofenceView.mapView.addAnnotation(annotation)
    ```

41. **Polygon Center as Coordinate :** 
We have added property and method to get polygon center as Coordinates.
Below code refers one  Class function and another as global property to get the Polygon Center as coordinate.

    ```swift
    let center = geofenceView.polygonCenterCoordinate
    print(center)
    let location = MapplsGeofenceView.centerCoordinateOf(coordinates: polygonPints, mapView: geofenceView.mapView)
    print(location)
    ```

42. **Rectangle Polygon:**
To draw a rectangle-shaped polygon, mode must be set to polygon, polygonCreationMode property must be set to be tap, isPolygonDrawingEnabled property must be set to false and isRectangleShapeSelected must be set to true. See below code snippet 

    ```swift
    geofenceView.polygonCreationMode = .tap
    geofenceView.setMode(mode: .polygon)
    geofenceView.isPolygonDrawingEnabled = false
    geofenceView.isRectangleShapeSelected = true
    ```

# Sample App

In the Sample **Version 0.5.0**, we have added some more functionalities like:

#### **1. Polygon points Check (Anticlockwise or Clockwise)**
To  see if the polygon points are drawn clockwise or antoclockwise, draw polygon points in sampleApp. We have one button that shows direction in top right corner of custom geofence class.

#### **2. Draw Geofence Shape View**
To  view your geofence created shape by clicking on Apply button(In customGeofenceVC Class). When the user clicks on Apply button, it will navigate to related list in  class(DrawCircleVC).

#### **3. Edit Geofence Shape**
In Class (DrawCircle) we are showing one option to edit on click. 
It will navigate to the related geofence screen with current shape, here, user can modified it.

After clicking Apply button, it will reflect in (DrawCircleVCClass).

#### **4. Delete Geofence Shape**
We have provided a delete button in (rawCircleVC Class). Clicking on this, will delete the current shape in the list.

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
