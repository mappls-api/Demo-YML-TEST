//
//  CustomMapplsPinMarkerViewController.swift
//  MapplsSDKDemo
//
//  Created by CE00120420 on 27/04/23.
//  Copyright © 2023 MMI. All rights reserved.
//

import UIKit
import MapplsMap
class CustomMapplsPinMarkerViewController: UIViewController {
    var mapView: MapplsMapView!
    
    var mapplsPinArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapplsMapView()
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        mapplsPinArray = ["gqmh0h", "3n7mku", "3jpgw6", "e2ss4e", "0bz3j3"]
    }
    
    var elocAnnotations = [CustomPointAnnotationEloc]()
    
    func plotPOIMarkers() {
        mapView.removeAnnotations(elocAnnotations)
        elocAnnotations.removeAll()
        guard self.mapplsPinArray.count > 0 else {
            return
        }
        for (index, mapplsPinArray) in self.mapplsPinArray.enumerated() {
            let markerTitle = "\(mapplsPinArray) - \(index)"
            let marker = CustomPointAnnotationEloc(mapplsPin: mapplsPinArray)
            marker.title = markerTitle
            marker.image = UIImage(named: "marker\(index)")
            marker.reuseIdentifier = markerTitle
            elocAnnotations.append(marker)
        }
        
        if elocAnnotations.count > 0 {
            self.mapView.addMapplsAnnotations(elocAnnotations) { isSucess, message in
                self.mapView.showAnnotations(self.elocAnnotations, animated: true)
            }
        }
    }
}


extension CustomMapplsPinMarkerViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        plotPOIMarkers()
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let pointEloc = annotation as? CustomPointAnnotationEloc, let reuseIdentifierEloc = pointEloc.reuseIdentifier, let image = pointEloc.image {
           if let annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifierEloc) {
               return annotationImage
           } else {
               return MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifierEloc)
           }
       }
       return nil
   }
    
    
    
}
