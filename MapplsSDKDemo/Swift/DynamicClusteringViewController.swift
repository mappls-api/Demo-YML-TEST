//
//  DynamicClusteringViewController.swift
//  MapplsSDKDemo
//
//  Created by Robin on 17/03/25.
//  Copyright © 2025 MMI. All rights reserved.
//

import UIKit
import MapplsMap


class DynamicClusterData {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var money: Int
    var id: String
    
    init(coordinate: CLLocationCoordinate2D, image: UIImage? = nil, money: Int, id: String) {
        self.coordinate = coordinate
        self.image = image
        self.money = money
        self.id = id
    }
}

class StyleImageIconView: MGLAnnotationView {
    
    var imageView: UIImageView!
    var moneyLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        frame = CGRect(x: 0, y: 0, width: 170, height: 50)
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        backgroundColor = .red
        
        imageView = UIImageView()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalToConstant: 35),
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        moneyLbl = UILabel()
        moneyLbl.layer.masksToBounds = true
        moneyLbl.textColor = .white
        moneyLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(moneyLbl)
        
        NSLayoutConstraint.activate([
            moneyLbl.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            moneyLbl.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            moneyLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            moneyLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.width/2
    }
}



class DynamicClusteringViewController: UIViewController {
    
    var mapView: MapplsMapView!
    var mapCenterBtn: UIButton!
    var reloadBtn: UIBarButtonItem!
    var sourceIdentifier: String = "sourceIdentifier"
    var unclusterLayerIdentifier: String = "unclusterLayerIdentifier"
    var clusterLayerIdentifier: String = "clusterLayerIdentifier"
    
