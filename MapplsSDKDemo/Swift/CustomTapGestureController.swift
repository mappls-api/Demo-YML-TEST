//
//  CustomTapGestureController.swift
//  MapplsSDKDemo
//
//  Created by ceinfo on 15/11/23.
//  Copyright © 2023 MMI. All rights reserved.
//

import UIKit
import MapplsMap
class CustomTapGestureController: UIViewController {
    var mapView: MapplsMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewSetup()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(sender:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapMap(sender: UITapGestureRecognizer) {
        let spot = sender.location(in: mapView)
        let coordinate = mapView.convert(spot, toCoordinateFrom: mapView)
       
        
        
        let annotations = mapView.visibleAnnotations(in: CGRect(x: spot.x - 10 , y: spot.y - 10, width: 40, height: 40))
        var isSelectedAnnotation = false
        if let annotations = annotations {
            for annotation in annotations {
                isSelectedAnnotation = true
                mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
            }
            return
        }
        
        if !isSelectedAnnotation {
            let selectedAnnotations = mapView.selectedAnnotations
            if selectedAnnotations.count > 0 {
                for annotation in selectedAnnotations {
                    mapView.deselectAnnotation(annotation, animated: true)
                }
                return
            }
            
        }
        
        print("Map taped: Coordinate \(coordinate)")
        
        
        // Logic for map Tap
    }
    
    
    func setupAnnotation() {
        let pointAnnotation = MGLPointAnnotation(title: "Mappls Mapmyindia", coordinate: CLLocationCoordinate2D(latitude: 28.00, longitude: 77.98))
        mapView.addAnnotation(pointAnnotation)
    }
    
    func mapViewSetup() {
        mapView = MapplsMapView()
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}

extension CustomTapGestureController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        setupAnnotation()
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
