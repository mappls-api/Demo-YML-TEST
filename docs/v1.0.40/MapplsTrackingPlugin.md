# Tracking Plugin
This advanced tracking plugin, offered by Mappls plugins for IOS, allows one to track the path traveled with smooth animation along the route. The smooth animation by plugin directly depend upon the frequency of the provided information on the current location, time, and speed of the vehicle being tracked to the plugin. More the Merrier!


### [Dependencies](#Dependencies)

This library depends upon several Mappls's own libraries. All dependent libraries will be automatically installed using CocoaPods.

Below are list of dependencies which are required to run this SDK:

- [MapplsAPICore](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPICore.md)
- [MapplsAPIKit](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPIKit.md)
- [MapplsMap](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsMap.md)

## [Installation](#Installation)

This library is available through `CocoaPods`. To install, simply add the following line to your `podfile`:

```ruby
pod 'MapplsUtils', '1.0.0'
```
On running `pod install` command it will automatically download and setup `MapplsUtils` and dependent frameworks.

### [Version History](#Version-History)

| Version | Dated | Description |
| :---- | :---- | :---- |
| `1.0.0` | 22 Dec, 2025 | Initial MapplsUtils Release.|

## [Authorization](#Authorization)


### [MapplsAPICore](#MapplsAPICore)
It is required to set Mappls keys to use any Mappls SDK. Please refer the documentation [here](MapplsAPICore.md).


## [Implementation](#Implementation)
### Initilization
`MapplsTrackingPlugin` need to be initilize. It can be initilized by using map and route where map is optional  

If you have a route on which user want to track the device then you need to initilized `MapplsTrackingPlugin` with `route`
```swift
let plugin = MapplsTrackingPlugin(mapView: mapView, route: selectedRoute)
```

OR

if you dont have route then you can also initilize the plugin with source, destination and viaPoints location. 

```swift
let plugin =  MapplsTrackingPlugin(mapView: mapView, sourceLocation: startCoordinate, destinationLocation: endCoordinate, viaPoint: viaPoints)
```

### Meathods

1. `update` This function is responsible for updating the user's location at intervals set by the user.

    It accept fowlloing parameters

    - `location` : It is optional parameter of type `CLLocationCoordinate2D`, It is the start location of the device.
    - `duration` : It is of type Double, it is the duration (ms) to reach between start and endlocation. its default value is 2000 ms.

    ```swift
        plugin.update(with: coordinate, duration: 2000)
    ```


2. `removeTrackingRoutes` It is the function to remove the polyline and markers.

3. `stopTracking` Ends the tracking by stopping the location animation.


### Properties

- **distanceRemaining :** It is a property to show distanceRemaning to reach the destination. If route is  avaliable.

- **delegate :** A delegate protocol to handle `MapplsTrackingPlugin` events and UI.


### delegate meathods

 - **routeIdentifier** 
 
    A delegate function which used for style polyline for the main route. It returns `MGLLineStyleLayer` which is optional.

    ``` swift
    func mapplsTrackingPlugin(source: MGLShapeSource, routeIdentifier identifier: String) -> MGLLineStyleLayer
    ```

- **traveledPathIdentifier**

    A delegate function which used for style of the covered polyline

    ``` swift
     func mapplsTrackingPlugin(source: MGLShapeSource, traveledPathIdentifier identifier: String) -> MGLLineStyleLayer
    ```

- **willRerouted** 

    A delegate function infroms it is going to reroute.
   
    ``` swift
    func mapplsTrackingPlugin(_ mapView: MapplsMapView?, willRerouted route: Route?)
    ```

- **didRerouted**

    A delegate functiion which gives rerouted route and mapView.
    
    ``` swift
    func mapplsTrackingPlugin(_ mapView: MapplsMapView?, didRerouted route: Route?, error: NSError?)
    ```

- **didArriveAt**

    This delegate method is called when the tracking plugin determines that the user has arrived at a specified coordinate.
    
    ``` swift
    func mapplsTrackingPlugin(_ mapView: MapplsMapView?, didArriveAt coordinate: CLLocationCoordinate2D)
    ```

- **onAnimationStart**

    This ia an optional delegate method which is called when an animation starts between two coordinate.
    
    ``` swift
    func onAnimationStart(animator: MapplsObjectAnimator<CLLocationCoordinate2D, LatLngEvaluator>)
    ```

