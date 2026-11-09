[<img src="https://about.mappls.com/images/mappls-b-logo.svg" height="80"/> </p>](https://www.mapmyindia.com/api)

# MapplsIntouch - Intouch SDK for iOS 

## [Introduction](#Introduction)

This SDK is collection of API wrappers of different APIs of Mappls Intouch platform for iOS Platform.

### [Dependencies](#Dependencies)

This library depends upon several Mappls's own libraries. All dependent libraries will be automatically installed using CocoaPods.

Below are list of dependencies which are required to run this SDK:

- [MapplsAPICore](https://github.com/mappls-api/mappls-ios-sdk/docs/v1.0.0/MapplsAPICore.md)

## [Installation](#Installation)

This library is available through `CocoaPods`. To install, simply add the following line to your `podfile`:

```ruby
pod 'MapplsIntouch', '1.0.2'
```
On running `pod install` command it will automatically download and setup `MapplsUIWidgets` and dependent frameworks.

### [Version History](#Version-History)

| Version | Dated | Description |
| :---- | :---- | :---- |
| `1.0.2` | 25 Feb 2025 | Bitcode disabled to support Xcode 16.|
| `1.0.1` | 24 Mar, 2023 | Bug fixes.|
| `1.0.0` | 30 Jan, 2023 | Initial Mappls UIWidget Release.|

## [Authorization](#Authorization)

### [MapplsAPICore](#MapplsAPICore)
It is required to set Mappls keys to use any Mappls SDK. Please refer the documentation [here](MapplsAPICore.md).

## [Device Details](#Device-Details)

Get accurate live location and related data of vehicles, assets & people with help of connected devices/sensors/mobiles to provide location awareness to users of your app. 

Below mentioned methods provide real-time visibility of your tracked objects, giving not just location information, but multiple additional fields which add value to your application. 

### 1) Get live device details by single or multiple IDs.

#### a) Get the list of all devices live data in your account.

### Objective-c
```objc
[Intouch.shared getDevicesWithIncludeInActive:true ignoreBeacon:true lastUpdateTime:@"" completionHandler:^(IntouchDeviceResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }            
}];
```

### Swift
```Swift
 Intouch.shared.getDevices(includeInActive: false, ignoreBeacon: false, lastUpdateTime: "0") { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.
    }
}
```

#### b)  Get the list of selected devices live data.

### Objective-C
```objc
[Intouch.shared getDevicesWithListOfDeviceIds:_deviceIdarr includeInActive:false ignoreBeacon:false lastUpdateTime:@"" completionHandler:^(IntouchDeviceResponse * _Nullable response, NSError * _Nullable error) {
    if(error)   {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```Swift
Intouch.shared.getDevices(listOfDeviceIds: devicesIds, includeInActive: false, ignoreBeacon: false, lastUpdateTime: "") { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }
}
```
#### c) Get a single device live data

### Objective-c
```objc
[Intouch.shared getDevicesWithDeviceId:123 lastUpdateTime:@"" completionHandler:^(IntouchDeviceResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];  
```

### Swift
```Swift
Intouch.shared.getDevices(deviceId: id, lastUpdateTime: "") { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }      
}
```

#### Request Parameters

1. ```deviceId```(Int)  - This is the device ID
2. ```includeInActive``` (Boolean)  -If "true" then API response will include inactive devices along with active devices. If "false" then API will return only active devices.
3. ```ignoreBeacon``` (Boolean) - If set to "true" then API will return all devices except those with device type as a beacon(mobile).
4. ```lastUpdateTime``` (Double) - Give EPOCH timestamp to fetch only those live locations of devices that have come after the given timestamp. If "lastUpdateTime" is given then by default only active devices will be fetched irrespective of the status of "includeInActive" attribute else set the value as 0.


### Response Code (as HTTP response code)

#### Success:

1.  200: To denote a successful API call.

#### Client-side issues:

1.  400: Bad Request, User made an error while creating a valid request.
2.  401: Unauthorized, the Developer’s key is not allowed to send a request with restricted parameters.
3.  403: Forbidden, the Developer’s key has hit its daily/hourly limit.

#### Server-Side Issues:

1.  500: Internal Server Error, the request caused an error in our systems.
2.  503: Service Unavailable, It comes during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200: Success
2. 203: Device Not Found
3. 400: Bad Request - Invalid device ID supplied or invalid data type. For example, the input attribute "id" is an integer but string value gets passed.
4. 401: Unauthorized Request. Access to API is forbidden.
5. 404: Not Found - URL Not Found

### Response Parameter
`DevicesResponse` class object returns the API response as a JSON object.  

 #### DeviceResponse result parameters:
 1. ```id (Int)``` - Id of the device.
 2. ```active (string) ```- Device active status 
 3. ```status (string)``` - Device movement status
 4. ```vehicleBattery (Double)``` - Device battery status
 5. ```location (Location)``` - Device live location object like latitude, longitude etc.
 6. ```deviceDetails(DeviceDetails)``` - Device info object like name etc.
 7. ```alerts (Alerts)``` - Alert object  
 8. ```canInfo (CanInfo)``` - Device CanInfo object.  
 9. ```deviceFaults (ArrayList<DeviceFault>)``` - List of various fault.
 10. ```currentGeofence (ArrayList<Long>)``` - list of current geofences id.
 11. ```todaysDrive (TodaysDrive)``` - TodaysDrive object.

##### Location parameters:
1. ```gpsTime (Long)``` - Time at which data is being fetched from the device 
2. ```gprsTime (Long)``` - Time at which data is being received at the server end.
3. ``` latitude (Double)``` - Device location latitude
4. ```longitude (Double)``` - Device location Longitude
5. ```altitude (Double)``` - Device location Altitude 
6. ```heading (Double)``` - Angle at which is the device is moving 
7. ```speedKph (Double)``` - Device or vehicle's GPS based speed.
8. ```address (String)``` - Complete address of the location.
9. ```odometer (Double)``` - Either GPS or CAN Odometer based on the configuration.

##### DeviceDetails parameters:
1. ```deviceId (Long)``` - Id of device.
2. ```registrationNumber (String)``` Device registration number.
3. ```deviceType (String)``` - Type of device like a car, truck, bus, bike, tractor, JCB, excavator, etc.

##### Alerts parameters:
1. ```deviceId (Long)``` - Id of device.
2. ```timestamp (Long)``` - EPOCH time at which alarm was generated
3. ```latitude (Double)```- Location latitude of alarm.
4. ```longitude (Double)``` - Location longitude of alarm. 
5. ```address (String)``` - Location address at which the alarm got generated
6. ```alarmType (Integer)``` - Type of alarm to create. The following are the alarm types & their corresponding IDs.  
IGNITION: 21, OVERSPEED: 22, UNPLUGGED: 23, PANIC: 24, GEOFENCE: 26, STOPPAGE: 27, IDLE: 28, TOWING: 29, GPRS CONNECTIVITY: 126, VEHICLE BATTERY: 129, MILEAGE: 133, GPS CONNECTIVITY: 146, DISTANCE COVERED: 151, INTERNAL BATTERY VOLTAGE:161
7. ```limit (Integer)```- Alarm limit as set in the config. For example, if an Overspeed alarm set on the limit of 44 km/hr in the alarm config setting, then this attribute will return 44 km/hr
8. ```duration (Long)``` - Alarm duration limit as set in the alarm config section. For example, if the duration of Overspeed alarm is set as 20 secs, then the alarm will generate when the vehicle over speeds for a duration of 20 secs
9. ```actualLimit (Integer)``` - The actual data received from the device at that particular moment when the alarm got generated. For example, when the over-speed alert generated the vehicle actual speed was 56km/hr.
10. ```actualDuration (Integer)``` - Actual duration for which the device breached the alarm config limit
11. ```severity (Integer)``` -   0:Low Severity. 1:High Severity
12. ```data (Integer)``` - Describes the state of the alarm. IGNITION(type = 21), 0: OFF & 1: ON. AC(type=25), 0: OFF, 1: ON. GEOFENCE(type=26), 1: Entry & Exit Geofence 2: Entry Geofence, 3: Leaving Geofence & 4: Long Stay In Geofence
13. ```geofenceId (Long)``` - Unique ID of the geofence for which the alarm got generated.

##### CanInfo parameters:
1. ```calcEngineVal (Integer) ```- Calculated Engine value.
2. ```greenDriveType (String)``` - HA(Harsh acceleration), HB(Harsh Braking), HC(Harsh Cornering).
3. ```canTimestamp (Long)``` - Exact EPOCH time at which the CAN data got generated by the device.
4. ```coolantTemp (Integer)``` - Coolant temperature.
5. ```engineRPM (Integer)``` - Rpm value of engine.
6. ```accelPedal (Double)``` - This is accelerator pedal value in percentage.
7. ```pedoMeter (Integer)``` - Pedometer value in steps.
8. ```parkBrake (Double)``` - This is the parking brake. 0 means parking brake is disengaged & 1 means parking brake is engaged.
9. ```brakePedal (Double)``` - 1 means brake pedal is engaged & 0 means brake pedal is disengaged.
10. ```fuelLevel (Integer)``` - The level of the fuel in liters.
11. ```driverDoor (Double)``` - 1 means door is open & 0 means door is closed.
12. ```passDoor (Double)``` - 1 means door is open & 0 means door is closed.
13. ```headLights (Double)``` - 1 means ON & 0 means OFF.
14. ```blinker (Double)``` - 1 means ON & 0 means OFF.
15. ```ac (Integer)``` - 1 means AC is ON & 0 means AC is OFF.
16. ```fuelConsAVG (Integer)``` - Fuel constant average.
17. ```intakeAirTemp (Double)``` - Intake air temperature of the engine.
18. ```intakeabsolutePress (Integer)``` - Intake absolute pressure of the engine. It is defined in Pa(Pascal)

##### DeviceFault parameters:
1. ```code (String)``` - Fault code.
2. ```timestamp (Long)``` - Duration as EPOCH Time.
3. ```status (Integer)``` - Describes the status of the fault which was detected. 0: OPEN & 1: Close.
4. ```closedOn (Long)```- The EPOCH time at which fault code closed. This will come for the closed case.

##### TodaysDrive parameters:
1. ```todayKms (Double)``` - Distance in Km(s).
2. ```todayMovementTime (Long)``` - Movement time in sec(s).
3. ```todayIdleTime (Long)``` - Idle time in sec(s).
4. ```todayDriveCount (Long)``` - Drive count for today.

### 2) Get Device info

Below method returns the basic info of devices such as their registration number, type of entity, manufacturer etc.

#### a) Get all devices info

### Objective-c
```objc
[Intouch.shared getDevicesInfoWithCompletionHandler:^(IntouchDeviceInfoResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getDevicesInfo { (deviceinfoResponse, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = deviceinfoResponse {
        // write your code here.  
    }
}
```

#### b) Get the selected device info

### Objective-c
```objc
    NSArray*deviceIdarr = [[NSArray alloc]initWithObjects:@"8440",@"8440",@"8404", nil];
  [Intouch.shared getDevicesInfoWithDeviceIds:<array of deviceid> completionHandler:^(IntouchDeviceInfoResponse * _Nullable response, NSError * _Nullable error) {
        if(error)
             {
         // reason gives the error type. 
        // errorIdentifier gives information about error code. 
       // errorDescription gives a message for a particular error.  
             }
             else{
                // write your code here.  
             }
            }];
```

### Swift
```swift
Intouch.shared.getDevicesInfo(deviceIds: [array of deviceIds]) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }                      
}
```
### Request Parameters

1. ```id```(Long)  - This is the device ID. You may pass single or multiple ids in an array.


### Response Code (as HTTP response code)

#### Success:

1.  200: To denote a successful API call.

#### Client-side issues:

1.  400: Bad Request, User made an error while creating a valid request.
2.  401: Unauthorized, the Developer’s key is not allowed to send a request with restricted parameters.
3.  403: Forbidden, the Developer’s key has hit its daily/hourly limit.

#### Server-Side Issues:

1.  500: Internal Server Error, the request caused an error in our systems.
2.  503: Service Unavailable, It comes during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200: Success
2. 203: Device Not Found
3. 400: Bad Request - Invalid device ID supplied or invalid data type. For example, the input attribute "id" is an integer but string value gets passed.
4. 401: Unauthorized Request. Access to API is forbidden.
5. 404: Not Found - URL Not Found

### Response Parameter
`DeviceInfoResponse` class object returns the API response as a JSON object.  

 #### DeviceInfo result parameters:
 1. ```id (Integer)``` - Id of the device.
 2. ```name(string) ```- Name of the device.
 3. ```type(Integer)``` - Type of entity like 0 - car, 1 - person, 2 - asset, 3 - bike, 4 - bus, 5 - truck, 6 - tractor.
 4. ```creationOn(long)``` - Date when the device was created.
 5. ```updationOn(long)``` - Date when device info got updated.
 6. ```expiryDate(long)``` - Date when device validity subscription will get expired.
 7. ```active(Boolean)``` - Whether device is active or not.
 8. ```registrationNumber(String)``` - Device's registration number.
 9. ```manufacturer(String)``` - Device manufactured by.
 10. ```model(String)``` - Device's model type.
 11. ```color(String)``` - Color of the device.
 12. ```geofenceIds(List<Integer>)``` - IDs of the geofences associated with the device.
 13. ```tag(List<String>)``` - Tag of the vehicle with the custom string value
 14. ```chasisNo``` - Chassis number of the device.
 15. ```initialOdometer``` - Initial odometer reading.

### [Event Data](#Event-Data)

Get the Trails (Travelled path) of a device in your account using the below methods. 

### Objective-c
```objc
[Intouch.shared getLocationsEventWithDeviceId:0 startTime:0 endTime:0 skipPeriod:1 completionHandler:^(DeviceEventResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];            
```

### Swift
```swift
Intouch.shared.getLocationsEvent(deviceId: 0, startTime: 0, endTime: 0, skipPeriod: 0) { (response, error) in  
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.
    }
}
```

### Request Parameters
1. ```deviceId ```(Long)  Id of the device for which the location data need to be fetched.
2. ```startTime ```(Long) Start Epoch timestamp from which the events need to be fetched.
3. ```endTime ```(Long) End Epoch timestamp till which the events need to be fetched.
4. ```skipPeriod```(int) Defined in minutes. For example, if 2 is passed then the returned data packet will have a minimum difference of 2 mins else 0.

### Response Code
#### Success:
1.  200: To denote a successful API call.

#### Client-side issues:

1.  400: Bad Request, User made an error while creating a valid request.
2.  401: Unauthorized, the Developer’s key is not allowed to send a request with restricted parameters.
3.  403: Forbidden, the Developer’s key has hit its daily/hourly limit.

#### Server-Side Issues:

1.  500: Internal Server Error, the request caused an error in our systems.
2.  503: Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200: Success
2. 203: Device Not Found
3. 400: Bad Request - Invalid device ID supplied or invalid data type. For example, the input attribute "id" is an integer but string value gets passed.
4. 401: Unauthorized Request. Access to API is forbidden.
5. 404: Not Found - URL Not Found

### Response Parameter
`LocationEventResponse` class object returns the API response as a JSON object.  

#### LocationEventResponse result parameters:
1. ```deviceId (Long)``` -  Device id of selected device.
2. ```drivingBehaviourCount (DrivingBehaviourCount)``` - Driving behavior count in the selected device.  
3. ```summary (Summary)``` - Brief summary of all locations.
4. ```positionList (List<PositionList>)``` - List of location positions.

#### Summary parameters:
1. ```distance (Double)``` - Total drive distance in KM(s).
2. ```duration (Long)``` - Total drive duration in seconds.
3. ```avgSpeed (Double)``` - Average speed in km/hr.
4. ```startAddress (String)``` - Start address of the location.
5. ```endAddress (String)``` - End address of the location.
6. ```startTimestamp (Long)``` - Start Epoch time of the event. i,e) the time at which the data first came from the device for the selected day
7. ```endTimestamp (Long)``` - End Epoch time of the event. i,e) the time at which the last data came from the device for the selected day.

#### DrivingBehaviourCount parameters:
1. ```haCount (Integer)``` - Harsh acceleration count.
2. ```hbCount (Integer)``` - Harsh braking count.
3. ```hcCount (Integer)``` - Harsh cornering count.

#### PositionList parameters:
1. ```address (String)``` - Address of particular location.
2. ```timestamp (Long)``` - Epoch Time at a particular location.
3. ```longitude (Double)``` - Location longitude.
4. ```latitude (Double)``` - Location latitude.
5. ```heading (Double)``` - Device heading direction in degrees from North.
6. ```speed (Double)``` - Device speed at this particular location.
7. ```powerSupplyVoltage (Double)``` - Battery voltage value in millivolts.
8. ```ignition (Boolean)``` - Whether vehicle ignition is On or Off. 0 means ignition is OFF and 1 means ignition is ON.
9. ```gpsFix (Boolean)``` - GPS fixes or not for the device. true means GPS is fixed and false means GPS is not fixed.
10. ```validGPS (Boolean)``` - Checks whether GPS is valid or not.
11. ```accOff (Boolean)``` - Checks for whether adaptive cruise control is enabled or not.
12. ```movementStatus (String)``` - Checks the movement status of the device. 1:Moving, 2:Idle, 3:Stopped, 4:Towing, 5:No Data 6:Power Off, 7:No Gps, 8:On Trip, 9:Free Vehicle
13. ```mobileInfos (MobileInfo)``` - MobileInfo object

#### MobileInfo parameters:
1. ```locationSource (Integer)``` -  Returns location source i.e 1 - GPS connected,  2 - GPRS connected.
2. ```mockLocation (Boolean)``` - If true means mock location is enabled else false means real GPS location being sent by the user.
3. ```isAirplanemode (Boolean)``` - Checks whether mobile's airplane mode is ON or OFF.
4. ```callStatus (Integer)``` - Current call status like 0:CALL_STATE_IDLE, 1:CALL_STATE_RINGING, 2:CALL_STATE_ONCALL
6. ```deviceStatus (Integer)``` - Status of the device in the current location. 0: IN_VEHICLE, 1: ON_BICYCLE, 2: ON_FOOT, 
   3:STILL, 4:UNKNOWN, 5:TILTING, 6:WALKING, 7:RUNNING.
7. ```phoneEvent (Integer)``` - Checks the location permission that the user enables/disables in the mobile phone. For eg:- 5 for location permission denied. 6 for location provider off etc.

### [Drive Data](#Drive-Data)

Get the drive details of a vehicle/user in an InTouch account using the below method. A drive is a list of reported geo-positions with the start and end location of a vehicle according to pre-defined conditions. Time duration, distance covered during the drive, HA, HB, HC events are also returned along with the drive details.

### Objective-c
```objc
// IntouchDriveResponse - returns drives as response if success else returns error.
[Intouch.shared getDriveDataWithDeviceId:0 startTime:0 endTime:0 completionHandler:^(IntouchDriveResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
// IntouchDriveResponse - returns drives as response if success else returns error.
Intouch.shared.getDriveData(deviceId: 0, startTime: 0, endTime: 0) { (DriveDataResponse, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.
    }
}
```

### Request Parameters

1. ```deviceId```(Int)- Id of the device for which the drives need to be fetched.

2. ```startTime```(Long)- The start Epoch timestamp from which the drives need to be fetched.

3. ```endTime ```(Long)-  The end Epoch timestamp till which the drives need to be fetched.

### Response Code
#### Success:
1.  200: To denote a successful API call.

#### Client-side issues:

1.  400: Bad Request, User made an error while creating a valid request.
2.  401: Unauthorized, the developer’s key is not allowed to send a request with restricted parameters.
3.  403: Forbidden, the developer’s key has hit its daily/hourly limit.

#### Server-Side Issues:

1.  500: Internal Server Error, the request caused an error in our systems.
2.  503: Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200: Success
2. 203: Device Not Found
3. 400: Bad Request - Invalid device ID supplied or invalid data type. For example, the input attribute "id" is an integer but string value gets passed.
4. 401: Unauthorized Request. Access to API is forbidden.
5. 404: Not Found - URL Not Found


### Response Parameter
`DriveResponse` Class object returns the API response as a JSON object.  

#### DriveResponse result parameters:
1. ```deviceId (Int)``` -  Device id of selected device.
2. ```drivingBehaviourCount (DrivingBehaviourCount)``` - Driving behavior count in the selected drive.  
3. ```movement(Movement)``` - Movement info object.
4. ```location (Location)``` - Location info object.

#### Movement parameters:
1. ```duration (Long)``` - Drive duration in seconds.
2. ```distance (Long)``` - The driving distance in KMs.
3. ```idleTime (Long)``` -Idle time in seconds.
4. ```movementTime (Long)``` - Movement time in seconds.
5. ```stoppageTime (Long)``` - Stoppage time in seconds.

#### DrivingBehaviourCount parameters:
1. ```haCount (Integer)``` - Harsh acceleration count.
2. ```hbCount (Integer)``` - Harsh braking count.
3. ```hcCount (Integer)``` - Harsh cornering count.

#### PositionList parameters:
1. ```startAddress(String)``` - Start address of particular drive.
2. ```startTimestamp(Long)``` - Start Epoch time of particular drive.
3. ```endAddress(String)``` - End address of particular drive.
4. ```endTimestamp(Long)``` - Start Epoch time of particular drive.
5. ```avgSpeed(Double)``` - Speed in km/hr.

## [Geofences](#Geofences)

A geofence is a user-defined bounded area to trigger Entry and Exit alert of the user/vehicle. Custom areas or places can be created as a Geofence under your account, For example, it could be a hotel, Restaurant, Office, work area, retail store, and so on. 

MapmyIndia InTouch SDK supports Point, Circle, and Polygon (Custom Region/Area) geofences. You can Create, Update, or Delete geofences using the below methods. Also, get the total time spent inside the geofence using the below methods.

### a) Create Geofence

The create geofence method helps you to create a geofence under your account. Three types of geofence can be created: Point, Circle, Polygon.

#### Point Geofence

Input the Lat, long, and the name of the geofence to create the point geofence. A point geofence has a fixed radius of 100 meters, so the user need not put the radius of the geofence. To customize the radius of geofence refers to the circle geofence method.

### objective-c
```objc
// Point type geofence
//IntouchGeometryPoint - it accepts point coordinate.
//IntouchPointGeofence - it accepts geometry coordinate and name.
//IntouchGeofenceOptions - class it accepts object of geofence 

CLLocation*referenceLocation = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];
IntouchGeometryPoint*point = [[IntouchGeometryPoint alloc]initWithPoint:referenceLocation];    IntouchPointGeofence*point1 = [[IntouchPointGeofence alloc]initWithName:@"test" geometry:point];
self.geofenceOptions = [[IntouchGeofenceOptions alloc]initWithGeofence:point1];
   [Intouch.shared createGeoFenceWithGeofence:_geofenceOptions completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.
    }
}];
```

### Swift
```swift
let geometry = IntouchGeometryPoint(point: CLLocation(latitude: 23.343, longitude: 77.232))
                let geofence2 = IntouchPointGeofence(name: "Test", geometry: geometry)
                let geofenceoption = IntouchGeofenceOptions(geofence: geofence2)
                Intouch.shared.createGeoFence(geofence: geofenceoption) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = status {
        // write your code here.
    }
}
```

#### Circle Geofence

Create a circle geofence with a radius of your choice. Input Lat, long, Radius, and name of the geofence to create the circle geofence.

### objective-c
```objc 
// Circle type geofence, the radius will be in meters.
// Status - returns success if geofence created else error as callback methods.
// IntouchPointGeofence - it will accepts geometry, name and circle radius.

