import Foundation

struct SectionInfo {
    var rows : [SampleType] = []
    var headerTitle : String?
}

enum SampleType: String, CaseIterable {
    case roadTrafficDetails
    case geofenceUI
    case geoanalytics
    case mapplsMapStyles
    case trafficTilesOverlay
    case drivingRange
    case nearbyReport
    case zoomLevel
    case zoomLevelWithAnimation
    case centerWithAnimation
    case currentLocation
    case trackingMode
    case addMarker
    case removeMarker
    case addMultipleMarkersWithBounds
    case customMarker
    case customMapplsPinMarker
    case animateMarker
    case draggableMarker
    case clusteringMarkers
    case clusteringAdvancedMarkers
    case interactiveMarkers
    case polyline
    case multiplePolylines
    case trackingPlugin
    case polygons
    case circles
    case updateCircle
    case autosuggest
    case geocode
    case reverseGeocoding
    case mapplsRasterCatalogue
    case nearbySearch
    case placeDetail
    case distanceMatrix
    case distanceMatrixETA
    case distanceMatrixUsingMapplsPins
    case routeAdvance
    case routeAdvanceETA
    case routing
    case routingPredictive
    case feedback
    case geoJsonMultipleShapes
    case dashedPolyline
    case geodesicPolyline
    case interiorPolygons
    case defaultIndoor
    case customIndoor
    case pointOnMap
//    case covidLayers
//    case covid19SafetyStatus
    case placePicker
    case poiAlongTheRoute
    case autosuggestWidget
    case directionUIPlugin
    case nearbyUI
    case setSymbolSortKeySample
    case movingMarker
    case gradientPolyline
    case categoriesMarker
    case customTapGesture
    case dottedLine
    case heatMap
    case deviceSearch
    case routeTrafficPolyline
    case iconScaleFactor
    case customUserLocation
    case dynamicClustering
    
    var title: String {
        switch self {
        case .roadTrafficDetails:
            return "Road Traffic Details"
        case .geofenceUI:
            return "Geofence UI"
        case .geoanalytics:
            return "Geoanalytics"
        case .mapplsMapStyles:
            return "Mappls Map Styles"
        case .drivingRange:
            return "Driving Range"
        case .nearbyReport:
            return "Nearby Report"
        case .zoomLevel:
            return "Zoom Level"
        case .zoomLevelWithAnimation:
            return "Zoom Level With Animation"
        case .centerWithAnimation:
            return "Center With Animation"
        case .currentLocation:
            return "Current Location"
        case .trackingMode:
            return "Tracking Mode"
        case .addMarker:
            return "Add Marker"
        case .removeMarker:
            return "Remove Marker"
        case .addMultipleMarkersWithBounds:
            return "Add Multiple Markers With Bounds"
        case .customMarker:
            return "Custom Marker"
        case .customMapplsPinMarker:
            return "Custom Mappls Pin Marker"
        case .animateMarker:
            return "Animate Marker"
        case .draggableMarker:
            return "Draggable Marker"
        case .clusteringMarkers:
            return "Clustering Markers"
        case .clusteringAdvancedMarkers:
            return "Clustering Advanced Markers"
        case .interactiveMarkers:
            return "Interactive Markers"
        case .polyline:
            return "Polyline"
        case .multiplePolylines:
            return "Multiple Polylines"
        case .polygons:
            return "Polygons"
        case .circles:
            return "Circles"
        case .updateCircle:
            return "Update Circle"
        case .autosuggest:
            return "Autosuggest"
        case .geocode:
            return "Geocode"
        case .reverseGeocoding:
            return "Reverse Geocoding"
        case .nearbySearch:
            return "Nearby Search"
        case .placeDetail:
            return "Place Detail"
        case .distanceMatrix:
            return "Distance Matrix"
        case .distanceMatrixETA:
            return "Distance Matrix ETA"
        case .distanceMatrixUsingMapplsPins:
            return "Distance Matrix Mappls Pins"
        case .routeAdvance:
            return "Route Advance"
        case .routeAdvanceETA:
            return "Route Advance ETA"
        case .routing:
            return "Routing/Directions"
        case .routingPredictive:
            return "Routing/Directions Predictive"
        case .feedback:
            return "Feedback"
        case .geoJsonMultipleShapes:
            return "GeoJson Multiple Shapes"
        case .dashedPolyline:
            return "Dashed Polyline"
        case .geodesicPolyline:
            return "Geodesic Polyline"
        case .interiorPolygons:
            return "Interior Polygons"
        case .defaultIndoor:
            return "Default Indoor"
        case .customIndoor:
            return "Custom Indoor"
        case .pointOnMap:
            return "Point On Map"
//        case .covidLayers:
//            return "Covid Layers"
//        case .covid19SafetyStatus:
//            return "COVID-19 Safety Status"
        case .placePicker:
            return "Place Picker"
        case .poiAlongTheRoute:
            return "POI along the Route"
        case .autosuggestWidget:
            return "Autosuggest Widget"
        case .directionUIPlugin:
            return "DirectionUI Plugin"
        case .nearbyUI:
            return "Nearby UI"
        case .trafficTilesOverlay:
            return "Traffic Tiles Overlay"
        case .mapplsRasterCatalogue:
            return "MapplsRasterCatalogue"
        case .setSymbolSortKeySample:
            return "Set Symbol Sort Key Sample"
        case .movingMarker:
            return "Moving Marker"
        case .gradientPolyline:
            return "Gradient Polyline"
        case .categoriesMarker:
            return "Categories Marker"
        case .customTapGesture:
            return "Custom Tap Gesture"
        case .dottedLine:
            return "Dotted Line"
        case .heatMap:
            return "Heat Map"
        case .deviceSearch:
            return "Device Search"
        case .routeTrafficPolyline:
            return "Route Traffic Polyline"
        case .iconScaleFactor:
            return "Icon Scale Factor"
        case .customUserLocation:
            return "Custom User Location"
        case .dynamicClustering:
            return "Advanced Dynamic Clustering"
        case .trackingPlugin:
            return "Tracking Plugin"
        }
    }
}
