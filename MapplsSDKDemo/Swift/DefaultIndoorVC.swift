//
//  DefaultIndoorVC.swift
//  POCMapStyles
//
//  Created by apple on 04/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import MapplsMap
import MapplsAPIKit

class DefaultIndoorVC: UIViewController {

    var mapView: MapplsMapView!
    
    let vasantKunjLocation = CLLocationCoordinate2DMake(28.542568, 77.155914)
    let bangaloreExpoLocation = CLLocationCoordinate2DMake(13.062946, 77.474959)
    
    var indoorPlugin:MapplsMapViewIndoorPlugin?
    var indoorSelecorView: MapplsIndoorSelectorView?
    @IBOutlet weak var indoorButton: UIButton!
    
    @IBAction func indoorButtonTapped(_ sender: UIButton) {
        indoorButton.isSelected = !indoorButton.isSelected
        MapplsAccountManager.setIndoorEnabled(indoorButton.isSelected)
    }
    
    @IBOutlet weak var vasantKunjLocationButton: UIButton!
    
    @IBAction func vasantKunjLocationButtonTapped(_ sender: UIButton) {
        setVasantKunjLocation()
    }
    
    @IBOutlet weak var bangaloreExpoLocationButton: UIButton!
    
    @IBAction func bangaloreExpoLocationButtonTapped(_ sender: UIButton) {
        setBangaloreExpoLocation()
    }
    
    func setVasantKunjLocation() {
        mapView.setCenter(vasantKunjLocation, zoomLevel: 18, animated: false)
    }
    
    func setBangaloreExpoLocation() {
        mapView.setCenter(bangaloreExpoLocation, zoomLevel: 18, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Default Indoor"
        mapView = MapplsMapView(frame: view.bounds)
        mapView.showsUserLocation = true
        mapView.minimumZoomLevel = 3
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
        view.bringSubviewToFront(indoorButton)
        view.bringSubviewToFront(vasantKunjLocationButton)
        view.bringSubviewToFront(bangaloreExpoLocationButton)
        
        indoorButton.isSelected = MapplsAccountManager.indoorEnabled()
    }
}

extension DefaultIndoorVC: MapplsMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        setVasantKunjLocation()
    }  
}