- **onAnimationEnd**

    This ia an optional delegate method which is called when an animation ends between two coordinate 
    
    ``` swift
    func onAnimationEnd(animator: MapplsObjectAnimator<CLLocationCoordinate2D, LatLngEvaluator>)
    ```

- **remainingDistanceDidChange**

    This delegate method is called when the remaining distance to the destination changes. It provides updates on how much distance is left.
    ```swift
     func mapplsTrackingPlugin(_ mapView: MapplsMapView?, remainingDistanceDidChange remaningDistance: Double?)
    ```

- **waypointMarkerIdentifier**

    This optional delegate method customizes waypoint markers. It accepts a source and identifier, and returns a SymbolStyleLayer, allowing for personalized styling of the waypoint markers.
    ```swift
    func mapplsTrackingPlugin(source: MGLSource, waypointMarkerIdentifier identifier: String) -> MGLSymbolStyleLaye
    ```
    
- **sourceMarkerIdentifier**

    This optional delegate method customizes source markers. It accepts a source and identifier, and returns a SymbolStyleLayer, allowing for personalized styling of the source markers.
    ```swift
    func mapplsTrackingPlugin(source: MGLSource, sourceMarkerIdentifier identifier: String) -> MGLSymbolStyleLaye
    ```

- **destinationMarkerIdentifier**

    This optional delegate method customizes destination markers. It accepts a source and identifier, and returns a SymbolStyleLayer, allowing for personalized styling of the destination markers.
    ```swift
    func mapplsTrackingPlugin(source: MGLSource, destinationMarkerIdentifier identifier: String) -> MGLSymbolStyleLaye
    ```

- **routeOptions**
    This optional delegate method is triggered each time a route request is made, allowing customization of the route request parameters.
    ```swift
    func mapplsTrackingPlugin(for routeOptions : RouteOptions) -> RouteOptions
    ```

- **riderMarkerIdentifier**

    This optional delegate method customizes rider markers. It accepts a source and identifier, and returns a SymbolStyleLayer, allowing for personalized styling of the waypoint markers.
    ```swift
    func mapplsTrackingPlugin(source: MGLSource, riderMarkerIdentifier identifier: String) -> MGLSymbolStyleLaye
    ```
- **cameraThatFit**

    This optional delegate method is responsible for customizing the map camera as the rider travels from one point to another.

    ```swift
     func mapplsTrackingPlugin(cameraThatFit shape: MGLPolyline, mapView: MapplsMapView)
    ```

### MapplsTrackingPluginConfiguration

`MapplsTrackingPluginConfiguration` class to set the configurations for `MapplsTrackingPlugin`.

#### Properties


- **allowMapToAnimate :**  Allow map to animate with user location

- **markerImage :**  Image for user location of type `UIImage`

- **scaleMarkerImage :**  It is a property to scale the marker size its default value `1.0 `

- **shouldShowTraveledRoute :** It is a boolean property to show traveled Polyline or not, Its default valueis `true`

- **shouldShowTraveledRoute :**  It is a boolean property to draw polyline for traveled  route.

- **shouldRemoveTraveledRoute :**  It is a boolean property to remove the route traveled  route.


## Example 

for Tracking mode i.e when user have fixed route to travel 

```swift
let plugin = MapplsTrackingPlugin(mapView: self.mapView, route: selectedRoute)

// Will be called on location changed.
plugin.update(with: coordinate, duration: 2)

```


# TrackingPluginCore 

## MapplsLocationAnimator

`MapplsLocationAnimator` is a class responsible for animating location updates.

### [Implementation](#Implementation)

### Initilization
`MapplsLocationAnimator` need to be initilize. It can be initilized with empty constructor.

 
 ### Meathods

 1. `animateLocation` it is the meathod of `MapplsLocationAnimator` class Animates the location along the given coordinates with the specified duration.

    It accept fowlloing parameters

    - `coordinates` : The coordinates through which the animation should proceed.
    - `duration` :The total duration of the animation.

    ```swift
        plugin.update(with: coordinate, duration: 2)
    ```

### properties 

1. `delegate`:  A delegate protocol to handle location updates and animation events.

### delegate meathods

1. `didUpdateLocation` it will trigged on every location chage during animation between two coordinates and it return the animated location.

1. `onAnimationStart` it will be triggred when location animation get started

1. `onAnimationEnd` it will be triggred when location animation end



