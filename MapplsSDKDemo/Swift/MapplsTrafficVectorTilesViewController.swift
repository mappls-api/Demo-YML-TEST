//
//  MapplsTrafficVectorTilesViewController.swift
//  MapplsSDKDemo
//
//  Created by CE00120420 on 09/08/22.
//  Copyright © 2022 MMI. All rights reserved.
//

import UIKit
import MapplsMap


// set style which support traffic vectro tiles.
class MapplsTrafficVectorTilesViewController: UIViewController {
    var trafficEnabledButton: UIButton!
    var closureTrafficEnabledButton: UIButton!
    var freeFlowTrafficEnabledButtom: UIButton!
    var stopIconTrafficEnabledButton: UIButton!
    var nonFreeFlowTrafficEnabledButton: UIButton!
    var mapView: MapplsMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapplsMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(mapView)
        mapView.zoomLevel = 10
        let coordinate = CLLocationCoordinate2D(latitude: 28.5354, longitude: 77.2639)
        mapView.setMapplsMapStyle("sublime_grey")
        setButtonUI()
        mapView.setCenter(coordinate, animated: false)
        
    }
    
    func setButtonUI() {
        trafficEnabledButton = UIButton()
        trafficEnabledButton.translatesAutoresizingMaskIntoConstraints = false
        trafficEnabledButton.setTitle("Traffic Layer", for: .normal)
        trafficEnabledButton.setTitleColor(.red, for: .normal)
        trafficEnabledButton.setTitleColor(.green, for: .selected)
        trafficEnabledButton.backgroundColor = UIColor.gray
        trafficEnabledButton.addTarget(self, action: #selector(trafficLayerButtonToggle), for: .touchUpInside)
        self.view.addSubview(trafficEnabledButton)
        
        trafficEnabledButton.topAnchor.constraint(equalTo: self.view.safeTopAnchor, constant: 20).isActive = true
        trafficEnabledButton.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor, constant: -12).isActive = true
        
        
        closureTrafficEnabledButton = UIButton()
        closureTrafficEnabledButton.translatesAutoresizingMaskIntoConstraints = false
        closureTrafficEnabledButton.setTitle("closure Traffic Layer", for: .normal)
        closureTrafficEnabledButton.setTitleColor(.red, for: .normal)
        closureTrafficEnabledButton.setTitleColor(.green, for: .selected)
        closureTrafficEnabledButton.backgroundColor = UIColor.gray
        closureTrafficEnabledButton.addTarget(self, action: #selector(closureTrafficLayerButtonToggle), for: .touchUpInside)
        self.view.addSubview(closureTrafficEnabledButton)
        
        closureTrafficEnabledButton.topAnchor.constraint(equalTo: trafficEnabledButton.bottomAnchor, constant: 5).isActive = true
        closureTrafficEnabledButton.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor, constant: -12).isActive = true
        
        freeFlowTrafficEnabledButtom = UIButton()
        freeFlowTrafficEnabledButtom.translatesAutoresizingMaskIntoConstraints = false
        freeFlowTrafficEnabledButtom.setTitle("Free Flow Traffic Layer", for: .normal)
        freeFlowTrafficEnabledButtom.setTitleColor(.red, for: .normal)
        freeFlowTrafficEnabledButtom.setTitleColor(.green, for: .selected)
        freeFlowTrafficEnabledButtom.backgroundColor = UIColor.gray
        freeFlowTrafficEnabledButtom.addTarget(self, action: #selector(freeFlowTrafficLayerButtonToggle), for: .touchUpInside)
        self.view.addSubview(freeFlowTrafficEnabledButtom)
        
        freeFlowTrafficEnabledButtom.topAnchor.constraint(equalTo: closureTrafficEnabledButton.bottomAnchor, constant: 5).isActive = true
        freeFlowTrafficEnabledButtom.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor, constant: -12).isActive = true
        
        
        stopIconTrafficEnabledButton = UIButton()
        stopIconTrafficEnabledButton.translatesAutoresizingMaskIntoConstraints = false
        stopIconTrafficEnabledButton.setTitle("Stop Icon Traffic Layer", for: .normal)
        stopIconTrafficEnabledButton.setTitleColor(.red, for: .normal)
        stopIconTrafficEnabledButton.setTitleColor(.green, for: .selected)
        stopIconTrafficEnabledButton.backgroundColor = UIColor.gray
        stopIconTrafficEnabledButton.addTarget(self, action: #selector(stopIconTrafficLayerButtonToggle), for: .touchUpInside)
        self.view.addSubview(stopIconTrafficEnabledButton)
        
        stopIconTrafficEnabledButton.topAnchor.constraint(equalTo: freeFlowTrafficEnabledButtom.bottomAnchor, constant: 5).isActive = true
        stopIconTrafficEnabledButton.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor, constant: -12).isActive = true
        
        
        nonFreeFlowTrafficEnabledButton = UIButton()
        nonFreeFlowTrafficEnabledButton.translatesAutoresizingMaskIntoConstraints = false
        nonFreeFlowTrafficEnabledButton.setTitle("NonFree Flow Traffic Layer", for: .normal)
        nonFreeFlowTrafficEnabledButton.setTitleColor(.red, for: .normal)
        nonFreeFlowTrafficEnabledButton.setTitleColor(.green, for: .selected)
        nonFreeFlowTrafficEnabledButton.backgroundColor = UIColor.gray
        nonFreeFlowTrafficEnabledButton.addTarget(self, action: #selector(nonFreeFlowToggleTrafficLayers), for: .touchUpInside)
        self.view.addSubview(nonFreeFlowTrafficEnabledButton)
        
        nonFreeFlowTrafficEnabledButton.topAnchor.constraint(equalTo: stopIconTrafficEnabledButton.bottomAnchor, constant: 5).isActive = true
        nonFreeFlowTrafficEnabledButton.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor, constant: -12).isActive = true
        
    }

    @objc func trafficLayerButtonToggle(_ button: UIButton) {
        let newState = !button.isSelected
        button.isSelected = newState
        self.mapView.isTrafficEnabled = newState
    }
    
    @objc func closureTrafficLayerButtonToggle(_ button: UIButton) {
        let newState = !button.isSelected
        button.isSelected = newState
        self.mapView.isClosureTrafficEnabled = newState
    }
    
    @objc func freeFlowTrafficLayerButtonToggle(_ button: UIButton) {
        let newState = !button.isSelected
        button.isSelected = newState
        self.mapView.isFreeFlowTrafficEnabled = newState
    }
    
    @objc func stopIconTrafficLayerButtonToggle(_ button: UIButton) {
        let newState = !button.isSelected
        button.isSelected = newState
        self.mapView.isStopIconTrafficEnabled = newState
    }
    
    @objc func nonFreeFlowToggleTrafficLayers(_ button: UIButton) {
        let newState = !button.isSelected
        button.isSelected = newState
        mapView.isNonFreeFlowTrafficEnabled = newState
    }
    
}

extension MapplsTrafficVectorTilesViewController : MapplsMapViewDelegate {

    func didSetMapplsMapStyle(_ mapView: MapplsMapView, isSuccess: Bool, withError error: Error?) {
        print(isSuccess)
    }
    
    func didLoadedMapplsMapStyles(_ mapView: MapplsMapView, styles: [MapplsMapStyle], withError error: Error?) {
        

    }

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    }
     func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
         return true
     }

    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
           return 1
       }

       func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
           return .black
       }

       func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
           return 1
       }

}