NSNumber *myDoubleNumber = [NSNumber numberWithDouble:500];
    IntouchPointGeofence*withBuffer = [[IntouchPointGeofence alloc]initWithName:@"Test" buffer:myDoubleNumber geometry:point];

IntouchGeofenceOptions*geofenceOptionsWithRadius = [[IntouchGeofenceOptions alloc]initWithGeofence:withBuffer];
    
[Intouch.shared createGeoFenceWithGeofence:_geofenceOptionsWithRadius completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
 ```

### Swift
```swift 
let geometry = IntouchGeometryPoint(point: CLLocation(latitude: 23.343, longitude: 77.232))
                let geofence2 = IntouchPointGeofence(name: "Test", buffer: 500, geometry:
                    geometry)

let geofenceoption = IntouchGeofenceOptions(geofence: geofence2)

Intouch.shared.createGeoFence(geofence: geofenceoption) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = status {
        // write your code here.
    }
}
 ```

 #### Polygon Geofence

To draw a polygon geofence we need at least three points. Multiple points can be added to create the custom shape Geofence. Input a list of geofence points (Lat, long) in the comma-separated format.

### objective-c
```objc
// Polygon Geofence
// IntouchGeometryPolygon- class accepts multiple coordinates.
// IntouchPolygonGeofence- it accepts geofenceName and geometry.
//IntouchGeofenceOptions - it accepts created geometry object.

