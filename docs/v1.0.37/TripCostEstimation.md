## [Trip Cost Estimation API](#Trip-Cost-Estimation-API)
Trip Cost Estimation method provides total estimated cost for a route including tolls. User would still get the response for tolls  present on the route in absence of inputs given for fuel cost estimation .

Major features are 
1. Toll on route - It enable user to get the information about tolls on the set route, along with that user get value added information like total number of tolls, total cost on the basis of vehicle types, distance, duration, Individal toll details like Toll Name, Toll Cost, address, coordinates, distance, duration and so on.

**_Note_** : Default parameter is dependent upon route profile selection
 2AxlesAuto for Driving, 2AxlesTruck for Trucking, 2AxlesMoto for Biking 

2. Fuel Cost Estimation in a trip - Provisioning is done to populate estimated trip cost by passing specific params as input, API Provides/calculates the total estimated cost of any trip which include fuel cost and toll costs.

## [Implementation](Implemenation)

#### Swift
```swift
let  options = MapplsCostEstimationOptions(routeId: "Route Id")
options.routeIndex = selectedRoute.routeIndex as NSNumber
MapplsCostEstimationManager.shared.getMapplsTollResult(options) { placemarks, error in
    if let error = error {
        print(error)
    } else {
        print(placemarks)
    }
}
```

## [Request Parameters](#Request_Parameter)


`MapplsCostEstimationOptions` is request class which will be used to pass all required and optional parameters. So it will be require to create an instance of `MapplsCostEstimationOptions` and pass that instance to `getMapplsTollResult` function of `MapplsCostEstimationManager`.

The bold one are mandatory, and the italic one are optional.  

### [a. Mandatory Parameters](#a_Mandatory_Parameters)

1.	`routeId(String)` : A unique Id created by passing Start and End Location Coordinates.


### [b. Optional Parameters](#b_Optional_Parameters) 

1. `vehicleType(String)`: Vehicle type accepted values are 
    2AxlesAuto 
    2AxlesBus
    2AxlesLCV 
    2AxlesMoto 
    2AxlesTruck
    2AxlesHCMEME
    3Axles
    4Axles
    5Axles
    6Axles
    7Axles

**Note** : Default parameter is dependent upon route profile selection
 2AxlesAuto for Driving, 2AxlesTruck for Trucking, 2AxlesMoto for Biking 
1. `routeIndex(NSNumber)`: To get the trip info of selected route. 
2. `vehicleFuelType(String)` : Fuel type of vehicle accepted values are
3. `fuelEfficiency(String)` : Value defined to current efficiency of any vehicle
4. `fuelEfficiencyUnit(String)` : Unit of Fuel based on fuel type accepted values are
5. `fuelPrice(Double)` : Price of fuel 
6. `isTollEnabled(Bool)` : This parameter is to poupulate/restrict toll data, possible Values  are "true" & "false", Default value is set as "false"
7. `distance(NSNumber)`:
8. `coordinate(CLLocation)`:
**Note**: Claim provision is mandatory to get response/results.

## [Response Parameters](#Response-Parameters)