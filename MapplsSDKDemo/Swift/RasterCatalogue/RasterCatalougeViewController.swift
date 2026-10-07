//
//  RasterCatalougeViewController.swift
//  MapplsSDKDemo
//
//  Created by CE00120420 on 18/07/22.
//  Copyright © 2022 MMI. All rights reserved.
//
import UIKit
import MapplsMap
import MapplsRasterCatalogue

class RasterCatalougeViewController: UIViewController {
    var mapView: MapplsMapView!
    var bottomBannerStyleView = UIView()
    var layerArray = [MapplsRasterCatalogueLayerOptions]()
    var tableView = UITableView()
    var isDown = true
    var switchHolder = UIView()
    var swit = UISwitch()
    var switchLable = UILabel()
    var rasterCataloguePlugin : MapplsRasterCataloguePlugin!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MapplsMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(mapView)
        mapView.zoomLevel = 5
        createGeoanalyticsLayerArray()
        let coordinate = CLLocationCoordinate2D(latitude: 28.5354, longitude: 77.2639)
        mapView.setCenter(coordinate, animated: false)
        setupBottomBannerStyleView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(showDataSourcesList))

        rasterCataloguePlugin = MapplsRasterCataloguePlugin(mapView: mapView)
        
        setupTableView()
        
    }

    @objc func showDataSourcesList () {
        if isDown {
            UIView.animate(withDuration: 1) {
                self.bottomBannerStyleView.transform = CGAffineTransform(translationX: 0, y: -self.tableView.contentSize.height)
            }
            navigationItem.rightBarButtonItem?.title = "Hide Sheet"
            isDown = false
        }  else {
            UIView.animate(withDuration: 1) {
                self.bottomBannerStyleView.transform = CGAffineTransform(translationX: 0, y: 10)
            }
            navigationItem.rightBarButtonItem?.title = "Show Sheet"
            isDown = true
        }
    }
    
    func setupBottomBannerStyleView() {
        self.view.addSubview(bottomBannerStyleView)
        bottomBannerStyleView.translatesAutoresizingMaskIntoConstraints = false
        bottomBannerStyleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomBannerStyleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomBannerStyleView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
        bottomBannerStyleView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        bottomBannerStyleView.backgroundColor = .white
        let panGestureReconizor = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
        bottomBannerStyleView.addGestureRecognizer(panGestureReconizor)
    }
    
    func createGeoanalyticsLayerArray() {
        //  MARK:- International Boundary 25 KM
        let layerRequestInternationalBoundary25KM = MapplsRasterCatalogueLayerOptions(layerType: .internationalBoundary25KM)
        layerRequestInternationalBoundary25KM.transparent = true
        
        layerArray.append(layerRequestInternationalBoundary25KM)
        
        // MARK:- Airport 0 To 5 KM
        let layerRequestAirport0To5KM = MapplsRasterCatalogueLayerOptions(layerType: .airport0To5KM)
        layerRequestAirport0To5KM.transparent = true
        layerArray.append(layerRequestAirport0To5KM)
        
        // MARK:- Airport 5 To 8 KM
        let layerRequestAirport5To8KM = MapplsRasterCatalogueLayerOptions(layerType: .airport5To8KM)
        layerRequestAirport5To8KM.transparent = true
        layerArray.append(layerRequestAirport5To8KM)
        
        
        //  MARK:- Airport 8 To 12 KM Yellow
        let layerRequestAirport8To12KMYellow = MapplsRasterCatalogueLayerOptions(layerType: .airport8To12KMYellow)
        layerRequestAirport8To12KMYellow.transparent = true;
        layerArray.append(layerRequestAirport8To12KMYellow)
    }
    
    func setupTableView() {
        self.bottomBannerStyleView.addSubview(tableView)
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.bottomBannerStyleView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.bottomBannerStyleView.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.bottomBannerStyleView.topAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomBannerStyleView.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .began {
            if isDown {
                UIView.animate(withDuration: 1) {
                    self.bottomBannerStyleView.transform = CGAffineTransform(translationX: 0, y: -self.tableView.contentSize.height)
                }
                navigationItem.rightBarButtonItem?.title = "Hide Sheet"
                isDown = false
            } else {
                UIView.animate(withDuration: 1) {
                    self.bottomBannerStyleView.transform = CGAffineTransform(translationX: 0, y: 10)
                }
                navigationItem.rightBarButtonItem?.title = "Show Sheet"
                isDown = true
            }
        }
    }

    @objc func switchChanged(_ sender : UISwitch) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let request = layerArray[indexPath.row]
        if sender.isOn {
            self.rasterCataloguePlugin.addRasterCatalogueLayer(request)
        } else if !sender.isOn {
            rasterCataloguePlugin.removeRasterCatalogueLayer(request)
        }
        
    }

}
extension RasterCatalougeViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
    }
}

extension RasterCatalougeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "switchCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            if let accessoryView = cell.accessoryView, accessoryView.isKind(of: UISwitch.self) {
                let switchView = accessoryView as! UISwitch
                switchView.tag = indexPath.row
            }
            return cell
        } else {
            let newCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            newCell.textLabel?.text = "\(layerArray[indexPath.row].layerType.rawValue)"
            let switchView = UISwitch(frame: .zero)
            switchView.tag = indexPath.row // for detect which row switch Changed
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            newCell.accessoryView = switchView
            return newCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