CLLocation* referenceLocation1 = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];
    CLLocation* referenceLocation2 = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];
    CLLocation* referenceLocation3 = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];
    CLLocation* referenceLocation4 = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];

NSMutableArray*arr = [[NSMutableArray alloc]initWithObjects:referenceLocation1,referenceLocation2,referenceLocation3,referenceLocation4, nil];
    
IntouchGeometryPolygon* geometryPolygon = [[IntouchGeometryPolygon alloc]initWithPoints:arr];

IntouchPolygonGeofence* geofencePolygon = [[IntouchPolygonGeofence alloc]initWithName:@"Test" geometry:geometryPolygon];

IntouchGeofenceOptions*polygonGeofence = [[IntouchGeofenceOptions alloc]initWithGeofence:geofencePolygon];

[Intouch.shared createGeoFenceWithGeofence:_polygonGeofence completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```
### Swift
```swift
 let coordinates = [
                    CLLocation(latitude: 28.550704, longitude: 77.268961),
                    CLLocation(latitude: 28.549415, longitude: 77.271757),
                    CLLocation(latitude: 28.54711, longitude: 77.263637),
                    CLLocation(latitude: 28.550704, longitude: 77.268961)
                ]

let geometry1 = IntouchGeometryPolygon(points: coordinates)

let geofence1 = IntouchPolygonGeofence(name: "test5", geometry: geometry1)

let geofenceoption1 = IntouchGeofenceOptions(geofence: geofence1)

Intouch.shared.createGeoFence(geofence: geofenceoption1) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = status {
        // write your code here.
    }
}
```

### Request Parameters
1.```geoFenceName(String)```- Name of the geofence.

2.```IntouchGeometryPolygon(Points)```- Geofence point(s). List of "GeoFencePoint" for polygon else single object required. 

3.```3 IntouchPointGeofence(Points)```- Geofence point(s). single object required.

### Response Code
#### Success:
1.  201: To denote a successful record is being created.

#### Client-side issues:

1.  400: Bad Request, User made an error while creating a valid request.
2.  401: Unauthorized, the Developer’s key is not allowed to send a request with restricted parameters.
3.  403: Forbidden, the Developer’s key has hit its daily/hourly limit.

#### Server-Side Issues:

1.  500: Internal Server Error, the request caused an error in our systems.
2.  503: Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200: Success
2. 203: Device Not Found
3. 400: Bad Request - Invalid device ID supplied or invalid data type. For example, the input attribute "id" is an integer but string value gets passed.
4. 401: Unauthorized Request. Access to API is forbidden.
5. 404: Not Found - URL Not Found

### Response Parameter
`CreateGeoFenceResponse` class object returns the API response as a JSON object.  

 #### CreateGeoFenceResponse result parameters:
  ```id (Int)```- Id of the newly created geofence.
  
#### Get Geofence(s)

InTouch Get Geofences methods can be used to request the list of geofence areas using the unique geofence IDs which is being assigned by InTouch.

#### Get All Geofence(s) with geometry
Get all the geofences created under your account using the below method. It returns the name and unique Id of the geofence.
Get the geofence response with shape by setting ignore geometry value as false. for example, the type will be either a point, polygon, or circle.
### objective-c
```objc
// ignoreGeometry is a boolean value. If the user doesn't need geometry with geofence pass true else false. 
// IntouchGetGeofencesResponse- returns all geoFences with geometry in response if success else errors as callback methods.
[Intouch.shared getAllGeoFencesWithIgnoreGeometry:NO completionHandler:^(IntouchGetGeofencesResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getAllGeoFences(ignoreGeometry: false) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.
    }
}
```

#### Get single Geofence

Input Geofence Id to get a single geofence detail in the get method.

### objective-c
```objc
// Get single geofence
// IntouchGetGeofencesResponse- returns single geoFence in response if success else error as callback methods.
[Intouch.shared getAllGeoFencesWithGeofenceID:0 ignoreGeometry:NO completionHandler:^(IntouchGetGeofencesResponse * _Nullable response, NSError * _Nullable error) {
    if(error) { 
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getAllGeoFences(geofenceID: 0, ignoreGeometry: false) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }
}
```

#### Get multiple Geofence with geometry Value.

Get multiple geofences for an array of geofence Ids with ignoreGeometry parameter value set as false.

### Objective-c
```objc
// Get multiple geofences with geometry value
// IntouchGetGeofencesResponse- returns multiple geoFences in response if success else error as callback methods.
NSMutableArray*geofenceIds = [[NSMutableArray alloc]initWithObjects:@12,@12,@23, nil];

[Intouch.shared getAllGeoFencesWithGeofenceIds:_geofenceIds ignoreGeometry:NO completionHandler:^(IntouchGetGeofencesResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getAllGeoFences(geofenceIds: [], ignoreGeometry: false) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }
}
```

### Request Parameters
1.```id(Int)```- Geofence id. Use this if you want to get details of specific multiple geofence IDs.

2.```ignoreGeometry(boolean)``` - Non-mandatory field, boolean value to fetch geometry details.

### Response Code

#### Success:
1.  200: To denote a successful API call.

#### Client-side issues:

1.  400: Bad Request, User made an error while creating a valid request.
2.  401: Unauthorized, the Developer’s key is not allowed to send a request with restricted parameters.
3.  403: Forbidden, the Developer’s key has hit its daily/hourly limit.

#### Server-Side Issues:

1.  500: Internal Server Error, the request caused an error in our systems.
2.  503: Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200: Success
2. 203: Device Not Found
3. 400: Bad Request - Invalid device ID supplied or invalid data type. For example, the input attribute "id" is an integer but string value gets passed.
4. 401: Unauthorized Request. Access to API is forbidden.
5. 404: Not Found - URL Not Found

### Response Parameter
`CreateGeoFenceResponse`- Class object returns the API response as a JSON object.  

#### InTouchGeoFenceResponse result parameters:
  ```- List<GeoFenceResult>```- List of GeoFenceResult.

##### GeoFenceResult Parameters:
  1. ```id(Int)```- Geofence ID
  2. ```name(String)```- Name of the geofence
  3. ```geometry(Geometry)```- Geofence Geometry object.
  4. ```type(String)```- Depending on the type of geofence this value can be Circle(buffer > 50 meters), Polygon or Point(buffer = 50 mtrs)
  5. ```buffer(Double)```- Radius(in meters) of a circular geofence
  6. ```creationTime(long)```- Epoch Timestamp at which the geofence was created.
  7. ```updationTime(Long)```- Epoch Timestamp at which the geofence was updated.
  
  ##### Geometry Parameters:
  1. ```type(String)```-This defines the type of geofence, it can be point or polygon.
  2. ```coordinates(Object)```- Geofence geometry coordinates.
  3. ```latLng(GeoFencePoint)```- GeoFencePoint object. Use this in case of geofence type "Point or Circle".
  4. ```points(List<List<GeoFencePoint>>)```- List of GeoFencePoint list. Use this in case of geofence type "Polygon".
  
#### Update Geofence(s)

Use Geofence ID to update Geofence name, latitude, longitude, and radius in below method 

#### Update point Geofence

Update geofence values like geofence name and lat, long using below method

### objective-c
```objc
// update single geofence 
// status - returns success if gefence updated successfully, else error as callback methods.

CLLocation *referenceLocation = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];

IntouchGeometryPoint *point = [[IntouchGeometryPoint alloc]initWithPoint:referenceLocation];

IntouchPointGeofence *point1 = [[IntouchPointGeofence alloc]initWithName:@"test" geometry:point];

IntouchGeofenceOptions *geofenceOptions = [[IntouchGeofenceOptions alloc]initWithGeofence:point1];

[Intouch.shared updateGeoFencesWithGeofenceaID:597386 geofence:_geofenceOptions completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
let geometry = IntouchGeometryPoint(point: CLLocation(latitude: 23.343, longitude: 77.232))

let geofence2 = IntouchPointGeofence(name: "Test", geometry: geometry)

let geofenceoption = IntouchGeofenceOptions(geofence: geofence2)

Intouch.shared.updateGeoFences(geofenceaID: 597386, geofence: geofenceoption) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }
}
```

#### Update circle Geofence

Update geofence name, latitude, longitude, and Radius for a circle geofence using the below method.

### objective-c
```objc
// update single geofence with buffer value. Buffer is like a radius in meters.
NSNumber *myDoubleNumber = [NSNumber numberWithDouble:500];

