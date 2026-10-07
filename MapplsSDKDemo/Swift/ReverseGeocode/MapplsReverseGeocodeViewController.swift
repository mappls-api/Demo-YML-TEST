//
//  MapplsReverseGeocodeViewController.swift
//  MapplsSDKDemo
//
//  Created by CE00120420 on 21/07/22.
//  Copyright © 2022 MMI. All rights reserved.
//

import UIKit
import MapplsMap
import MapplsAPIKit
import MapplsAPICore
class MapplsReverseGeocodeViewController: UIViewController {
    var mapplsMapView : MapplsMapView!
    
    var bottomBannerStyleView = UIView()
    var tableView = UITableView()
    var isDown = true
    
    var tableDict  : [[String : Any]] = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
            
        mapplsMapView = MapplsMapView(frame: view.bounds)
        view.addSubview(mapplsMapView)
        
        mapplsMapView.setMapCenterAtMapplsPin("mmi000", animated: false, completionHandler: nil)
        mapplsMapView.zoomLevel = 11
        
        
        mapplsMapView.translatesAutoresizingMaskIntoConstraints = false
        mapplsMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapplsMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapplsMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapplsMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
        let singleTap = UITapGestureRecognizer(target: self, action:
            #selector(didTapMap(tap:)))
        mapplsMapView.addGestureRecognizer(singleTap)
        
        setupBottomBannerStyleView()
        setupTableView()
        
        self.view.addSubview(progressHUD)
        progressHUD.hide()
    }
 
    @objc func showStyle () {
        if isDown {
            UIView.animate(withDuration: 1) {
                self.bottomBannerStyleView.transform = CGAffineTransform(translationX: 0, y: -450)
            }
            navigationItem.rightBarButtonItem?.title = "Hide info"
            isDown = false
        }  else {
            UIView.animate(withDuration: 1) {
                self.bottomBannerStyleView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            navigationItem.rightBarButtonItem?.title = "Show info"
            isDown = true
        }
    }
    
    func setupBottomBannerStyleView() {
        self.view.addSubview(bottomBannerStyleView)
        bottomBannerStyleView.translatesAutoresizingMaskIntoConstraints = false
        bottomBannerStyleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomBannerStyleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomBannerStyleView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        bottomBannerStyleView.heightAnchor.constraint(equalToConstant: 550).isActive = true
        bottomBannerStyleView.backgroundColor = .white
        let panGestureReconizor = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
        bottomBannerStyleView.addGestureRecognizer(panGestureReconizor)
        
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {

        if recognizer.state == .began {
            if isDown {
                UIView.animate(withDuration: 1) {
                    self.bottomBannerStyleView.transform = CGAffineTransform(translationX: 0, y: -450)
                }
                 navigationItem.rightBarButtonItem?.title = "Hide Styles Sheet"
                isDown = false
            } else {
                UIView.animate(withDuration: 1) {
                    self.bottomBannerStyleView.transform = CGAffineTransform(translationX: 0, y: 0)
                }
                 navigationItem.rightBarButtonItem?.title = "Show Styles Sheet"
                isDown = true
            }
        }
    }
    
    func setupTableView() {
        self.bottomBannerStyleView.addSubview(tableView)
        bottomBannerStyleView.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.bottomBannerStyleView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.bottomBannerStyleView.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.bottomBannerStyleView.topAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomBannerStyleView.bottomAnchor, constant: -100).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DemoMapStyleTableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    let progressHUD = ProgressHUD(text: "Loading..")
    @objc func didTapMap(tap: UITapGestureRecognizer) {
        tableDict.removeAll()
        self.mapplsMapView.removeAnnotations(self.mapplsMapView.annotations ??  [MGLAnnotation]())
        if tap.state == .ended {
            let location = tap.location(in: mapplsMapView)
            let coordinate = mapplsMapView.convert(location,toCoordinateFrom: mapplsMapView)
            
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = "reverseGeocode"
            self.mapplsMapView.addAnnotation(point)
            
            let reverseGeocodeManager = MapplsReverseGeocodeManager.shared
            let revOptions = MapplsReverseGeocodeOptions(coordinate:
                                                            coordinate)
            reverseGeocodeManager.reverseGeocode(revOptions) { (placemarks,
                                                                attribution, error) in
                if let error = error {
                    self.isDown = false
                    self.showStyle()
                    self.progressHUD.hide()
                    NSLog("%@", error)
                } else if let placemarks = placemarks, !placemarks.isEmpty {
                   do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(placemarks)
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        guard let dictionary = json as? [[String : Any]] else {
                            return
                        }
                       guard let dd = dictionary.first else {
                           return
                       }
                        let _ = dd.keys.map({ key in
                            if let value = dd[key] as? String {
                                self.tableDict.append(["\(key)":"\(value)"])
                            }
                        })
                       
                        self.isDown = true
                        self.showStyle()
                        self.progressHUD.hide()
                        self.tableView.reloadData()
                        
                   } catch {
                       self.isDown = false
                       self.showStyle()
                       self.progressHUD.hide()
                   }
                    
                } else {
                    self.isDown = false
                    self.showStyle()
                    self.progressHUD.hide()
                    print("No results")
                }
            }
        }
    }
    
}

extension MapplsReverseGeocodeViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDict.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var tableCell: UITableViewCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            tableCell = cell
        }else {
            tableCell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        if tableDict.indices.contains(indexPath.row), let key = tableDict[indexPath.row].keys.first , let value =  tableDict[indexPath.row].values.first{
            tableCell.textLabel?.text = "\(key)"
            tableCell.detailTextLabel?.text = "\(value)"
        }
        return tableCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
