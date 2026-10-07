//
//  ListVC.swift

//
//  Created by CE Info on 27/07/18.
//  Copyright © 2022 Mappls. All rights reserved.
//

import UIKit
import MapplsAPIKit

import MapplsMap
class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblVwList: UITableView!
    
    @objc var placemark: MapplsPlacemark?
    @objc var placeDetail: MapplsPlaceDetail?
    
    let listArr: [SectionInfo] = [SectionInfo(rows: SampleType.allCases, headerTitle: "Swift")]
    
    var placeDetails = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapplsMapAuthenticator.sharedManager().initializeSDKSession { isSucess, error in
            
        }
        if let place = placemark {
            self.navigationItem.title = "Place Detail"
            placeDetails = ["Address: \(place.formattedAddress ?? "")", "House Number: \(place.houseNumber ?? "")", "House Name: \(place.houseName ?? "")", "POI: \(place.poi ?? "")", "Street: \(place.street ?? "")", "Sub Sub Locality: \(place.subSubLocality ?? "")", "Sub Locality: \(place.subLocality ?? "")", "Locality: \(place.locality ?? "")", "Village: \(place.village ?? "")", "District: \(place.district ?? "")", "Sub District: \(place.subDistrict ?? "")", "City: \(place.city ?? "")", "State: \(place.state ?? "")", "Pincode: \(place.pincode ?? "")", "Latitude: \(place.latitude ?? "")", "Longitude: \(place.longitude ?? "")", "PlaceId: \(place.mapplsPin ?? "")", "Type: \(place.type ?? "")"]
        } else if let place = placeDetail {
            var latitudeString = ""
            var longitudeString = ""
            if let latitude = place.latitude,
               let longitude = place.longitude {
                latitudeString = "\(latitude)"
                longitudeString = "\(longitude)"
            }
            placeDetails = ["Address: \(place.address ?? "")", "House Number: \(place.houseNumber ?? "")", "House Name: \(place.houseName ?? "")", "POI: \(place.poi ?? "")", "Street: \(place.street ?? "")", "Sub Sub Locality: \(place.subSubLocality ?? "")", "Sub Locality: \(place.subLocality ?? "")", "Locality: \(place.locality ?? "")", "Village: \(place.village ?? "")", "District: \(place.district ?? "")", "Sub District: \(place.subDistrict ?? "")", "City: \(place.city ?? "")", "State: \(place.state ?? "")", "Pincode: \(place.pincode ?? "")", "Latitude: \(latitudeString)", "Longitude: \(longitudeString)", "PlaceId: \(place.mapplsPin ?? "")", "Type: \(place.type ?? "")"]
        }
        else {
            self.navigationItem.title = "Swift"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if placeDetails.count > 0 {
            return 1
        }
        else {
            return listArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if placeDetails.count > 0 {
            return placeDetails.count
        }
        else {
            return listArr[section].rows.count
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if placeDetails.count > 0 {
            cell.textLabel?.text = placeDetails[indexPath.row]
        }
        else {
            cell.textLabel?.text = listArr[indexPath.section].rows[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if placeDetails.count > 0 {
            
        }
        else {
            print("You tapped cell number \(indexPath.row).")
            let sampleType = listArr[indexPath.section].rows[indexPath.row]
            switch sampleType {
            case .interiorPolygons:
                //let vc = InteriorPolygonExample_Swift(nibName: nil, bundle: nil)
                let vc = HighlightPointExample_Swift(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .geoJsonMultipleShapes:
                let vc = MultipleShapesExample_Swift(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .dashedPolyline:
                let vc = DashedPolylineExample_Swift(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .clusteringMarkers:
                let vc = ClusterMarkersExample_Swift(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .clusteringAdvancedMarkers:
                let vc = ClusterAdvancedMarkersExample_Swift(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .geodesicPolyline:
                let vc = GeodesicPolylineExample_Swift(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .customIndoor:
                let vctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomIndoorVC") as? CustomIndoorVC
                self.navigationController?.pushViewController(vctrl!, animated: true)
                break
            case .defaultIndoor:
                let vctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultIndoorVC") as? DefaultIndoorVC
                self.navigationController?.pushViewController(vctrl!, animated: true)
                break
            case .interactiveMarkers:
                let vctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InteractiveMarkerVC") as? InteractiveMarkerVC
                self.navigationController?.pushViewController(vctrl!, animated: true)
                break
            case .pointOnMap:
                let vctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PointOnMapVC") as? PointOnMapVC
                self.navigationController?.pushViewController(vctrl!, animated: true)
                break
            case .draggableMarker:
                let vc = DraggableMapMarkerVC_Swift(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .updateCircle:
                let vc = UpdateCircleExample_Swift(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .multiplePolylines:
                let vc = MultiplePolylinesExample_Swift(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case .trackingPlugin:
                
                let vc = MapplsTrackingSample()
                self.navigationController?.pushViewController(vc, animated: true)
                break
//            case .covidLayers:
//                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CovidLayersExample") as? CovidLayersExample_Swift {
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                break
//            case .covid19SafetyStatus:
//                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CovidSafetyStatusExample") as? CovidSafetyStatusExample_Swift {
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                break
            case .placePicker:
                let vc = PlacePickerViewExampleLauncherVC(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .poiAlongTheRoute:
                let vc = POIsAlongTheRouteVC(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            case .autosuggestWidget:
                let vc = AutosuggestWidgetExamplesLauncherVC(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .distanceMatrixUsingMapplsPins:
                let vc = DistanceMatrixViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .routing:
                let vc = DirectionsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .routingPredictive:
                let vc = PredictiveDirectionsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .directionUIPlugin:
                let vC = DirectionUIViewController()
                self.navigationController?.pushViewController(vC, animated: false)
                break
            case .nearbyUI:
                let vC = NearbyViewControllerLauncher()
                self.navigationController?.pushViewController(vC, animated: false)
            case .geofenceUI:
                let geofenceUILVC = GeofenceUILunchVC()
                self.navigationController?.pushViewController(geofenceUILVC, animated: false)
            case .geoanalytics:
                let geoanalytics = DemoGeoanalyticsViewController()
                geoanalytics.title = "Geoanalytics"
                self.navigationController?.pushViewController(geoanalytics, animated: false)
            case .mapplsMapStyles:
                let mapStyleVC = DemoMapStyleViewController()
                mapStyleVC.title = "Map style"
                self.navigationController?.pushViewController(mapStyleVC, animated: false)
            case .drivingRange:
                let drivingRangeVC = DrivingRangeSampleViewController()
                drivingRangeVC.title = "Driving Range"
                self.navigationController?.pushViewController(drivingRangeVC, animated: false)
            case .roadTrafficDetails:
                let roadTrafficDetails = RoadTrafficDetailsViewController()
                roadTrafficDetails.title = "Road Traffic Details"
                self.navigationController?.pushViewController(roadTrafficDetails, animated: false)
            case .nearbyReport:
                let nearbyReport = DemoNearbyReportViewController()
                nearbyReport.title = "Nearby Report"
                self.navigationController?.pushViewController(nearbyReport, animated: false)
            
            case .trafficTilesOverlay:
                let traffictiles = MapplsTrafficVectorTilesViewController()
                traffictiles.title = "Traffic vector tiles"
                self.navigationController?.pushViewController(traffictiles, animated: false)
            
            case .reverseGeocoding:
                let next = MapplsReverseGeocodeViewController()
                next.title = "Reverse Geocoding"
                self.navigationController?.pushViewController(next, animated: false)
                
            case .mapplsRasterCatalogue:
                let raster = RasterCatalougeViewController()
                raster.title = "Raster Catalogue"
                self.navigationController?.pushViewController(raster, animated: false)
            case .setSymbolSortKeySample:
                let symbolSortKey = SetSymbolSortKeySample()
                symbolSortKey.title = sampleType.title
                self.navigationController?.pushViewController(symbolSortKey, animated: false)
            case .customMapplsPinMarker:
                let mapplsPinMarkerVC = CustomMapplsPinMarkerViewController()
                mapplsPinMarkerVC.title = sampleType.title
                self.navigationController?.pushViewController(mapplsPinMarkerVC, animated: false)
            case .movingMarker:
                let mapplsPinMarkerVC = MovingMarkerViewController()
                mapplsPinMarkerVC.title = sampleType.title
                self.navigationController?.pushViewController(mapplsPinMarkerVC, animated: false)
            case .gradientPolyline:
                let gradientPolylineVC = GradientPolylineViewController()
                gradientPolylineVC.title = sampleType.title
                self.navigationController?.pushViewController(gradientPolylineVC, animated: false)
            case .categoriesMarker:
                let categoriesMarkerViewController = CategoriesMarkerViewController()
                categoriesMarkerViewController.title = sampleType.title
                self.navigationController?.pushViewController(categoriesMarkerViewController, animated: false)
            case .customTapGesture:
                let customTapGestureController = CustomTapGestureController()
                customTapGestureController.title = sampleType.title
                self.navigationController?.pushViewController(customTapGestureController, animated: false)
                
            case .dottedLine:
                let customTapGestureController = DottedLineViewController()
                customTapGestureController.title = sampleType.title
                self.navigationController?.pushViewController(customTapGestureController, animated: false)
                
            case .heatMap:
                let heatMapViewController = HeatMapViewController()
                heatMapViewController.title = sampleType.title
                self.navigationController?.pushViewController(heatMapViewController, animated: false)
                
            case .deviceSearch:
                let deviceSearchViewController = DeviceSearchViewController()
                deviceSearchViewController.title = sampleType.title
                self.navigationController?.pushViewController(deviceSearchViewController, animated: false)
                
            case .routeTrafficPolyline:
                let deviceSearchViewController = RouteTrafficPolylineSample()
                deviceSearchViewController.title = sampleType.title
                self.navigationController?.pushViewController(deviceSearchViewController, animated: false)
            case .feedback:
                let feedbackManagerViewControllerSample = FeedbackManagerViewControllerSample()
                feedbackManagerViewControllerSample.title = sampleType.title
                self.navigationController?.pushViewController(feedbackManagerViewControllerSample, animated: false)
                
            case .iconScaleFactor:
                let dynamicIconController = IconScaleFactorController()
                dynamicIconController.title = sampleType.title
                self.navigationController?.pushViewController(dynamicIconController, animated: false)
            case .dynamicClustering:
                let dynamicClusteringVC = DynamicClusteringViewController()
                dynamicClusteringVC.title = sampleType.title
                self.navigationController?.pushViewController(dynamicClusteringVC, animated: true)
            default:
                let vctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as? mapVC
                self.navigationController?.pushViewController(vctrl!, animated: true)
                vctrl?.sampleType = sampleType
                break
            }
        }
    }
}
