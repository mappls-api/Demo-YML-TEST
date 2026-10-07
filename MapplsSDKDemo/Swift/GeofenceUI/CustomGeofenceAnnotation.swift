import UIKit
import MapplsMap
import MapplsGeofenceUI

class CustomGeofenceAnnotation: MGLPointAnnotation,GeofenceAnnotation {
   
    var reuseIdenfier: String? = "GeofenceMarker"
    var geofenceAnnotationImage: UIImage? = UIImage(named: "")

}