IntouchPointGeofence*withBuffer = [[IntouchPointGeofence alloc]initWithName:@"Test" buffer:myDoubleNumber geometry:point];

IntouchGeofenceOptions*geofenceOptionsWithRadius = [[IntouchGeofenceOptions alloc]initWithGeofence:withBuffer];
    
[Intouch.shared updateGeoFencesWithGeofenceaID:597386 geofence:_geofenceOptionsWithRadius completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
let geometry = IntouchGeometryPoint(point: CLLocation(latitude: 23.343, longitude: 77.232))

let geofence2 = IntouchPointGeofence(name: "Test", buffer: 500, geometry: geometry)

let geofenceoption = IntouchGeofenceOptions(geofence: geofence2)

Intouch.shared.updateGeoFences(geofenceaID: 597386, geofence: geofenceoption) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }
}
```

#### Update Polygon Geofence

Update the geofence name, and the latitude, longitude of the polygon geofence using the below method.

### objective-c
```objc
// Update polygon geofence.
CLLocation* referenceLocation1 = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];

CLLocation* referenceLocation2 = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];

CLLocation* referenceLocation3 = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];

CLLocation* referenceLocation4 = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];

NSMutableArray*arr = [[NSMutableArray alloc]initWithObjects:referenceLocation1,referenceLocation2,referenceLocation3,referenceLocation4, nil];
    
IntouchGeometryPolygon* geometryPolygon = [[IntouchGeometryPolygon alloc]initWithPoints:arr];

IntouchPolygonGeofence* geofencePolygon = [[IntouchPolygonGeofence alloc]initWithName:@"Test" geometry:geometryPolygon];

IntouchGeofenceOptions*polygonGeofence = [[IntouchGeofenceOptions alloc]initWithGeofence:geofencePolygon];

[Intouch.shared updateGeoFencesWithGeofenceaID:597386 geofence:_polygonGeofence completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
let coordinates = [
                    CLLocation(latitude: 28.550704, longitude: 77.268961),
                    CLLocation(latitude: 28.549415, longitude: 77.271757),
                    CLLocation(latitude: 28.54711, longitude: 77.263637),
                    CLLocation(latitude: 28.550704, longitude: 77.268961)
                ]

let geometry = IntouchGeometryPolygon(points: coordinates)

let geofence2 = IntouchPolygonGeofence(name: "Test1", geometry: geometry)

let geofenceoption = IntouchGeofenceOptions(geofence: geofence2)

Intouch.shared.updateGeoFences(geofenceaID: 577059, geofence: geofenceoption) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = status {
        // write your code here.  
    }
}
```

### Request Parameters
1. ```geoFenceId(Int)```- Id of the existing geofence.
2. ```geoFenceName(String)```- Name of the geofence. If you need to update the existing one then use this else pass null.
3. ```geoFencePoint(GeoFencePoint)``` -List of "GeoFencePoint" for polygon geofence else single object required. 
3. ```IntouchGeometryPolygon()``` -List of "GeoFencePoint" for polygon geofence.
### Response Code
#### Success:
1.  200: To denote a successful API call.

#### Client-side issues:

1.  400: Bad Request, User made an error while creating a valid request.
2.  401: Unauthorized, the Developer’s key is not allowed to send a request with restricted parameters.
3.  403: Forbidden, the Developer’s key has hit its daily/hourly limit.

#### Server-Side Issues:

1.  500: Internal Server Error, the request caused an error in our systems.
2.  503: Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200: Success
2. 203: Device Not Found
3. 400: Bad Request - Invalid device ID supplied or invalid data type. For example, the input attribute "id" is an integer but string value gets passed.
4. 401: Unauthorized Request. Access to API is forbidden.
5. 404: Not Found - URL Not Found

### Response Parameter
`UpdateGeoFenceResponse`- Class object returns the API response as a JSON object.  

 #### UpdateGeoFenceResponse parameters:
 ```message<String>```- Describes the type of error based on the type of response code.


#### Delete Geofence

Delete Geofences by mentioning the geofence IDs in the following methods

#### Delete single Geofence

Use the below method to delete a particular geofence by mentioning the geofence ID.
### Objective-c
```objc
// Delete single geofence
// status- returns success if gefence deleted successfully, else error as callback methods.
[Intouch.shared deleteGeofenceWithGeofenceaID:23 completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.deleteGeofence(geofenceaID: 23) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = status {
        // write your code here.  
    }
}
```

#### Delete multiple Geofence

Use the below method to delete a list of geofence Ids at once.

### Objective-c
```objc
// Delete multiple geofences
NSMutableArray*geofenceIds = [[NSMutableArray alloc]initWithObjects:@12,@12,@23, nil];

