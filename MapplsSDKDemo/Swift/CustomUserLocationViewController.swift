//
//  CustomUserLocationViewController.swift
//  MapplsSDKDemo
//
//  Created by Siddharth  on 21/01/25.
//  Copyright © 2025 MMI. All rights reserved.
//

import UIKit
import MapplsMap
class CustomUserLocationViewController: UIViewController {
    var mapView: MapplsMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapplsMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .follow
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
    }

}

extension CustomUserLocationViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: any MGLAnnotation) -> MGLAnnotationView? {
        if annotation is MGLUserLocation  {
            let customAnnotation = CustomUserLocationAnnotationView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            customAnnotation.backgroundColor = .red
            return customAnnotation
        }
        return nil
    }
    
    
}

class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {

    override func update() { // current location code
        if frame.isNull {
            frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            return setNeedsLayout()
        }
        
        // Check whether we have the user’s location yet.
        guard let userLocationObj = userLocation else {return}
        if CLLocationCoordinate2DIsValid(userLocationObj.coordinate) {
            updateHeading()
        }
    }

    private func updateHeading() {

        if let heading = userLocation!.heading?.trueHeading {
            // arrow.isHidden = false

            // Get the difference between the map’s current direction and the user’s heading, then convert it from degrees to radians.
            let rotation: CGFloat = -MGLRadiansFromDegrees(mapView!.direction - heading)

            // If the difference would be perceptible, rotate the arrow.
            if abs(rotation) > 0.01 {
                // Disable implicit animations of this rotation, which reduces lag between changes.
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layer.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))
                CATransaction.commit()
            }
        }
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        scalesWithViewingDistance = false
        layer.contentsScale = UIScreen.main.scale
        layer.contentsGravity = CALayerContentsGravity.center
        layer.contents = UIImage(named: "icMarkerFocused")?.cgImage
        layer.name = "currentlocation"

    }
}
