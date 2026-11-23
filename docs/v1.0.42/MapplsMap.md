[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/>](https://about.mappls.com/api/)

# Mappls Map SDK for iOS

`MapplsMap` adds interactive Mappls maps to your iOS app. Show the map, add markers and shapes, place them with [Mappls Pins](MapplsGuides/MapplsPin.md), switch [map styles](MapplsGuides/MapStyles.md), and show [indoor floors](MapplsGuides/IndoorMaps.md) and [live traffic](MapplsGuides/TrafficLayers.md). Maps work in UIKit and SwiftUI, from Swift and Objective-C.

## Contents

- [Requirements](#requirements)
- [Version history](#version-history)
- [Installation](#installation)
- [Quick start](#quick-start)
- [Guides](#guides)
- [Map interactions](#map-interactions)
- [Map features](#map-features)
- [Map events](#map-events)
- [SDK error codes](#sdk-error-codes)
- [Map tap events](#map-tap-events)
- [Markers](#map-overlays)
- [Polylines](#polylines) · [Polygons](#polygons) · [Map camera](#map-camera) · [Shape styling](#miscellaneous)
- [Cluster based authentication](#cluster-based-authentication)
- [SwiftUI](#swiftui)
- [Support](#support)

## Requirements

- iOS 13.0 or later
- Xcode 15 or later. To support iOS 13 or 14 in your app, use Xcode 26.x or earlier: Xcode 27 only builds apps for iOS 15.0 and later.
- [CocoaPods](https://cocoapods.org) 1.10 or later, or Swift Package Manager
- Your Mappls API keys: map SDK key, REST API key, client ID and client secret. See [Quick start](#2-add-your-mappls-keys).

## Version History

| Version | Dated | Description |
| :------ | :---- | :---------- |
| `7.0.2`| 23 Nov 2026 | - Fixed `#import <MapplsMap/MapplsMap.h>` not found in 7.0.1. |
| `7.0.1`| 19 Nov 2026 | - Updated map rendering engine, with performance improvements and bug fixes. <br> - CocoaPods: add the `MapplsAPICore` and `MapplsAPIKit` pods yourself, see [Installation](#installation). <br> - Added `BuildingMapPlugin` to hide and show 3D buildings. <br> - Added `getAvailableMapplsMapStyle()` to `MapplsMapView`. <br> - Fixed map labels in regional languages, such as Hindi, being shown on a single line. |
| `6.0.1`| 23 July 2025 | - Added a provision to restrict setting the default style. |
| `6.0.0`| 06 Jun 2025 | - Updated minimum iOS deployment target to 13.0 <br> - Authentication and authorization mechanisms have been revised. |

See [CHANGELOG.md](CHANGELOG.md) for details.

## Installation

Install `MapplsMap` with [CocoaPods](#cocoapods) or [Swift Package Manager](#swift-package-manager). Use one of them, not both.

### CocoaPods

The `MapplsMap` pod contains only the `MapplsMap` framework. Add the `MapplsAPICore` and `MapplsAPIKit` pods it needs as well. If either one is missing, the app crashes at launch with `dyld: Library not loaded: @rpath/MapplsAPICore.framework/MapplsAPICore` (or `MapplsAPIKit`).

1. If your project has no `Podfile` yet, run `pod init` in the folder that contains your `.xcodeproj`.
2. Add the three pods to your app target in the `Podfile`:

   ```ruby
   platform :ios, '13.0'

   target 'YourApp' do
     use_frameworks!
     pod 'MapplsMap', '7.0.2'
     pod 'MapplsAPICore', '1.0.18'
     pod 'MapplsAPIKit', '2.0.39'
   end
   ```

3. Run:

   ```sh
   pod install --repo-update
   ```

4. From now on, open the `.xcworkspace` file that CocoaPods created, not the `.xcodeproj`.

To update from an earlier version, change the version in the `Podfile` and run `pod update MapplsMap`. From 6.x, update the version yourself: a `~> 6.0` requirement doesn't install 7.x.

### Swift Package Manager

The `MapplsMap` package contains only the `MapplsMap` framework. It also needs `MapplsAPICore` 1.0.18 and `MapplsAPIKit` 2.0.39, which you add to your app yourself. If either one is missing, the app crashes at launch with `dyld: Library not loaded: @rpath/MapplsAPICore.framework/MapplsAPICore` (or `MapplsAPIKit`).

1. In Xcode, open your project and select **File > Add Package Dependencies…**.
2. Paste `https://github.com/MapmyIndia/mappls-map-ios-distribution` into the search field.
3. Set **Dependency Rule** to **Exact Version** `7.0.2` (or **Up to Next Major Version** from `7.0.2`) and click **Add Package**.
4. In the next dialog, add the `MapplsMap` library to your app target and click **Add Package**.
5. Download and unzip [MapplsAPICore 1.0.18](https://mmi-api-team.s3.amazonaws.com/Mappls-SDKs/iOS_Legacy_Auth/MapplsAPICore/MapplsAPICore.xcframework-1.0.18.zip) and [MapplsAPIKit 2.0.39](https://mmi-api-team.s3.amazonaws.com/Mappls-SDKs/iOS_Legacy_Auth/MapplsAPIKit/MapplsAPIKit.xcframework-2.0.39.zip). Drag `MapplsAPICore.xcframework` and `MapplsAPIKit.xcframework` into your project, with **Copy items if needed** checked and your app target selected.
6. Select your app target, open **General > Frameworks, Libraries, and Embedded Content**, check that `MapplsMap`, `MapplsAPICore` and `MapplsAPIKit` are all listed, and set `MapplsAPICore` and `MapplsAPIKit` to **Embed & Sign**.

See [Adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) for more detail.

## Quick start

These steps take you from an empty project to a map on screen.

### 1. Install the packages

Install `MapplsMap` with CocoaPods or Swift Package Manager, as described in [Installation](#installation).

### 2. Add your Mappls keys

Your app is authorized with the keys of your Mappls account: a map SDK key, a REST API key, a client ID and a client secret. Get them from the [Mappls API dashboard](https://about.mappls.com/api/), or contact [apisupport@mappls.com](mailto:apisupport@mappls.com).

Add them to your app's `Info.plist`. The SDK reads them when the app starts:

```xml
<key>MapplsSDKKey</key>
<string>YOUR_MAP_SDK_KEY</string>
<key>MapplsRestKey</key>
<string>YOUR_REST_API_KEY</string>
<key>MapplsClientId</key>
<string>YOUR_CLIENT_ID</string>
<key>MapplsClientSecret</key>
<string>YOUR_CLIENT_SECRET</string>
<key>MapplsGrantType</key>
<string>client_credentials</string>
```

> **Important:** keys in `Info.plist` or in code can be read from the app bundle. Don't commit them to a public repository.

### 3. Add location permissions (optional)

If you show the user's location (`showsUserLocation`), add a usage description to your `Info.plist`. Write a message that explains why your app needs the location:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Your location is shown on the map.</string>
```

Add `NSLocationAlwaysAndWhenInUseUsageDescription` as well if your app uses the location in the background.

### 4. Set the keys in code (optional)

If you didn't add the keys to `Info.plist`, for example because your app gets them from your server, set them with `MapplsAccountManager` when the app starts and before you create a map view.

#### Swift

```swift
import MapplsAPICore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MapplsAccountManager.setMapSDKKey(mapSDKKey)
        MapplsAccountManager.setRestAPIKey(restAPIKey)
        MapplsAccountManager.setClientId(clientId)
        MapplsAccountManager.setClientSecret(clientSecret)
        MapplsAccountManager.setGrantType("client_credentials")
        return true
    }
}
```

#### Objective-C

```objectivec
@import MapplsAPICore;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MapplsAccountManager setMapSDKKey:mapSDKKey];
    [MapplsAccountManager setRestAPIKey:restAPIKey];
    [MapplsAccountManager setClientId:clientId];
    [MapplsAccountManager setClientSecret:clientSecret];
    [MapplsAccountManager setGrantType:@"client_credentials"];
    return YES;
}
```

### 5. Show a map

`MapplsMapView` authorizes itself and loads the default Mappls style when it is created.

#### Swift

```swift
import MapplsMap
import UIKit

class ViewController: UIViewController, MapplsMapViewDelegate {
    var mapView: MapplsMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapplsMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.551438, longitude: 77.265119),
                          zoomLevel: 12, animated: false)
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MapplsMapView, authorizationCompleted isSuccess: Bool, withError error: Error?) {
        if !isSuccess {
            print("Map authorization failed: \(error?.localizedDescription ?? "unknown error")")
        }
    }
}
```

#### Objective-C

```objectivec
@import MapplsMap;

@interface ViewController () <MapplsMapViewDelegate>
@property (nonatomic) MapplsMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MapplsMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.551438, 77.265119) zoomLevel:12 animated:NO];
    [self.view addSubview:self.mapView];
}

- (void)mapView:(MapplsMapView *)mapView authorizationCompleted:(BOOL)isSuccess withError:(NSError *)error {
    if (!isSuccess) {
        NSLog(@"Map authorization failed: %@", error.localizedDescription);
    }
}

@end
```

#### Interface Builder

Add a **View** to your view controller, then in the **Identity inspector** set its **Class** to `MapplsMapView` and **Module** to `MapplsMap`. Connect its `delegate` outlet to your view controller.

For SwiftUI, see [SwiftUI](#swiftui).

### 6. Authorize in advance (optional)

The map authorizes itself, but you can start authorization earlier, for example on the screen before the map. The map then loads faster:

```swift
import MapplsMap

MapplsMapAuthenticator.sharedManager().initializeSDKSession { isSuccess, error in
    if let error {
        print("Authorization failed: \(error.localizedDescription)")
    }
}
```

```objectivec
[[MapplsMapAuthenticator sharedManager] initializeSDKSession:^(BOOL isSuccess, NSError * _Nullable error) {
    if (!isSuccess) {
        NSLog(@"Authorization failed: %@", error.localizedDescription);
    }
}];
```

If authorization fails, the map shows an error message with a **Retry** button. See [SDK error codes](#sdk-error-codes) for the possible errors.

### Debugging

Turn on SDK logs while you develop:

```swift
import MapplsAPICore
import MapplsMap

MapplsAccountManager.setIsEnableLogging(true)
MGLLoggingConfiguration.shared.loggingLevel = .verbose
```

## Guides

| Guide | What you'll learn |
| :---- | :---------------- |
| [Markers](MapplsGuides/Markers.md) | Add markers as annotations (custom images, views, callouts) or as style layers (icons, labels, colors from data, taps, clustering). |
| [Polylines](MapplsGuides/Polylines.md) | Draw lines as annotations or as style layers (outline, zoom-based width, dashes, gradients, below the labels). |
| [Mappls Pin](MapplsGuides/MapplsPin.md) | Add markers, center the map and move the camera with Mappls Pins, and get the Mappls Pin of a tapped place. |
| [Map Styles](MapplsGuides/MapStyles.md) | List the available Mappls styles, switch styles, build a style picker, use your own style. |
| [Indoor Maps](MapplsGuides/IndoorMaps.md) | Show building floors and position the floor selector. |
| [Live Traffic](MapplsGuides/TrafficLayers.md) | Show live traffic and choose free flow, congestion, closures and incident icons. |

## [Map Interactions](#Map-Interactions)

### [Set Zoom Level](#Set-Zoom-Level)

Set zoom to 4 for country level display and 18 for house number display.

#### Objective C

```objectivec
self.mapView.zoomLevel = 4;
```

#### Swift

```swift
mapView.zoomLevel = 4
```

### [Set Map Center](#Set-Map-Center)

To set Center of map reference code is below:

#### Objective C

```objectivec
[self.mapView setCenterCoordinate: CLLocationCoordinate2DMake(28.551438, 77.265119)];
```

#### Swift

```swift
mapView.centerCoordinate = CLLocationCoordinate2DMake(28.551438, 77.265119)
```

## [Map Features](#Map-Features)

### Current Location

To show user's current location on map, use property `.showsUserLocation.` and set its value to true.

#### Objective C

```objectivec
mapView.showsUserLocation = YES;
```

#### Swift

```swift
mapView.showsUserLocation = true
```

To get current location, use property `.userLocation.` its of type `MGLUserLocation` which contains `location` property. 

#### Swift

```swift
if let location = mapView.userLocation?.location {
    print(location.coordinate)
}
```

### Tracking Mode

To move map with user location change use property `userTrackingMode`. Its an enum property of type `.MGLUserTrackingMode.`. You can set any value from following:

- `followWithCourse`
- `followWithHeading`
- `none`

#### Objective C

```objectivec
self.mapView.userTrackingMode = MGLUserTrackingModeFollowWithCourse;
```

#### Swift

```swift
mapView.userTrackingMode = .followWithCourse
```

## [Map Events](#Map-Events)

The Map object should implement the methods of the `MapplsMapViewDelegate` protocol corresponding to the events you wish it to receive. This delegate can also be used to detect map overlays selection. Delegate handles gesture events, tap on annotation (marker) and map center coordinates.


### [Map Position Changes Events](#Map-Position-Changes-Events)
```
-(BOOL)mapView:(MGLMapView *)mapView shouldChangeFromCamera:(MGLMapCamera*)oldCamera toCamera:(MGLMapCamera *)newCamera;
-(BOOL)mapView:(MGLMapView *)mapView shouldChangeFromCamera:(MGLMapCamera*)oldCamera toCamera:(MGLMapCamera *)newCamera reason:(MGLCameraChangeReason)reason;
-(void)mapView:(MGLMapView *)mapView regionWillChangeAnimated:(BOOL)animated;
-(void)mapView:(MGLMapView *)mapView regionWillChangeWithReason:(MGLCameraChangeReason)reason animated:(BOOL)animated;
-(void)mapViewRegionIsChanging:(MGLMapView *)mapView;
-(void)mapView:(MGLMapView *)mapView regionIsChangingWithReason:(MGLCameraChangeReason)reason;
-(void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated;`
-(void)mapView:(MGLMapView *)mapView regionDidChangeWithReason:(MGLCameraChangeReason)reason animated:(BOOL)animated;
```
### [Loading the Map Events](#Loading-the-Map-Events)

#### [-authorizationCompleted:withError:]()

This delegate function will be called whenever authorization process of map completed. It gives either sucess or error 

**Objective-C**
```objectivec
- (void)mapView:(MapplsMapView *)mapView authorizationCompleted:(BOOL)isSuccess withError:(nullable NSError *)error;
```

**Swift**
```swift
func mapView(_ mapView: MapplsMapView, authorizationCompleted isSuccess: Bool, withError error: Error?) {
        
 }
```


#### [-mapViewWillStartLoadingMap:]()
Tells the delegate that the map view will begin to load.

This method is called whenever the map view starts loading, including when a new style has been set and the map must reload.

**Objective-C**
```objectivec
- (void)mapViewWillStartLoadingMap:(nonnull MGLMapView *)mapView;  
```

**Swift**
```swift
optional func mapViewWillStartLoadingMap(_ mapView: MGLMapView)
```

#### [-mapViewDidFinishLoadingMap:]()

Tells the delegate that the map view has finished loading.

This method is called whenever the map view finishes loading, either after the initial load or after a style change has forced a reload.

**Objective-C**
```objectivec
- (void)mapViewDidFinishLoadingMap:(nonnull MGLMapView *)mapView;
```

**Swift**
```swift
optional func mapViewDidFinishLoadingMap(_ mapView: MGLMapView)
```

#### [-mapViewDidFailLoadingMap:withError:]()

Tells the delegate that the map view was unable to load data needed for displaying the map.

This method may be called for a variety of reasons, including a network connection failure or a failure to fetch the style from the server. You can use the given error message to notify the user that map data is unavailable.

**Objective-C**
```objectivec
- (void)mapViewDidFailLoadingMap:(nonnull MGLMapView *)mapView
                       withError:(nonnull NSError *)error;
```

**Swift**
```swift
optional func mapViewDidFailLoadingMap(_ mapView: MGLMapView, withError error: Error)
```


#### [-mapViewWillStartRenderingFrame:]()

Tells the delegate that the map view is about to redraw.

This method is called any time the map view needs to redraw due to a change in the viewpoint or style property transition. This method may be called very frequently. Therefore, your implementation of this method should be as lightweight as possible to avoid affecting performance.

**Objective-C**
```objectivec
- (void)mapViewWillStartRenderingFrame:(nonnull MGLMapView *)mapView;
```

**Swift**
```swift
optional func mapViewWillStartRenderingFrame(_ mapView: MGLMapView)
```

#### [-mapViewDidFinishRenderingFrame:fullyRendered:]()

Tells the delegate that the map view has just redrawn.

This method is called any time the map view needs to redraw due to a change in the viewpoint or style property transition. This method may be called very frequently. Therefore, your implementation of this method should be as lightweight as possible to avoid affecting performance.

**Objective-C**
```objectivec
- (void)mapViewDidFinishRenderingFrame:(nonnull MGLMapView *)mapView
                         fullyRendered:(BOOL)fullyRendered;
```

**Swift**
```swift
optional func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView, fullyRendered: Bool)
```

#### [-mapViewDidBecomeIdle:]()

Tells the delegate that the map view is entering an idle state, and no more drawing will be necessary until new data is loaded or there is some interaction with the map.

**Objective-C**
```objectivec
- (void)mapViewDidBecomeIdle:(nonnull MGLMapView *)mapView;
```

**Swift**
```swift
optional func mapViewDidBecomeIdle(_ mapView: MGLMapView)
```

#### [-mapView:didFinishLoadingStyle:]()

Tells the delegate that the map has just finished loading a style.

This method is called during the initialization of the map view and after any subsequent loading of a new style.

**Objective-C**
```objectivec
- (void)mapView:(nonnull MGLMapView *)mapView
    didFinishLoadingStyle:(nonnull MGLStyle *)style;
```

**Swift**
```swift
optional func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle)
```

#### [-mapView:didTapPlaceWithMapplsPin:]()

Called when the user taps a labelled place on the map, with that place's Mappls Pin. See the [Mappls Pin guide](MapplsGuides/MapplsPin.md#get-the-mappls-pin-of-a-tapped-place) for an example.

**Objective-C**
```objectivec
- (void)mapView:(MGLMapView *)mapView didTapPlaceWithMapplsPin:(NSString *)mapplsPin;
```

**Swift**
```swift
optional func mapView(_ mapView: MGLMapView, didTapPlaceWithMapplsPin mapplsPin: String?)
```

## SDK Error Codes

When authorization fails, `mapView(_:authorizationCompleted:withError:)` and `MapplsMapAuthenticator.initializeSDKSession` return an `NSError` with one of these codes:

| Code | Error | What to do |
| :--- | :---- | :--------- |
| `1` | Map SDK key missing | Set `MapplsSDKKey` (see [Add your Mappls keys](#2-add-your-mappls-keys)). |
| `2` | REST API key missing | Set `MapplsRestKey`. |
| `3` | Client ID missing | Set `MapplsClientId`. |
| `4` | Client secret missing | Set `MapplsClientSecret`. |
| `5` | Grant type missing | Set `MapplsGrantType` to `client_credentials`. |
| `7` | Token request failed | Check the network connection and that the client ID and secret are correct, then retry. |
| `8` | Account check failed | The keys aren't valid for this app. Contact [apisupport@mappls.com](mailto:apisupport@mappls.com). |
| `9` | Map key request failed | Retry; if it keeps failing, contact support. |
| `10` | Map configuration request failed | Retry; if it keeps failing, contact support. |

```swift
func mapView(_ mapView: MapplsMapView, authorizationCompleted isSuccess: Bool, withError error: Error?) {
    guard !isSuccess, let error = error as NSError? else { return }
    print("Authorization failed (\(error.code)): \(error.localizedDescription)")
}
```

To hide the built-in error message with the **Retry** button and show your own, call this before you create the map view:

```swift
MapplsAccountManager.setIsHiddenAuthorizationFailOverlay(true)
```

### [Tracking User Location Events](#Tracking-User-Location-Events)

```
-(void)mapViewWillStartLocatingUser:(MGLMapView *)mapView;
-(void)mapViewDidStopLocatingUser:(MGLMapView *)mapView;
-(void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(nullableMGLUserLocation *)userLocation;
-(void)mapView:(MGLMapView *)mapView didFailToLocateUserWithError:(NSError*)error;
-(void)mapView:(MGLMapView *)mapView didChangeUserTrackingMode:(MGLUserTrackingMode)mode animated:(BOOL)animated;
```

### [Appearance of Annotations Events](#Appearance-of-Annotations-Events)

```
-(nullable MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation;
-(CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape*)annotation;
-(UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation;
-(UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation;
-(CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation;
```

### [Annotation Views Events](#Annotation-Views-Events)

```
-(nullable MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation;
-(void)mapView:(MGLMapView *)mapView didAddAnnotationViews: (NS_ARRAY_OF(MGLAnnotationView *) *)annotationViews;
```

### [Selecting Annotations Events](#Selecting-Annotations-Events)
```
-(void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id <MGLAnnotation>)annotation;
-(void)mapView:(MGLMapView *)mapView didDeselectAnnotation:(id <MGLAnnotation>)annotation;
-(void)mapView:(MGLMapView *)mapView didSelectAnnotationView: (MGLAnnotationView *)annotationView;
-(void)mapView:(MGLMapView *)mapView didDeselectAnnotationView: (MGLAnnotationView *)annotationView;
```

### [Callout Views Events](#Callout-Views-Events)

```
-(BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation;
-(nullable id <MGLAnnotation>)mapView:(MGLMapView *)mapView calloutViewForAnnotation:(id <MGLAnnotation>)annotation;
-(nullable UIView *)mapView:(MGLMapView *)mapView leftCalloutAccessoryViewForAnnotation:(id  <MGLAnnotation>)annotation;
-(nullable UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id <MGLAnnotation>)annotation;
-(void)mapView:(MGLMapView *)mapView annotation:(id <MGLAnnotation>)annotation calloutAccessoryControlTapped:(UIControl *)control;
-(void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id <MGLAnnotation>)annotation;
```

## [Map Tap Events](#Map-Tap-Events)

### [Single Tap Gesture](#Single-Tap-Gesture)

To capture single tap on map events add a tap gesture to instance of `MapplsMapView`. Tapped CGPoint on map can be converted to CLLocationCoordinate object. Also if there is any mareker in tapped area that can also be retrieved. Code for reference to explain above features is below:

#### Objective C

```objectivec
UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
initWithTarget:self action:@selector(didTapPress:)];
[self.mapView addGestureRecognizer:singleTap];

-(void)didTapPress:(UILongPressGestureRecognizer *)gesture {
  if(UIGestureRecognizerStateEnded == gesture.state) {
    CGPoint touchPoint = [sender locationInView:self.mapView];

    // Convert tapped area point to a CLLocationCoordinate object
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView;

    // Also existing annotation or features can be checked on tapped area point
    NSArray<id <MGLFeature>> * visibleFeatures = [self.mapView visibleFeaturesAtPoint: touchPoint];
    if (visibleFeatures.count > 0) {

    }
  }
}
```

#### Swift

```swift
let singleTap = UITapGestureRecognizer(target: self, action:
 #selector(didTapMap(tap:)))
 mapView.addGestureRecognizer(singleTap)
 @objc func didTapMap(tap: UITapGestureRecognizer) {
 if tap.state == .ended {
    let point = tap.location(in: mapView)

    // Convert tapped area point to a CLLocationCoordinate object
    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

    // Also existing annotation or features can be checked on tapped area point
    let visibleFeatures = mapView.visibleFeatures(at: point)
    if visibleFeatures.count > 0 {

    }
  }
}
```

### [Long Tap Gesture](#Long-Tap-Gesture)

To capture long press on map events add a long press gesture to instance of `MapplsMapView`.

#### Objective C

```objectivec
UILongPressGestureRecognizer *longPress =  [[UILongPressGestureRecognizer
alloc] initWithTarget:self action:@selector(didLongPress:)];
[longPress setMinimumPressDuration:1.0];

[self.mapView addGestureRecognizer:longPress];
-(void)didLongPress:(UILongPressGestureRecognizer *)gesture {
  if(UIGestureRecognizerStateEnded == gesture.state) {
    CGPoint touchPoint = [sender locationInView:self.mapView];

    // Convert tapped area point to a CLLocationCoordinate object
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView;

    // Also existing annotation or features can be checked on tapped area point
    NSArray<id <MGLFeature>> * visibleFeatures = [self.mapView visibleFeaturesAtPoint: touchPoint];
    if (visibleFeatures.count > 0) {

    }
  }
}
```

#### Swift

```swift
let longPress = UILongPressGestureRecognizer(target: self, action:
#selector(didLongPress(tap:)))
mapView.addGestureRecognizer(longPress)
@objc func didLongPress(tap: UILongPressGestureRecognizer) {
if tap.state == .ended {
    let point = tap.location(in: mapView)

    // Convert tapped area point to a CLLocationCoordinate object
    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

    // Also existing annotation or features can be checked on tapped area point
    let visibleFeatures = mapView.visibleFeatures(at: point)
    if visibleFeatures.count > 0 {

    }
  }
}
```

## [Map Overlays](#Map-Overlays)

> The [Markers guide](MapplsGuides/Markers.md) covers markers in more depth, both as annotations and as style layers (icons, labels, colors from data, taps and clustering).

### Add marker
To show an annotation on map create an instance of `MGLPointAnnotation` and add that object to instance of `MapplsMapView` using method `addAnnotation.`.

After creating instance of `MGLPointAnnotation`, set coordinate and title property values.

#### Objective C
```objectivec
MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
point.coordinate = CLLocationCoordinate2DMake(28.550834, 77.268918);
point.title = @"Annotation";
[self.mapView addAnnotation:point];
```
#### Swift
```swift
var point = MGLPointAnnotation()
point.coordinate = CLLocationCoordinate2D(latitude: 28.550834, longitude: 77.268918)
point.title = "Annotation"
mapView.addAnnotation(point)
```

### Remove marker

#### Objective C
```objectivec
[self.mapView removeAnnotation:point];
```
#### Swift
```swift
mapView.removeAnnotation(point)
```

### Custom Marker (Change Default Marker Icon)

To change image for default marker you can use delegate methods of protocol  
`MapplsMapViewDelegate`. 
Either you can override whole view of marker by using below method of delegate:
```
-(nullable MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation;
```
or you can override image of marker by using below method of delegate:
```
-(nullable MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation;
```

### Show Info Window (Callout)

To enable info window on tap of marker return true from below delegate method:

```objectivec
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation;
```

### Custom Info Window(#Custom-Info-Window)

To change default callout view of annotation use delegate function of `MapplsMapViewDelegate.` protocol and return custom view of callout from that function.

```swift
func mapView(_ mapView: MGLMapView, calloutViewFor annotation:
MGLAnnotation) -> MGLCalloutView? {
return CustomCalloutView(representedObject: annotation)
}
```

To create custom callout view create a class inherited from `.MGLCalloutView.` and `.UIView.`. Override draw function of `UIView` to design your own callout view.

## [Polylines](#Polylines)

> The [Polylines guide](MapplsGuides/Polylines.md) covers lines in more depth, both as annotations and as style layers (outline, zoom-based width, dashes, gradients, drawing below labels).

### Add a Polyline

To show a polyline on map create an instance of `MGLPolyline` and add that object to instance of `MGLMapView` using method `.addAnnotation.`.

To create instance of `MGLPolyline` an array of `CLLocationCoordinate2D` will be required so first create an array of `CLLocationCoordinate2D`.

#### Objective C

```objectivec
CLLocationCoordinate2D coordinates[] = {
CLLocationCoordinate2DMake(28.550834, 77.268918),
CLLocationCoordinate2DMake(28.551059, 77.268890),
CLLocationCoordinate2DMake(28.550938, 77.267641),
CLLocationCoordinate2DMake(28.551764, 77.267575),
CLLocationCoordinate2DMake(28.552068, 77.267599),
CLLocationCoordinate2DMake(28.553836, 77.267450),
};
NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates count:numberOfCoordinates];
[self.mapView addAnnotation:polyline];
```
#### Swift

```swift
var coordinates = [
CLLocationCoordinate2D(latitude: 28.550834, longitude: 77.268918),
CLLocationCoordinate2D(latitude: 28.551059, longitude: 77.268890),
CLLocationCoordinate2D(latitude: 28.550938, longitude: 77.267641),
CLLocationCoordinate2D(latitude: 28.551764, longitude: 77.267575),
CLLocationCoordinate2D(latitude: 28.552068, longitude: 77.267599),
CLLocationCoordinate2D(latitude: 28.553836, longitude: 77.267450),
]
let polyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
mapView.addAnnotation(polyline)
```

### [Remove a Polyline](#Remove-a-Polyline)

#### Objective C

```objectivec
[self.mapView removeAnnotation:polyline];
```

#### Swift

```swift
mapView.removeAnnotation(polyline)
```

### [Polyline Width](#Polyline-Width)

Line width in points can be set when rendering the outline of a polyline annotation. It cab be achieve by using delegate method `lineWidthForPolylineAnnotation`.

By default, the polyline is outlined with a line 3.0 points wide.

#### Objective C

```objectivec
- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation
{
  return 10.0;
}
```

#### Swift

```swift
func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
  return 10.0
}
```

## [Polygons](#Polygons)

### [Add a Polygon](#Add-a-Polygon)

To show a polygon on map create an instance of `MGLPolygon` and add that object to instance of `MGLMapView` using method `.addAnnotation.`.

To create instance of `MGLPolygon` an array of `CLLocationCoordinate2D` will be required so first create an array of `CLLocationCoordinate2D`.

#### Objective C

```objectivec
CLLocationCoordinate2D coordinates[] = {
CLLocationCoordinate2DMake(28.550834, 77.268918),
CLLocationCoordinate2DMake(28.551059, 77.268890),
CLLocationCoordinate2DMake(28.550938, 77.267641),
CLLocationCoordinate2DMake(28.551764, 77.267575),
CLLocationCoordinate2DMake(28.552068, 77.267599),
CLLocationCoordinate2DMake(28.553836, 77.267450),
};
NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
MGLPolygon *polygon = [MGLPolygon polygonWithCoordinates:coordinates count:numberOfCoordinates];//
[self.mapView addAnnotation:polygon];
```

#### Swift

```swift
var coordinates = [
CLLocationCoordinate2D(latitude: 28.550834, longitude: 77.268918),
CLLocationCoordinate2D(latitude: 28.551059, longitude: 77.268890),
CLLocationCoordinate2D(latitude: 28.550938, longitude: 77.267641),
CLLocationCoordinate2D(latitude: 28.551764, longitude: 77.267575),
CLLocationCoordinate2D(latitude: 28.552068, longitude: 77.267599),
CLLocationCoordinate2D(latitude: 28.553836, longitude: 77.267450),
]
let polygon = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
mapView.addAnnotation(polygon)
```


### [Remove a Polygon](#Remove-a-Polygon)

#### Objective C

```objectivec
[self.mapView removeAnnotation:polygon];
```

#### Swift

```swift
mapView.removeAnnotation(polygon)
```

## [Map Camera](#Map-Camera)

### [Fit Map Camera](#Fit-Map-Camera)

`showAnnotations` function sets the visible region so that the map displays the specified annotations.

#### Swift

```swift
mapView.showAnnotations(annotations, animated: true)
```

### [Create Camera For Shape](#Create-Camera-For-Shape)

A camera object that best fits the given shape with some additional padding on each side while looking in the specified direction can be retrieved using function `cameraThatFitsShape` of `MapplsMapView`.

After creating a camera object using above function it can be set to fit map visible area.

#### Objective C

```objectivec
CLLocationCoordinate2D coordinates[] = {
  CLLocationCoordinate2DMake(28.550834, 77.268918),
  CLLocationCoordinate2DMake(28.551059, 77.268890),
  CLLocationCoordinate2DMake(28.550938, 77.267641),
  CLLocationCoordinate2DMake(28.551764, 77.267575),
  CLLocationCoordinate2DMake(28.552068, 77.267599),
  CLLocationCoordinate2DMake(28.553836, 77.267450),
};

NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
MGLPolygon *polygon = [MGLPolygon polygonWithCoordinates:coordinates count:numberOfCoordinates];//
[self.mapView addAnnotation:polygon];
MGLMapCamera *shapeCam = [self.mapView cameraThatFitsShape:polygon direction:(0) edgePadding:UIEdgeInsetsMake(20, 20, 20, 20)];
[self.mapView setCamera:shapeCam];
```

#### Swift

```swift
var coordinates = [
  CLLocationCoordinate2D(latitude: 28.550834, longitude: 77.268918),
  CLLocationCoordinate2D(latitude: 28.551059, longitude: 77.268890),
  CLLocationCoordinate2D(latitude: 28.550938, longitude: 77.267641),
  CLLocationCoordinate2D(latitude: 28.551764, longitude: 77.267575),
  CLLocationCoordinate2D(latitude: 28.552068, longitude: 77.267599),
  CLLocationCoordinate2D(latitude: 28.553836, longitude: 77.267450),
]
let polyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
let shapeCam = mapView.cameraThatFitsShape(polyline, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
mapView.setCamera(shapeCam, animated: false)
```

## [Miscellaneous](#Miscellaneous)

### [Shape Stroke Color](#Shape-Stroke-Color)

Color of `polyline` and stroke color of `polygon` can be changed by using delegate method `strokeColorForShapeAnnotation`.

The default stroke color is the map view’s tint color.

#### Objective C

```objectivec
- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    return [UIColor redColor];
}
```

#### Swift

```swift
func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
  return .red
}
```

### [Shape Fill Color](#Shape-Fill-Color)

Fill Color of `polygon` can be changed by using delegate method `fillColorForPolygonAnnotation`.

The default fill color is the map view’s tint color. 

#### Objective C

```objectivec
- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation {
    return [UIColor redColor];
}
```

#### Swift

```swift
func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
  return UIColor.red
}
```

### [Shape Opacity](#Shape-Opacity)

To change opacity of a shape i.e polyline or polygon, delegate method `alphaForShapeAnnotation` can be used.

It sets the opacity of an entire shape, inclusive of its stroke and fill.

#### Objective C

```objectivec
- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation
{
  return 0.5;
}
```

#### Swift

```swift
func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
  return 0.5
}
```

### [Safety Status Strip](#Safety-Status-Strip)

A safety status strip can be show on map based on user's location. COVID-19 status will be shown on map currently, It will show whether user's location lies in a containment zone or not and conaintment zone info like Containment Zone Name, District etc. For more info about how to use go to [Safety Strip](https://github.com/mappls-api/mappls-ios-sdk/Mappls-Safety-Strip).

### [Cluster Based Authentication](#Cluster-Based-Authentication)

Map SDK can be configured such that it can work only for specified unique identifier of a device and will show an error accordingly.

#### [Set Cluster Device](#Set-Cluster-Device)

Cluster Identifier can be set and retrieve using singelton class `MapplsAccountManager` which is part of Map SDK's dependency `MapplsAPICore`.

Below is code for reference to set and get cluster identifier.

#### Objective C

```objectivec
// Set Cluster Identifier
[MapplsAccountManager setClusterId:@"YOUR_CLUSTER_DEVICE_IDENTIFIER"];

// Get Cluster Identifier
NSString * clusterId = [MapplsAccountManager clusterId];
```

#### Swift

```swift
// Set Cluster Identifier
MapplsAccountManager.setClusterId("YOUR_CLUSTER_DEVICE_IDENTIFIER")

// Get Cluster Identifier
let clusterId = MapplsAccountManager.clusterId()
```

## [SwiftUI](#SwiftUI)

### [Create Map View](#create-map-view)

1. In your project, add new SwiftUI View and name it MapView.swift
2. In order to use native UIKit views in `SwiftUI` view, you must use [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable) wrapper. The instance of custom type which adopts UIViewRepresentable protocol is responsible for creation and management a UIView object in your SwiftUI interface.
    ```
    struct MapView: UIViewRepresentable {
        ...
    }
    ```
3. The UIViewRepresentable requires to implement makeUIViewController(context:) method that creates the instance of with the desired UIKit view. Add the following code to create map view instance
    ```
    private let mapView: MapplsMapView = MapplsMapView(frame: .zero)

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MapplsMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    ```
4. The UIViewRepresentable view also requires to implement updateUIView(_:context:) which is used to configure the newly created instance. To show map only We dont need to configure anything so we will keep it empty.
    ```
    func updateUIView(_ uiView: MapplsMapView, context: UIViewRepresentableContext<MapView>) {}
    ```

To add map annoations at design time add an `annotations` property in `MapView` struct as below:

```
@Binding var annotations: [MGLPointAnnotation]
```

Use below code to add marker at design time by setting annotations property.
```
struct ContentView: View {
    
    @State var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "MAPPLS", coordinate: .init(latitude: 28.550679, longitude: 77.268949))
    ]
    
    var body: some View {
        MapView(annotations: $annotations).centerCoordinate(.init(latitude: 28.550679, longitude: 77.268949)).zoomLevel(16)
    }
}
```

### [Respond To Map Events](#Respond-To-Map-Events)

In order to to respond to map events, for example perform an action after MapView initialization finished. In SwiftUI, a Coordinator can be used with delegates, data sources, and user events. The UIViewRepresentable protocol defines makeCoordinator() method which creates coordinator instance. Add the following code to declare coordinator class:

```
class Coordinator: NSObject, MGLMapViewDelegate {
    var control: MapView

    init(_ control: MapView) {
        self.control = control
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // write your custom code which will be executed
        // after map's style has been loaded
    }
}
```

And then add the following method to the SwiftUI view:

```
func makeCoordinator() -> MapView.Coordinator {
    Coordinator(self)
}
```

And finally set the reference coordinator on Mappls map view.

```
mapView.delegate = context.coordinator
```

<br><br><br>

## Support

### Our many happy customers

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