[Intouch.shared deleteGeofenceWithGeofenceIds:_geofenceIds completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.deleteGeofence(geofenceIds: []) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = status {
        // write your code here.  
    }
}
```

 ### Request Parameters
1. ```geoFenceId(Int)```- Id or array of Ids of existing geofence(s).  

### Response Code
#### Success:
1.  200: To denote a successful API call.

#### Client-side issues:

1.  400: Bad Request, User made an error while creating a valid request.
2.  401: Unauthorized, the Developer’s key is not allowed to send a request with restricted parameters.
3.  403: Forbidden, the Developer’s key has hit its daily/hourly limit.

#### Server-Side Issues:

1.  500: Internal Server Error, the request caused an error in our systems.
2.  503: Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200: Success
2. 203: Device Not Found
3. 400: Bad Request - Invalid device ID supplied or invalid data type. For example, the input attribute "id" is an integer but string value gets passed.
4. 401: Unauthorized Request. Access to API is forbidden.
5. 404: Not Found - URL Not Found

#### 4.5  Get Geofence Activity
The below method helps to fetch the details of all the geofence activities, such as geofence entry time, exit time, etc, and total time spent inside the geofence, which devices perform w.r.t various geofences across a defined date/time range.

#### 4.5.1  Get Geofence Activity for selected devices
### objective-c
```objc
// IntouchGeofenceActivityResponse-returns activity list , else error as callback methods.
[Intouch.shared getGeoFenceActivityWithDevicesIds:_geofenceIds startTime:123.3 endTime:1232.3 completionHandler:^(IntouchGeofenceActivityResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getGeoFenceActivity(devicesIds: [], startTime: 0, endTime: 0) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = status {
        // write your code here.  
    }
}
```

#### Get Geofence Activity for selected devices and geofence(s)

### objective-c
```objc
//IntouchGeofenceActivityResponse- return selected activity  data otherwise returns error.
NSMutableArray*geofenceIds = [[NSMutableArray alloc]initWithObjects:@12,@12,@23, nil];

NSArray*deviceId = @[@1, @2, @3, @4, @5, @6];

[Intouch.shared getGeoFenceActivityWithGeofenceIds:_geofenceIds devicesIds:deviceIds startTime:12.33 endTime:12.22 completionHandler:^(IntouchGeofenceActivityResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getGeoFenceActivity(geofenceIds: [], devicesIds: [], startTime: 0, endTime: 0) { (resonse, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = resonse {
        // write your code here.  
    }
}
```

### Request Parameters
1. ```deviceId(Int[])``` -  Int array of the device(s) Id(s) for which you want to fetch the geofence activities. 
2. ``` geofenceId(Int[])``` - Int array of the geofence(s) Id(s) for which you want to fetch the geofence activities done by the device. 
3. ```startTime(long)``` - Value in timestamp. Start time from where you want to fetch the geofence activities
4. ```endTime(long)```- Value in timestamp. End time till where you want to fetch the geofence activities

### Response Code
#### Success:
1.  200: To denote a successful API call.

#### Client-side issues:

1.  400: Bad Request, User made an error while creating a valid request.
2.  401: Unauthorized, the Developer’s key is not allowed to send a request with restricted parameters.
3.  403: Forbidden, the Developer’s key has hit its daily/hourly limit.

#### Server-Side Issues:

1.  500: Internal Server Error, the request caused an error in our systems.
2.  503: Service Unavailable, during our maintenance break or server downtimes.
### Response Parameter
`GeoFenceActivityResponse`- Class object returns the API response as a JSON object.  

#### InTouchGeoFenceResponse result parameters:
  ```- List<GeoFenceActivity>```- List of GeoFenceActivity.

##### GeoFenceResult Parameters:
1. ```entryLongitude(Double)```- Longitude where the particular device entered the geofence.
2. ```entryLatitude(Double)```- Latitude where the particular device entered the geofence.
3. ```exitLongitude(Double)```- Longitude where the particular device exited the geofence.
4. ```exitLatitude(Double)```- Latitude where the particular device exited the geofence.
5. ```entryTimestamp(Integer)```- Time at which the device entered the particular geofence.
6. ```exitTimestamp(Integer)```- Time at which the device exited the particular geofence.
7. ```geofenceName(String)```- Name of the geofence.
8. ```geofenceId(Integer)``` - Id of the geofence where the activity took place.
9. ```deviceId(Integer)``` - Id of the device which is performing the activities w.r.t the geofence. 

## 5) Alarms
Users can get an alert whenever a particular event occurs by configuring alarm to your vehicle or user. For example, an alert can be sent to the user whenever user or vehicle Enters/Exits the particular area or if the vehicle or user is Over Speeding or vehicle battery is low, etc. etc. These alerts are highly configurable based on different requirements.

####  5.1) Configure Alarms

Some of the important and more frequently used alarms for different use cases are listed below.
 - Geofence 
 - Ignition 
 - OverSpeed
 - UnPlugged
 - Panic
 - Stoppage
 - Idle
 - Towing
 - GPRS Connectivity
 - Vehicle Battery
 - Mileage
 - GPS connectivity
 - Distance Covered
 - Internal Battery Voltage

#### 5.1.1)  Geofence Alarm

Configure geofence alarm by assigning the vehicle to a particular Geofence to get an alert when the user or vehicle enters/ exits the particular area. Geofence should be created before assigning the vehicle to geofence in alarms configuration.  Refer to Create Geofence documentation to create Geofence. Get the Geofence method will fetch Geofence Ids.


##### Mandatory parameters:
- Alarm Type, id(s) of device(s), Id(s) of geofence(s)and Type of geofence 

##### 5.1.2) Ignition Alarm 

Configure Ignition alarm to trigger an alert when the vehicle ignition is switched On or Off. Assign vehicles against this alarm.

##### Mandatory Parameters
- Alarm Type, Id(s) of the device(s) and type of Ignition


##### 5.1.3) Overspeed Alarm

Configure the Overspeed alarm to trigger an alert when the user or vehicle crosses the configured speed limit.

##### Mandatory parameters:
- Alarm Type, Id(s) of the device(s), Limit and Duration

##### 5.1.4)  Unplugged Alarm

Configure an unplugged alarm to trigger an alert when a vehicle tracking device is removed from the vehicle battery 

##### Mandatory parameters:
- Alarm Type and Id(s) of the device(s) 

##### 5.1.5) Panic Alarm

Configure Panic alert using the below method. Assign this alert to the device to trigger an alert whenever the user presses the panic button.

##### Mandatory parameters:
- Alarm Type and Id(s) of the device(s)

##### 5.1.6) Stoppage Alarm

Configure Stoppage alarm to alert you when the user or vehicle continuously stays in the stopped condition for more than the defined duration.

##### Mandatory parameters:
- Alarm Type, Id(s) of device(s) and Duration

##### 5.1.7) Idle Alarm

Configure Idle alarm to alert you when the vehicle continuously stays in the Idle condition (Engine is on but the speed is less than 7 km/hr) for more than the defined duration.


##### Mandatory parameters:
- Alarm Type, Id(s) of device(s) and Duration

##### 5.1.8) Towing Alarm

Configure Towing alarm to alert you when the vehicle moves at more than 7km/hr speed in Engine off state.

##### Mandatory parameters:
- Alarm Type, Id(s) of device(s) and Duration

##### 5.1.9) GPRS Connectivity Alarm

Configure GPRS connectivity alarm to alert you when the user or vehicle doesn't send the data to the server for more than the defined duration as per configuration.

##### Mandatory parameters:
- Alarm Type, Id(s) of device(s) and Duration

##### 5.1.10) Vehicle Battery Alarm

Configure Vehicle battery alarm to alert you when the vehicle battery goes below the configured voltage value.

##### Mandatory parameters:
- Alarm Type, Id(s) of the device(s), Limit and Duration

##### 5.1.11) Mileage Alarm

Configure Mileage alarm to alert you when the vehicle or user travels the configured distance within the time duration. The distance can be configured for Daily and Monthly limit.

##### Mandatory parameters:
- Alarm Type, Id(s) of device(s) , Type and Duration

##### 5.1.12) GPS Connectivity Alarm

Configure GPS connectivity alarm to trigger an alert when the user or vehicle doesn't send the valid location to the server for more than the defined duration as per configuration.

##### Mandatory parameters:
- Alarm Type, Id(s) of device(s) and Duration

##### 5.1.13) Distance Covered Alarm

Configure Distance covered alarm to trigger an alert when the vehicle or user covers the particular distance in the given duration or if the user travels less than the limit in the given duration then the alert will be triggered.

There are two types of distance covered alarm.
- At least
- At Most.

For example **At least** will be used whenever a user doesn't travel 30 km within 1 hr.

**At most** can be used when the user travels more than 30 km in 1hr.


##### Mandatory parameters:
- Alarm Type, Id(s) of the device(s), Type, Limit and Duration

##### 5.1.14) Internal Battery Voltage Alarm

Configure Internal battery alarm to alert you when the Vehicle Tracking device Internal battery goes below the configured voltage value for a certain duration.

##### Mandatory parameters:
- Alarm Type, Id(s) of the device(s), Limit and Duration


#### Create Alarm Method

Define the hashmap as mentioned above based on the required alarm then call the below method.
### Objective-c
```objc
// IntouchAlarmCreatedResponse - returns success if alarm created successfully, else error as callback methods.
IntouchAlarmOptions*optionAlarm = [[IntouchAlarmOptions alloc]initWithAlarmType:1 deviceIds:1 type:1 duration:1 limit:1 geofenceIds:1 severity:1];

[Intouch.shared getAlarmCreatedWithAlarmParam:optionAlarm completionHandler:^(IntouchAlarmCreatedResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```
### Swift
```swift
// IntouchAlarmOptions class accepts below param
let options = IntouchAlarmOptions(alarmType: 13, deviceIds: [8440,8501], type: 1, duration: 11, limit: 55, geofenceIds: [23434], severity: 0)

Intouch.shared.getAlarmCreated(alarmParam: options) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.
    }
}
```

### Request Parameters based on different Alarms.
1. ```deviceId``` - Device id(s). You can pass a single device Id or multiple device Ids in the array.
2. ```type``` - Type is based on different alarms. Only required in case of the Geofence, Ignition, Mileage, and Distance Covered alarm. For this directly you can enter the respective integer values as mentioned below or else you can use the InTouch Constants. e.g: for AlarmType - Geofence(value-26), one of the type value is InTouchConstants.ALARM_GEOFENCE_ENTRY (value -2). [Click](https://github.com/MapmyIndia/mapmyindia-intouch-android-sdk/wiki/InTouch-Constants) to see more values.
3. ```duration``` - Time duration in seconds. Only required in case of Overspeed, stoppage, idle, towing, GPRS connectivity, vehicle battery, GPS connectivity, distance covered, internal battery alarm.
4. ```limit``` - Limits for various alarms based on alarm type. It is an integer. eg: 55. Unit changes for different alarm types. 
    - Overspeed Alarm - km/hr 
	- vehicle battery -  millivolts
	- mileage - in km/hr
	- distance covered - meters
	- internal battery alarm - millivolts
5.  ``` geofenceId```- Geofence Id(s). Only required in case of alarm Type Geofence. You can pass a single geofence ID or multiple geofence IDs in array.
6. ```alarmType```- For each type of alarm constant value is being assigned. 
Type of alarm to create. Following are the alarm types & their corresponding IDs.  Ignition: 21, Overspeed: 22, Unplugged: 23, Panic: 24, Geofence: 26, Stoppage: 27, Idle: 28, Towing: 29, GPRS Connectivity: 126, Vehicle Battery: 129, Mileage: 133, GPS Connectivity: 146, Distance Covered: 151, Internal Battery Voltage:161


#### Note:- User can use these request parameters as key in HashMap<String, String> according to different alarms type and mandatory fields required for that alarm type.

 Users may use [InTouchConstants](https://github.com/MapmyIndia/mapmyindia-intouch-android-sdk/wiki/InTouch-Constants)class of InTouch Sdk for different alarm type values like for geofence alarm type is 26, user can use InTouchConstants.ALARM_GEOFENCE instead of 26.

### Response Code

#### Success
1.  201 To denote a successful record is being created.

#### Client-side issues

1.  400 Bad Request, the user made an error while creating a valid request.
2.  401 Unauthorized, Developer’s key is not allowed to send a request with restricted parameters.
3.  403 Forbidden, the Developer’s key has hit its daily hourly limit.

#### Server-Side Issues

1.  500 Internal Server Error, the request caused an error in our systems.
2.  503 Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200 Success
2. 203 Device Not Found
3. 400 Bad Request - Invalid device ID supplied or invalid data type. For example, input attribute id is an integer but string value gets passed.
4. 401 Unauthorized Request. Access to API is forbidden.
5. 404 Not Found - URL Not Found

### Response Parameter
`CreateAlarmResponse` - class object returns the API response as a JSON object.  
 #### Create Alarm Response result parameters
  ```id (Long)``` Id of the newly created Alarm.
  
### 5.2 Get Alarm configurations

Use the below methods to retrieve the configured alarms in your account with a unique alarm ID.

#### 5.2.1  Get All Alarm configurations

Call the GetAlarmConfigs method without any input parameter to display all the configured alarms from the account in response.
### Objective-c
```objc

\\\ Get all Alarm config
// Response - returns all alarms configurations if success, else error as callback methods.
[Intouch.shared getAlarmConfigWithCompletionHandler:^(IntouchAlarmConfigResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getAlarmConfig { (response, error) in
     if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
       // write your code here.  
    }
}
```

#### 5.2.2  Get alarm configurations based on the selected parameter

In the getAlarmConfigs(), Input parameters like devices or Alarm type or Alarm Ids can be passed to filter the particular set alarm configurations. 
### Objective-c
```objc
// Alarms configurations based on different selected parameters. Users can pass null if none of the given parameters is required.

_NSArray*alarmId = @[@1, @2, @3, @4, @5, @6];
_NSArray*deviceId = @[@1, @2, @3, @4, @5, @6];
_NSArray*alarmTypeID = @[@1, @2, @3, @4, @5, @6];

[Intouch.shared getAlarmConfigWithAlarmIds:_alarmId deviceIds:_deviceId alarmTypes:_alarmTypeID completionHandler:^(IntouchAlarmConfigResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getAlarmConfig(alarmIds: [], deviceIds: [], alarmTypes: []) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
       // write your code here.  
    }
}
```
 ### Request Parameters
1.```alarmIds (Int[])``` - Array of alarm ids. Users can pass alarm ids array to get alarm configurations for provided ids otherwise pass null for all configurations.

2.```deviceIds (Int[])``` - Array of device ids. Users can pass device ids array for selected devices alarm configurations otherwise pass null for all configurations.

3.```alarmTypes (Integer[])```- Array of alarm types. Users can pass alarm types array for selected alarm type alarms configurations otherwise pass null for all configurations.

### Response Code
#### Success
1.  200 To denote a successful API call.
#### Client-side issues

1.  400 Bad Request, the user made an error while creating a valid request.
2.  401 Unauthorized, Developer’s key is not allowed to send a request with restricted parameters.
3.  403 Forbidden, the Developer’s key has hit its daily hourly limit.

#### Server-Side Issues

1.  500 Internal Server Error, the request caused an error in our systems.
2.  503 Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200 Success
2. 203 Device Not Found
3. 400 Bad Request - Invalid device ID supplied or invalid data type. For example, input attribute id is an integer but string value gets passed.
4. 401 Unauthorized Request. Access to API is forbidden.
5. 404 Not Found - URL Not Found
### Response Parameter
`InTouchAlarmResponse ` class object returns the API response as a JSON object.  

 #### InTouchGeoFenceResponse result parameters
  ```- ListAlarmsConfig```- List of AlarmsConfig.
  ##### AlarmsConfig Parameters
  1. ```id(Long)```- Id of alarm
  2. ```deviceId(Long)```- Device Id(s) on which the alarm config got created.
  3. ```alarmType(Integer)``` -Type of alarm for eg - 21 (InTouchConstants.ALARM_IGNITION) etc.
  4. ```limit(Integer)```- Min or Max limit for particular alarm.
  5. ```duration (integer)``` - Min or Max duration in second(s) for particular alarm.
  6. ```type(Integer)```- Values depends on the type of alarm configured for eg for Mileage alarm it should be 0 (InTouchConstants.ALARM_MILEAGE_DAILY) or 1 (InTouchConstants.ALARM_MILEAGE_MONTHLY).
  7. ```updationTime(Long)```- Epoch Time at which the alarm got updated.
  8. ```creationTime(Long)```- Epoch Time at which the alarm got configured.
  9. ```geofenceId(Long[])```- If returned alarm type is geofence (26), then this will return the list of geofences for which alarms were configured.

  10.```severity(Integer)```- Severity of alarm i.e) 0 (ALARM_SEVERITY_NORMAL) or 1 (ALARM_SEVERITY_HIGH) .
  

### 5. 3 Update Alarms(s)

Already created alarms can be updated using the below-mentioned methods. It is similar to create alarm but additionally, alarm ID should be the input parameter to update the respective individual alarm configurations.

Alarm Id can be fetched from the Get Alarm config.

Based on the Alarm type, the Mandatory parameter should be passed in the Class.
### Objective-c
```objc
 IntouchAlarmOptions*optionUpdateAlarm = [[IntouchAlarmOptions alloc]initWithAlarmType:1 deviceIds:1 type:1 duration:1 limit:1 geofenceIds:1 severity:1];

[Intouch.shared updateAlarmWithAlarmId:12 param:optionUpdateAlarm completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
let options = IntouchAlarmOptions(alarmType: 1, deviceIds: [], type: 1, duration: 11, limit: 55, geofenceIds: [], severity: 0)

Intouch.shared.updateAlarm(alarmId: 0, param: options) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
       // write your code here.  
    }
}
```

 ### Request Parameters
1. ```alarmId(Long)``` - Id of the existing alarm.
2. ```deviceId (Long[])``` - Array of device id(s). You can pass a single device iD or multiple device iDs in an array.
3. ```type (Integer)``` - Type is based on different alarms i.e) Only required in case of the geofence, ignition, mileage, and Distance Covered alarm.
4. ```duration (Integer)``` - Time duration in seconds. Only required in case of Overspeed, stoppage, idle, towing, GPRS connectivity, vehicle battery, GPS connectivity, distance covered, internal battery alarm.
5. ```limit (Integer)``` - Limits for various alarms based on alarm type.
6.  ``` geofenceId (Long [])``` - Array of geofence id(s). Only required in case of alarm Type Geofence. You can pass a single geofence ID or multiple geofence IDs in an array.
7. ```alarmType (Integer)``` - For each type of alarm constant value is being assigned. Selected alarm id's alarm type should be passed. It can be passed from the IntouchConstants or as an integer value. The following are the alarm types & their corresponding IDs.  Ignition: 21, Overspeed: 22, Unplugged: 23, Panic: 24, Geofence: 26, Stoppage: 27, Idle: 28, Towing: 29, GPRS Connectivity: 126, Vehicle Battery: 129, Mileage: 133, GPS Connectivity: 146, Distance Covered: 151, Internal Battery Voltage:161

### Response Code
#### Success
1.  200 To denote a successful API call.
#### Client-side issues

1.  400 Bad Request, the user made an error while creating a valid request.
2.  401 Unauthorized, Developer’s key is not allowed to send a request with restricted parameters.
3.  403 Forbidden, the Developer’s key has hit its daily hourly limit.

#### Server-Side Issues

1.  500 Internal Server Error, the request caused an error in our systems.
2.  503 Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200 Success
2. 203 Device Not Found
3. 400 Bad Request - Invalid device ID supplied or invalid data type. For example, input attribute id is an integer but string value gets passed.
4. 401 Unauthorized Request. Access to API is forbidden.
5. 404 Not Found - URL Not Found

### Response Parameter
API response will return as ```Status```  onSuccess() or onError(String reason, String errorIdentifier, String errorDescription)   methods.  

#### 5. 4 Delete Alarm configuration.

`deleteAlarm` method can be used to delete the already configured alarm. In this method, an alarm ID needs to be passed to delete the configurations.

#### 5. 4. 1 Delete single Alarm configuration
### objective-C
```objc
// Delete single alarm
[Intouch.shared DeleteAlarmWithAlarmId:0 completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
      // write your code here.  
    } 
}];
```

### Swift
```swift
Intouch.shared.DeleteAlarm(alarmId: 0) { (statusCode, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }
}
```

#### 5. 4. 2 Delete Multiple Alarm configuration

### objective-c
```Objc
 //Delete multiple alarm
NSArray*alarmId = @[@1, @2, @3, @4, @5, @6];
[Intouch.shared DeleteAlarmsWithAlarmIds:alarmId completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    } 
}];
```
### Swift
```swift
Intouch.shared.DeleteAlarms(alarmIds: []) { (statusCode, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
       // write your code here.  
    }
}
```

 ### Request Parameters
1. ```alarmId(Long)``` - Id or Long[] ids of the alarm config(s) which user wants to delete.  

### Response Code
#### Success
1.  200 To denote a successful API call.

#### Client-side issues

1.  400 Bad Request, the user made an error while creating a valid request.
2.  401 Unauthorized, Developer’s key is not allowed to send a request with restricted parameters.
3.  403 Forbidden, the Developer’s key has hit its daily hourly limit.

#### Server-Side Issues
1.  500 Internal Server Error, the request caused an error in our systems.
2.  503 Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200 Success
2. 203 Device Not Found
3. 400 Bad Request - Invalid device ID supplied or invalid data type. For example, input attribute id is an integer but string value gets passed.
4. 401 Unauthorized Request. Access to API is forbidden.
5. 404 Not Found - URL Not Found

#### 5. 5 Alarm Logs

Once the alert is triggered based on the configured alarms, the below method can be used to get the Alarm log details. 
The alarm log gives the information about the device name, Alarm type location, and time at which alert is being triggered. 

#### 5. 5. 1 Get All alarm Logs.

Get all types of alarm logs between the start and end times of the input using the below method.
 ### objective-c
```objc
// Get Alarm Logs
// IGetAlarmsLogResponse - returns all alram logs if success, else error as callback methods.
[Intouch.shared getAlarmLogsWithStartTime:double endTime:double completionHandler:^(IntouchAlarmConfigLogResponse * _Nullable IGetAlarmsLogResponse, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }      
}];
```
### Swift
```swift
Intouch.shared.getAlarmLogs(startTime: 0, endTime: 0) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }
}
```

#### 5. 5. 2 Get alarm Logs with filter. 

Get the filtered alarm log information between the start and end time by sending the filter details like device id, Alarm type.
### objective-c
```objc
//with filter
[Intouch.shared getAlarmLogsWithDeviceId:_deviceId alarmId:_alarmId startTime:0 endTime:0 completionHandler:^(IntouchAlarmConfigLogResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }             
}];
```

### Swift
```swift
Intouch.shared.getAlarmLogs(deviceId: [], alarmId: [], startTime: 0, endTime: 0) { (IntouchAlarmConfigLogResponse, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }    
}
```

 ### Request Parameters
1. ```startTime(Long)```- Mandatory field. This is start EPOCH timestamp in seconds.
2. ```endTime(Long)```- Mandatory field. This is end EPOCH timestamp in seconds
3. ```deviceId(Long[])``` - Non mandatory field. This is the ID of the device for which the alarm logs need to be fetched. You can pass a single device ID or multiple device IDs separated by a comma. For eg new Long[]{1L} or null.
4. ```alarmType(Integer[])```- Non mandatory field. This is the type of alarm for which the alarm log needs to be fetched. You can pass a single alarm type or multiple alarm type separated by a comma. For eg new Integer[]{IntouchConstant.ALARM_IGNITION} or new Integer[]{21} or null.

### Response Code
#### Success
1.  200 To denote a successful API call.

#### Client-side issues
1.  400 Bad Request, the user made an error while creating a valid request.
2.  401 Unauthorized, Developer’s key is not allowed to send a request with restricted parameters.
3.  403 Forbidden, the Developer’s key has hit its daily hourly limit.

#### Server-Side Issues
1.  500 Internal Server Error, the request caused an error in our systems.
2.  503 Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200 Success
2. 203 Device Not Found
3. 400 Bad Request - Invalid device ID supplied or invalid data type. For example, input attribute id is an integer but string value gets passed.
4. 401 Unauthorized Request. Access to API is forbidden.
5. 404 Not Found - URL Not Found

### Response Parameter
`InTouchAlarmResponse `- Class object returns the API response as a JSON object.  

#### InTouchAlarmLogsResponse result parameters
```- ListAlarmLogs``` - List of AlarmLogs.
  
##### AlarmsConfig Parameters
1. ```deviceId(Long)``` - Id of the device for which the alarm got generated.
2. ```timestamp(Long)```- EPoch Time at which the alert got generated.
3. ```latitude(Double)``` - Location latitude
4. ```longitude(Double)```- Location longitude.
5. ```address(String)``` - Location address at which the alarm got generated.
6. ```alarmType(Integer)``` - Type of alarm to create alarm. The following are the alarm types & their corresponding IDs.
Ignition 21, Overspeed 22, Unplugged 23, Panic 24, Geofence 26, Stoppage 27, Idle 28, Towing 29, GPRS connectivity 126, Vehicle Battery  129, Mileage  133, GPS Connectivity  146, Distance Covered 151, Internal Battery Voltage 161, 

7. ```limit(Integer)```- Alarm limit as set in the config. For example, if an Overspeed alarm set on limit of 44 km/hr in the alarm config setting, then this attribute will return 44 km/hr.
8. ```duration(Integer)``` - Alarm duration limit as set in the alarm config section. For example, if duration of the Overspeed alarm is set as 20 secs, then the alarm will generate when the vehicle speeds for 20 secs.
9. ```actualLimit(Integer)``` -The actual data received from the device at that particular moment the alarm got generated.
10. ```actualDuration(Integer)``` - Actual duration for which the device breached the alarm 
11. ```severity(Integer)``` - 0 - Low Severity. 1 - High Severity
12. ```data(Integer)```- Describes the state of the alarm. 	Ignition(type = 21), 0 Off & 1 On.
AC(type=25), 0 OFF, 1 ON.  Geofence (type=26), 1 Entry & Exit Geofence 2 Entry Geofence, 3 Geofence & 4 Long Stay In Geofence.
14. ```geofenceId(Integer)```- This is the ID of the geofence for which the alarm got generated. will come only when the 'type' field returns 26 i.e) geofence. 

## 6) Trips

Trips module helps you to create a Trip and assign it to the vehicle and the trip compliance. InTouch provides the three major functionalities of Trips modules.

Trip Module Features -

1.  Start a trip with or without destination and via points or with scheduled end time,
2.  Get the latest trip information. ( Total traveled distance during the trip, Travelled path vs planned route, ETA to the destination, etc.)
3.  Trip completion.
	-   Trips can be completed/closed in three different ways.
		-   Based on the scheduled end time
		-   On reaching the destination.
		-   Manually close.

When the trip is created with a destination, InTouch will provide the actual time of the destination and waypoints. 

#### 6.1) Create Trip

InTouch provides four ways to create a new trip. Depending on the use case, You can use the below methods to start a new trip. Based on the selected trip creation method, either trip gets closed/completed automatically or by calling the manual method.

-   Trips without a destination
-   Trips with scheduled end time but without a destination
-   Trips with destination and scheduled end time.
-   Trips with destination but without a scheduled end time.

#### 1. 1. 1 Create Trip without a destination
This method can be used to share a live location with someone else. In this case, the trip shall be closed by calling the close trip method (6.4). 

Also, if the force close is enabled then on the new trip assignment, the active old trip will be force closed. 
### Objective-c
```Objective-c
//IntouchCreateTripResponse - Returned trip ID else return error
NSDictionary*metaData = [[NSDictionary alloc] initWithObjectsAndKeys:@"test",@"alpha",nil];