    var clusterData: [DynamicClusterData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func loadView() {
        super.loadView()
       
    }
    
    func setUpUI() {
        navigationItem.titleView?.backgroundColor = .white
        view.backgroundColor = .white
        
        prepareData()
        
        mapView = MapplsMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapCenterBtn = UIButton()
        mapCenterBtn.backgroundColor = .white
        mapCenterBtn.setImage(UIImage(named: "map-center-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        mapCenterBtn.addTarget(self, action: #selector(self.centerMap), for: .touchUpInside)
        mapCenterBtn.layer.cornerRadius = 25
        mapCenterBtn.layer.shadowColor = UIColor.gray.cgColor
        mapCenterBtn.layer.shadowRadius = 3
        mapCenterBtn.layer.shadowOffset = .zero
        mapCenterBtn.layer.shadowOpacity = 0.3
        mapCenterBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapCenterBtn)
        
        NSLayoutConstraint.activate([
            mapCenterBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mapCenterBtn.heightAnchor.constraint(equalToConstant: 50),
            mapCenterBtn.widthAnchor.constraint(equalToConstant: 50),
            mapCenterBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        reloadBtn = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath"), style: .plain, target: self, action: #selector(self.reloadData))
        navigationItem.rightBarButtonItem = reloadBtn
    }
    
    func updateData(maxOffset: Double = 0.02) {
        clusterData = clusterData.map { data in
            let randomLatitudeOffset = Double.random(in: -maxOffset...maxOffset)
            let randomLongitudeOffset = Double.random(in: -maxOffset...maxOffset)
            
            let newCoordinate = CLLocationCoordinate2D(
                latitude: data.coordinate.latitude + randomLatitudeOffset,
                longitude: data.coordinate.longitude + randomLongitudeOffset
            )
            data.coordinate = newCoordinate
            return data
        }
        clusterData.forEach { data in
            data.money = Int.random(in: Range.init(uncheckedBounds: (lower: 100000, upper: 10000000)))
        }
    }
    
    func viewForClusterData(date: DynamicClusterData) -> UIImage {
        let view = StyleImageIconView(reuseIdentifier: date.id)
        view.moneyLbl.text = "$ \(date.money)"
        view.imageView.image = date.image
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { context in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
    
    func prepareData() {
        clusterData = []
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.551635, 77.268805), image: UIImage(named: "face_image")!, money: 1500, id: "person1"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.551041, 77.267979), image: UIImage(named: "face_image")!, money: 3200, id: "person2"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.552115, 77.265833), image: UIImage(named: "face_image")!, money: 4200, id: "person3"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.559786, 77.238859), image: UIImage(named: "face_image")!, money: 1200, id: "person4"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.561535, 77.233345), image: UIImage(named: "face_image")!, money: 1200, id: "person5"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.562469, 77.235072), money: 3500, id: "person6"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.435931, 77.304689), money: 6300, id: "person7"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.436214, 77.304936), money: 3600, id: "person8"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.438827, 77.308337), money: 8300, id: "person9"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.489028, 77.091252), image: UIImage(named: "face_image")!, money: 3800, id: "person10"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.486831, 77.094492), money: 8300, id: "person11"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.486491, 77.094374), money: 8300, id: "person12"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.474800, 77.065233), money: 8300, id: "person13"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.471245, 77.072722), money: 8300, id: "person14"))
        clusterData.append(.init(coordinate: CLLocationCoordinate2DMake(28.458440, 77.073179), image: UIImage(named: "face_image")!, money: 8300, id: "person15"))
    }
    
    @objc func centerMap() {
        if let location = mapView.userLocation?.location ?? CLLocationManager().location {
            mapView.setCenter(location.coordinate, zoomLevel: 18, animated: true)
        }
    }
    
    @objc func reloadData() {
        updateData()
        if let style = mapView.style {
            drawAdvancedClusteringLayerOnMap(style: style, setCamera: false)
        }
    }
    
    func drawAdvancedClusteringLayerOnMap(style: MGLStyle, setCamera: Bool = true) {
        
        var pointFeatures: [MGLPointFeature] = []
        clusterData.forEach { data in
            let feature: MGLPointFeature = MGLPointFeature()
            feature.coordinate = data.coordinate
            feature.attributes = [
                "imageName": data.id
            ]
            pointFeatures.append(feature)
            style.setImage(viewForClusterData(date: data), forName: data.id)
        }
        
        // Set/Register all required images in style by checking if they are not registered.
        let redBubbleImage = UIImage(named: "redBubbleMarker")!
        if style.image(forName: "redBubble") == nil {
            style.setImage(redBubbleImage, forName: "redBubble")
        }
        
        
        // Create marker source
        let shape = MGLShapeCollectionFeature(shapes: pointFeatures)
        
        if let oldSource = style.source(withIdentifier: sourceIdentifier)  as? MGLShapeSource {
            oldSource.shape = shape
        } else {
            let source = MGLShapeSource(identifier: sourceIdentifier, shape: shape, options: [.clustered: true, .clusterRadius: redBubbleImage.size.width])
            style.addSource(source)
            
            
            let ports = MGLSymbolStyleLayer(identifier: unclusterLayerIdentifier, source: source)
            ports.iconImageName = NSExpression(forKeyPath: "imageName")
            ports.iconAllowsOverlap = NSExpression(forConstantValue: true)
            ports.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
            ports.textColor = NSExpression(forConstantValue: UIColor.white)
            ports.textFontSize = NSExpression(forConstantValue: 8)
            ports.textOffset = NSExpression(forConstantValue: CGVector(dx: 0, dy: -1.35))
            ports.textFontNames = NSExpression(forConstantValue: ["Open Sans Bold"])
            ports.predicate = NSPredicate(format: "cluster != YES")
            style.addLayer(ports)
            
            
            
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
        }
        
        
        if setCamera {
            let shapeCam = mapView.cameraThatFitsShape(shape, direction: CLLocationDirection(0), edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            mapView.setCamera(shapeCam, animated: false)
        }
    }
}

extension DynamicClusteringViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        guard let style = mapView.style else {return}
        drawAdvancedClusteringLayerOnMap(style: style)
    }
}
