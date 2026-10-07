import MapplsMap

@objc(ClusterAdvancedMarkersExample_Swift)
class ClusterAdvancedMarkersExample_Swift: UIViewController {
    let sourceIdentifier = "clusteredSourceIdentifier"
    let unclusterLayerIdentifier = "unclusterLayerIdentifier"
    let clusterLayerIdentifier = "clusterLayerIdentifier"
    let clusterLayerCountIdentifier = "clusterLayerCountIdentifier"
    
    var mapView: MapplsMapView!
    var popup: UIView?
     var strType:String?
    enum CustomError: Error {
        case castingError(String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strType
        mapView = MapplsMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func drawLayerOnMap(style: MGLStyle) {
        // Array of points
        var pointFeatures = [
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.551635, 77.268805)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.551041, 77.267979)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.552115, 77.265833)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.559786, 77.238859)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.561535, 77.233345)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.562469, 77.235072)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.435931, 77.304689)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.436214, 77.304936)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.438827, 77.308337)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.489028, 77.091252)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.486831, 77.094492)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.486491, 77.094374)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.491510, 77.082149)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.474800, 77.065233)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.471245, 77.072722)),
            CustomPointFeature(coordinate: CLLocationCoordinate2DMake(28.458440, 77.073179)),
            //CustomPointFeature(coordinate: CLLocationCoordinate2DMake()),
        ]
        
        // Setting different 'imageName', 'name' attributes of points to use dynamically in map layers.
        for (index, pointFeature) in pointFeatures.enumerated() {
            pointFeature.attributes = [
                "name": "index - \(index)",
                "imageName": index % 2 == 0 ? "yellowBubble" : "brownBubble"
            ]
        }
        
        // Set/Register all required images in style by checking if they are not registered.
        let redBubbleImage = UIImage(named: "redBubbleMarker")!
        let yellowBubbleImage = UIImage(named: "yellowBubbleMarker")!
        let brownBubbleImage = UIImage(named: "brownBubbleMarker")!
        
        if style.image(forName: "redBubble") == nil {
            style.setImage(redBubbleImage, forName: "redBubble")
        }
        if style.image(forName: "yellowBubble") == nil {
            style.setImage(yellowBubbleImage, forName: "yellowBubble")
        }
        if style.image(forName: "brownBubble") == nil {
            style.setImage(brownBubbleImage, forName: "brownBubble")
        }
        
        
        // Create marker source
        let shape = MGLShapeCollectionFeature(shapes: pointFeatures)
        
        let source = MGLShapeSource(identifier: sourceIdentifier, shape: shape, options: [.clustered: true, .clusterRadius: redBubbleImage.size.width])
        style.addSource(source)
        
        // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled
        // source features.
        // Using property 'imageName' from attributes of feature to set icon dynamically
        let ports = MGLSymbolStyleLayer(identifier: unclusterLayerIdentifier, source: source)
        ports.iconImageName = NSExpression(forKeyPath: "imageName")
        ports.iconAllowsOverlap = NSExpression(forConstantValue: true)
        ports.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
        ports.textColor = NSExpression(forConstantValue: UIColor.white)
        ports.textFontSize = NSExpression(forConstantValue: 8)
        ports.text = NSExpression(forKeyPath: "name")
        ports.textOffset = NSExpression(forConstantValue: CGVector(dx: 0, dy: -1.35))
        ports.textFontNames = NSExpression(forConstantValue: ["Open Sans Bold"])
        ports.predicate = NSPredicate(format: "cluster != YES")
        style.addLayer(ports)
        
        
        // Show clustered features as circles. The `point_count` attribute is built into
        // clustering-enabled source features.
        // Static icon 'redBubble' is used here.
        let clusterLayer = MGLSymbolStyleLayer(identifier: clusterLayerIdentifier, source: source)
        clusterLayer.iconImageName = NSExpression(forConstantValue: "redBubble")
        clusterLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        clusterLayer.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
        clusterLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        clusterLayer.textFontSize = NSExpression(forConstantValue: 8)
        clusterLayer.text = NSExpression(format: "mgl_join({CAST(point_count, 'NSString'), ' People'})")
        clusterLayer.textOffset = NSExpression(forConstantValue: CGVector(dx: 0, dy: -1.35))
        clusterLayer.textFontNames = NSExpression(forConstantValue: ["Open Sans Bold"])
        clusterLayer.predicate = NSPredicate(format: "cluster == YES")
        style.addLayer(clusterLayer)
        
        let shapeCam = mapView.cameraThatFitsShape(shape, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        mapView.setCamera(shapeCam, animated: false)
    }
}

extension ClusterAdvancedMarkersExample_Swift: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // This will only get called for the custom double tap gesture,
        // that should always be recognized simultaneously.
        return true
    }
}

extension ClusterAdvancedMarkersExample_Swift: MapplsMapViewDelegate {
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        drawLayerOnMap(style: style)
    }
}