IntouchCreateTripOptions*createTripOptions = [[IntouchCreateTripOptions alloc]initWithDeviceId:232 name:@"" forceClose:NO metaData:_metaData];
    
[Intouch.shared createTripDataWithOptons:_createTripOptions completionHandler:^(IntouchCreateTripResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
let metaData: [String: String] = [
                    "alpha": "test",
                ]

let options = IntouchCreateTripOptions(name:"",deviceId: 67790, forceClose: true, metaData: metaData)

Intouch.shared.createTripData(optons: options) { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }      
}
```

#### 6.1.2)  Create Trip with Destination and Geofences. 

This method helps to create trips with a destination and waypoints.  Here trip will get close only if the vehicle reaches the destination. otherwise, the manual close trip option can be used to close the trip. 

Also if the force close is enabled then on the new trip assignment, the active old trip will be force closed. 

### Objective-c
```obj

NSDictionary*metaData = [[NSDictionary alloc] initWithObjectsAndKeys:@"test",@"alpha",nil];

IntouchGeometryPoint*tripGeoemetry =  [[IntouchGeometryPoint alloc]initWithPoint:referenceLocation];

IntouchTripDestination*tripDestination =[[IntouchTripDestination alloc]initWithGeoemtry:tripGeoemetry radius:500 scheduledAt:0 metadata:_metaData];

IntouchTripsGeofences*tripGeofence =[[IntouchTripsGeofences alloc]initWithGeoemtry:tripGeoemetry radius:500 scheduledAt:0 metadata:_metaData];
     
IntouchTripsGeofences*tripGeofence1 =[[IntouchTripsGeofences alloc]initWithGeoemtry:tripGeoemetry radius:500 scheduledAt:0 metadata:_metaData];

NSArray*arrGeofence = [[NSArray alloc]initWithObjects:tripGeofence,tripGeofence1, nil];

IntouchCreateTripOptions*createTripOptionsWithGeofence = [[IntouchCreateTripOptions alloc]initWithGeofences:arrGeofence tripDestination:tripDestination name:@"" deviceId:324 forceClose:false metaData:_metaData];

[Intouch.shared createTripDataWithOptons:_createTripOptionsWithGeofence completionHandler:^(IntouchCreateTripResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
let metaData: [String: String] = [
                    "alpha": "test",
                ]
                
let optiongeo = IntouchGeometryPoint(point: CLLocation(latitude: 23.343, longitude: 77.232))
                
let tripdestination = IntouchTripDestination(geoemtry: optiongeo, radius: 500, scheduledAt: 0, metadata: metaData)
                
let tripGeofence = IntouchTripsGeofences(geoemtry: optiongeo, radius: 500, scheduledAt: 0,metadata: metaData)
                
let options = IntouchCreateTripOptions(geofences: [tripGeofence], tripDestination: tripdestination,name:"" deviceId: 67790, forceClose: true, metaData: metaData)

Intouch.shared.createTripData(optons: options) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }      
}
```

#### 6.1.3)  Create Trip with Destination and Geofences using scheduled end time. 

In this method, the trip will get close to the scheduled end time. It is based on the trip duration. Irrespective of the vehicle arrival status on the geofence, the trip will get close after the trip duration (Scheduled end time).  Otherwise, the manual close trip option can be used. 

Also, if the force close is enabled then on the new trip assignment , active old trip will be force closed. 

### Objective-c
```objc
IntouchGeometryPoint*tripGeoemetry =  [[IntouchGeometryPoint alloc]initWithPoint:referenceLocation];

IntouchTripDestination*tripDestination =[[IntouchTripDestination alloc]initWithGeoemtry:tripGeoemetry radius:500 scheduledAt:0 metadata:_metaData];

IntouchTripsGeofences*tripGeofence =[[IntouchTripsGeofences alloc]initWithGeoemtry:tripGeoemetry radius:500 scheduledAt:0 metadata:_metaData];

IntouchTripsGeofences*tripGeofence1 =[[IntouchTripsGeofences alloc]initWithGeoemtry:tripGeoemetry radius:500 scheduledAt:0 metadata:_metaData];

NSArray*arrGeofence = [[NSArray alloc]initWithObjects:tripGeofence,tripGeofence1, nil];

IntouchCreateTripOptions*createTripOptionsWithSeheduleTimeAndGeometry = [[IntouchCreateTripOptions alloc]initWithGeofence:arrGeofence tripDestination:tripDestination name:@"" deviceId:324 forceClose:false scheduledEndTime:1111222 metaData:_metaData];

[Intouch.shared createTripDataWithOptons:_createTripOptionsWithSeheduleTimeAndGeometry completionHandler:^(IntouchCreateTripResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];            
```
### Swift
```swift
let metaData: [String: String] = [
                    "alpha": "test",
                ]
                
let coordinates = [
                    CLLocation(latitude: 28.550704, longitude: 77.268961),
                    CLLocation(latitude: 28.549415, longitude: 77.271757),
                    CLLocation(latitude: 28.54711, longitude: 77.263637),
                    CLLocation(latitude: 28.550704, longitude: 77.268961)
                ]

let optiongeo = IntouchGeometryPolygon(points: coordinates)

let optionPoint = IntouchGeometryPoint(point: CLLocation(latitude: 23.343, longitude: 232))

let tripdestination = IntouchTripDestination(geoemtry: optiongeo, radius: 500, 0, metadata: metaData)

let tripGeofence = IntouchTripsGeofences(geoemtry: optiongeo, radius: 500, scheduledAt: metadata: metaData)

let tripGeofence1 = IntouchTripsGeofences(geoemtry: optionPoint, radius: 500, 0,metadata: metaData)

let options = IntouchCreateTripOptions(geofence: [tripGeofence,tripGeofence1tripDestination: tripdestination,name:"", deviceId: 67790, forceClose: scheduledEndTime: 1602238429, metaData: metaData)

Intouch.shared.createTripData(optons: options) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }          
}
```

 ### Request Parameters
1. ```deviceId(Int)``` - Intouch unique Id of the device for which the trip is getting created.
2. ````<isFroceCloseEnable>(boolean)``` - If true then the trip will get automatically closed as soon as the device gets associated with another trip.
3. ```metadata(NSDictionary<String, String)``` - This can be any key-value data pair. It can be used to tag additional information like customer name or it can be a unique trip ID of your platform.
4. ```tripDestination(TripDestination)``` - Destination of the trip. This is an optional object.
5. ```scheduledEndTime(long)``` - Tentative time in seconds to close the trip. The trip will be closed once the duration gets complete. This is an optional object.
6.  ```tripGeoFences(List<IntouchTripGeoFences>)``` - List of GeoFences points of the trip. This is an optional object.
7. ```isFroceCloseEnable(boolean)``` - if true then trip will get automatically closed as soon as the device gets associated with another trip.

### TripDestination Parameters
1. ```geometry(Geometry)``` - Geometry of destination points coordinates.
2. ```metadata(NSDictionary<String, String)``` - This can be any key-value data pair.
3. ```radius(Integer)``` - Radius for point type geofence.
4. ```scheduledAt(long)``` - scheduled timestamp at which the device reaches the destination.
### TripGeofence Parameters
1. ```geometry(Geometry)``` - geometry of destination points coordinates.
2. ```metadata(NSDictionary<String, String)``` - this can be any key-value data pair.
3. ```radius(Integer)``` - radius of the point.
4. ```scheduledAt(long)``` - scheduled timestamp at which the device reaches the destination.
### Geometry Parameters
1. ```type(String)``` - Type of geometry. Two geometries are allowed. Point or Polygon
2. ```coordinates(List<CLLocation>)``` - List of Longitude and Latitude. For example:- 
```
 let coordinates = [
                    CLLocation(latitude: 28.550704, longitude: 77.268961),
                    CLLocation(latitude: 28.549415, longitude: 77.271757),
                    CLLocation(latitude: 28.54711, longitude: 77.263637),
                    CLLocation(latitude: 28.550704, longitude: 77.268961)
                ]
```

### Response Code

#### Success
1.  200 To denote a successful record is being created.

#### Client-side issues

1.  400 Bad Request, The User made an error while creating a valid request.
2.  401 Unauthorized, Developer’s key is not allowed to send a request with restricted parameters.
3.  403 Forbidden, the Developer’s key has hit its daily hourly limit.

#### Server-Side Issues

1.  500 Internal Server Error, the request caused an error in our systems.
2.  503 Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200 Success
2. 203 Device Not Found
3. 400 Bad Request - Invalid device ID supplied or invalid data type. For example, input attribute id is an integer but string value gets passed.
4. 401 Unauthorized Request. Access to API is forbidden.
5. 404 Not Found - URL Not Found

  
### 6.2) Get List of Trips.

Use this method to get the list of trips which is created under your account. You can get all trips or a filtered list of trips based on creation date, device id, trip status, etc. 

#### 6.2.1)  Get List of all Trips
Using the below method you can get all the trip which is created under your account.

### Objective-c
```objc
// IntouchGetAllTripsResponse - returned list of trips else error
[Intouch.shared getTripsWithCompletionHandler:^(IntouchGetAllTripsResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getTrips { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }      
}
```

#### 6.2.2)  Get List of trips with filters.

Use the below method to get the selected list of trips. you can filter the trip using trip status, start and end time of the trip creation date. 

### Objective-c
```objc
IntouchGetAllTripsOptions*allTripsOptions = [[IntouchGetAllTripsOptions alloc]initWithDeviceIds:_deviceId startTime:12121 endTime:1212121 limit:1 status:1];

[Intouch.shared getTripsWithOptions:_allTripsOptions completionHandler:^(IntouchGetAllTripsResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```
### Swift
```swift
let options = IntouchGetAllTripsOptions(deviceIds: [67790], startTime: 1591368673, endTime: 1591368673, limit: 10, status: 2)

Intouch.shared.getTrips(options: options) { (tripResponse, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }      
}
```

 ### Request Parameters
1. ```limit(int)``` - Will limit the records as per the passed value.
2. ```deviceIds (Long[])``` - Device IDs if you want to get trips associated with partcular devices.
3. ```status(int)``` - Pass 1 to get active trips & 2 for completed trips.
4. ```startTime(long)``` - Start timestamp of the trip.  
5. ```endTime(long)``` - End timestamp of the trip.


### Response Code
#### Success
1.  200 To denote a successful API call.
#### Client-side issues

1.  400 Bad Request, The User made an error while creating a valid request.
2.  401 Unauthorized, Developer’s key is not allowed to send a request with restricted parameters.
3.  403 Forbidden, the Developer’s key has hit its daily hourly limit.

#### Server-Side Issues

1.  500 Internal Server Error, the request caused an error in our systems.
2.  503 Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200 Success
2. 203 Device Not Found
3. 400 Bad Request - Invalid device ID supplied or invalid data type. For example, input attribute id is an integer but string value gets passed.
4. 401 Unauthorized Request. Access to API is forbidden.
5. 404 Not Found - URL Not Found
### Response Parameter
`TripsResponse` class object returns the API response as a JSON object.  

#### Trip result parameters
 1. ```tripId(String)``` - Unique id for the trip.
 2. ```deviceId(long)``` - Unique Id of the device which is associated with the trip.
 3. ```status(Integer)``` - 1 - Active trip. 2 - Completed trip.
 4. ```closureType(Integer)``` - Type of trip closure. 1 - the trip will get closed based on the scheduled end time. 2 - the trip will close when the device enters the destination area/geofence. 3 - the trip will get closed manually by the user.
 5. ```forceClose(Boolean)``` - If true then the trip will get automatically closed as soon as the device gets associated with another trip.
 6. ```name(String)``` - The name of the trip.
 7. ```destination(Destination)``` - This will only get returned in case this object was explicitly defined while creating a trip.
 8. ```geofences(List<Geofence>)``` - A trip may have various points. This will only get returned in case these geofence points were explicitly mentioned while creating a trip.
 9.  ```summary(Summary)``` -  returns summary of particular trip.
 10. ```links(Links)``` - returns object of Links class.
 
##### Destination Parameters
1. ```geometry(Geometry)```- Destination points coordinate geometry. This is standard geo json format.
2. ```radius(integer)```- Radius of the point.
3. ```plannedTime(Long)``` - Planned timestamp at which device reach the destination.
4. ```arrivalTime(Long)```- Actual timestamp at which device reach the destination.
5. ```departureTime(Long)``` - Departure timestamp at which device leaves the destination.
6. ```address(String)```- Address of the destination point.
7. ```time(Long)```- Planned timestamp is taken to reach the destination from the previous point.
8. ```distance(Integer)```- Planned distance is taken to reach the destination from the previous point.
9. ```pointName(String)```- The name given to the destination point.
10. ```metadata(Object)``` - This can be any key-value data pair and will get returned only if it mentioned while creating a 
##### Geofence Parameters
1. ```geometry(Geometry)```- Geofence points coordinate geometry. This is in the standard geo JSON format.
2. ```radius(integer)```- Radius of the point.
3. ```plannedTime(Long)``` - Planned timestamp at which the device reaches the geofence.
4. ```arrivalTime(Long)```- Actual timestamp at which device reach the geofence.
5. ```departureTime(Long)``` - Departure timestamp at which device leaves the geofence.
6. ```address(String)```- Address of the destination point.
7. ```time(Long)```- planned timestamp is taken to reach the geofence from the previous point.
8. ```distance(Integer)```- Planned distance is taken to reach the destination from the previous point.
9. ```pointName(String)```- The name given to the geofence point.
10. ```metadata(Object)``` - This can be any key-value data pair and will get returned only if it mentioned while creating a trip. 

 ##### Summary Parameters
1. ```startedOn(Long)```- The actual start timestamp of the trip.
2. ```duration(Long)```- The actual duration time (in seconds) of the trip.
3. ```distance(Double)``` - The actual distance (in meters) covered in the trip.
4. ```endedOn(Long)```- The actual end timestamp of the trip.
5. ```delayedBy(Long)``` - the actual timestamp by which the trip got delayed.
6. ```plannedEndTime(Long)```- The planned end timestamp of the trip.
7. ```plannedStartTime(Long)```- The planned start timestamp of the trip.
8. ```plannedDuration(long)```- The planned duration time (in seconds) of the trip.
9. ```plannedDistance(Integer)```- The planned distance (in meters) of the trip.

##### Links Parameters
1. ```embedUrl(String)``` - An embedded URL link of the trip. You can use this link to visualize the trip on your web or mobile app.

### 6.3) Trip Info

Use the below method to get the detailed trip information using trip Id.

#### 6.3.1)  Get  Trip by id.

### Objective-c
```objc
// IntouchGetAllTripsResponse- returns TripInfoResponse if success, else error as callback methods.
[Intouch.shared getTripInfoWithTripId:@"5f58e80a8a92df57e80b032f" completionHandler:^(IntouchGetAllTripsResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];    
```
### Swift
```swift
Intouch.shared.getTripInfo(tripId: "5f58e80a8a92df57e80b032f") { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }      
}
```

#### 6.3.2)  Get Trip by id with filters.

Using the below method you can get the limited set of information against the trip Ids. In this method, you can enable or disable some objects based on the requirement.

### Objective-c
```objc
// IntouchGetAllTripsResponse- returns TripInfoResponse if success, else error as callback methods.
[Intouch.shared getTripInfoWithTripId:@"5f58e80a8a92df57e80b032f" isEventsEnable:false isLocationEnable:false isPolylineEnable:false completionHandler:^(IntouchGetAllTripsResponse * _Nullable response, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
```

### Swift
```swift
Intouch.shared.getTripInfo(tripId: "5f58e80a8a92df57e80b032f", isEventsEnable: false, isLocationEnable: false, isPolylineEnable: true) { (response, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response { 
        // write your code here.  
    }      
}
```

 ### Request Parameters
1. ```tripId(string)``` - id of the trip which you want to fetch.
2. ```isEventsEnable(boolean)``` - will return all the position events of the device.
3. ```isLocationEnable(boolean)``` - will return the last know device location details.
4. ```isPolylineEnable(boolean)``` - will return the entire polyline locations of the route which was created for the trip.


### Response Code
#### Success
1.  200 To denote a successful API call.

#### Client-side issues
1.  400 Bad Request, The User made an error while creating a valid request.
2.  401 Unauthorized, Developer’s key is not allowed to send a request with restricted parameters.
3.  403 Forbidden, the Developer’s key has hit its daily hourly limit.

#### Server-Side Issues
1.  500 Internal Server Error, the request caused an error in our systems.
2.  503 Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200 Success
2. 203 Device Not Found
3. 400 Bad Request - Invalid device ID supplied or invalid data type. For example, input attribute id is an integer but string value gets passed.
4. 401 Unauthorized Request. Access to API is forbidden.
5. 404 Not Found - URL Not Found


### Response Parameter
`TripInfoResponse` class object returns the API response as a JSON object.  

 #### TripInfo result parameters
 1. ```tripId(String)``` - Id of the trip.
 2. ```deviceId(long)``` - Id of the device which is associated with the trip.
 3. ```status(Integer)``` - 1 - active trip. 2 - completed trip.
 4. ```closureType(Integer)``` - Type of trip closure. 1 - the trip will get closed based on the scheduled end time. 2 - the trip will close when the device enters the destination area/geofence. 3 - the trip will get closed manually by the user.
 5. ```forceClose(Boolean)``` - If true then the trip will get automatically closed as soon as the device gets associated with another trip.
 6. ```name(String)``` - The name of the trip.
 7. ```destination(Destination)``` - This will only get returned in case this object was explicitly defined while creating a trip.
 8. ```geofences(List<Geofence>)``` - A trip may have various points. This will only get returned in case these geofence points were explicitly mentioned while creating a trip.
 9.  ```summary(Summary)``` -  Returns summary of particular trip.
 10. ```polylinePoints(PolylinePoint)``` - This is the route polyline.
 11.  ```location(Location)``` - Location data of the device.
 12.  ```positionEvents(List<PositionEvent>)``` -  Position events data of the device.
 13. ```links(Links)``` - returns object of Links class.
  ##### Destination Parameters
  1. ```geometry(Geometry)```- Destination points coordinate geometry. This is standard geo json format.
  2. ```radius(integer)```- Radius of the point.
  3. ```plannedTime(Long)``` - Planned timestamp at which device reach the destination.
  4. ```arrivalTime(Long)```- Actual timestamp at which device reach the destination.
  5. ```departureTime(Long)``` - Departure timestamp at which device leaves the destination.
  6. ```address(String)```- Address of the destination point.
  7. ```time(Long)```- Planned time to reach the destination from the previous point.
  8. ```distance(Integer)```- Planned distance to reach the destination from the previous point.
  9. ```pointName(String)```- Destination point name.
  10. ```metadata(Object)``` - This can be any key-value data pair, and will get returned only if it was mentioned while creating a trip. 

  ##### Geofence Parameters
  1. ```geometry(Geometry)```- Geofence points coordinate geometry.This is standard geo json format.
  2. ```radius(integer)```- Radius of the point.
  3. ```plannedTime(Long)``` - Planned timestamp at which device reach the geofence.
  4. ```arrivalTime(Long)```- Actual timestamp at which device reach the geofence.
  5. ```departureTime(Long)``` - Departure timestamp at which device leaves the geofence.
  6. ```address(String)```- Address of the destination point.
  7. ```time(Long)```- Planned time to reach the geofence from the previous point.
  8. ```distance(Integer)```- Planned distance to reach the destination from the previous point.
  9. ```pointName(String)```- Geofence/Stop point name.
  10. ```metadata(Object)``` - This can be any key-value data pair, and will get returned only if it was mentioned while creating a trip. 
  
##### Summary Parameters
  1. ```startedOn(Long)```- The actual start timestamp of the trip.
  2. ```duration(Long)```- The actual duration time (in seconds) of the trip.
  3. ```distance(Double)``` - The actual distance (in meters) covered in the trip.
  4. ```endedOn(Long)```- The actual end timestamp of the trip.
  5. ```delayedBy(Long)``` - The actual timestamp by which the trip got delayed.
  6. ```plannedEndTime(Long)```- The planned end timestamp of the trip.
  7. ```plannedStartTime(Long)```- The planned start timestamp of the trip.
  8. ```plannedDuration(long)```- The planned duration time (in seconds) of the trip.
  9. ```plannedDistance(Integer)```- The planned distance (in meters) of the trip.

##### PolylinePoint Parameters
  1. ```coordinates(Coordinate)``` - Coordinates of polyline.
##### Coordinate Parameters
  1. ```lat(double)``` - Latitude value of polyline point.
  2. ```lng(double)``` - Longitude value of polyline point.

##### Location Parameters
1. ```gpsTime(Long)```- Gps time of the device.
2. ```gprsTime(Long)```- Gprs time of the device.
3. ```latitude(Double)``` - Latitude value of location.
4. ```longitude(Double)```- Longitude value of location.
5. ```address(String)``` - Last location address of the device.
6. ```status(Integer)```- Movement status of the device.  
1 - Moving, 2 - Idle, 3 - stopped, 4 - towing, 5 - No Data, 6 - power off i,e the device's battery is disconnected from the vehicle battery, 7 - No GPS, and 12 - Activation Pending. i,e) the device is not yet active and is yet to send the first ping.

##### PositionEvent Parameters
  1. ```timestamp(long)```- The timestamp of position event.
  2. ```longitude(Double)```-  Longitude value of position event.
  3. ```latitude(Double)``` - Latitude value of position event.
  ##### Links Parameters
   1. ```embedUrl(String)``` - An embedded URL link of the trip. You can use this link to visualize the trip on your web or mobile app.

#### 6.4) Close Trip

The below method helps to close the trip manually. Just pass the trip Id in the method to close or complete the trip.

### objective-C
```objc
// Status- returns success if trip closed successfully, else error as callback methods.
[Intouch.shared closeTripWithTripId:@"" completionHandler:^(NSInteger status, NSError * _Nullable error) {
    if(error) {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    } else {
        // write your code here.  
    }
}];
 ```

### Swift
```swift
Intouch.shared.closeTrip(tripId: "") { (status, error) in
    if let error = error {
        // reason gives the error type. 
        // errorIdentifier gives information about error code. 
        // errorDescription gives a message for a particular error.  
    }
    if let result = response {
        // write your code here.  
    }      
}
```

### Request Parameters
1. ```tripId(String)``` - id of the trip which you want to close.

### Response Code
#### Success
1.  200 - To denote a successful API call.
#### Client-side issues

1.  400 - Bad Request, User made an error while creating a valid request.
2.  401 - Unauthorized, the Developer’s key is not allowed to send a request with restricted parameters.
3.  403 - Forbidden, the Developer’s key has hit its daily hourly limit.

#### Server-Side Issues

1.  500 - Internal Server Error, the request caused an error in our systems.
2.  503 - Service Unavailable, during our maintenance break or server downtimes.

### Response Messages (as HTTP response message)
1. 200 - Success
2. 203 - Device Not Found
3. 400 - Bad Request - Invalid device ID supplied or invalid data type. For example, input attribute id is an integer but string value gets passed.
4. 401 - Unauthorized Request. Access to API is forbidden.
5. 404 - Not Found - URL Not Found.

## Our many customers:

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
