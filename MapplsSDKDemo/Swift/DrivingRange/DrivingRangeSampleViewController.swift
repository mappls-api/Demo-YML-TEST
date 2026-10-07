//
//  ViewController.swift
//  DrivingRangeExample-Swift
//
//  Created by Robin  on 07/10/21.
//  Copyright © 2022 Mappls. All rights reserved.
//

import UIKit
import MapplsMap
import MapplsDrivingRangePlugin

class DrivingRangeSampleViewController: UIViewController {

    var mapView: MapplsMapView!
    let progressHUD = ProgressHUD(text: "Loading..")
    var drivingRangePlugin: MapplsDrivingRange!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView = MapplsMapView(frame: self.view.bounds)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.delegate = self
        self.view.addSubview(self.mapView)
        self.view.addSubview(progressHUD)
//        progressHUD.hide()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        self.drivingRangePlugin = MapplsDrivingRange(mapView: self.mapView)
        self.drivingRangePlugin.delegate = self
        
        let settingBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(settingsButtonPressed(_:)))
        
        let clearBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(clearDrivingRange(_:)))
        
        self.navigationItem.rightBarButtonItems = [clearBarButtonItem, settingBarButtonItem]
        
        let settingsBarButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonTapped))
        self.navigationItem.rightBarButtonItems = [settingsBarButton]
    }

    let vc =  DrivingRangeSettingViewController(nibName: nil, bundle: nil)
    @objc func settingsButtonTapped(sender: UIBarButtonItem) {
//        drivingRangePlugin.clearDrivingRangeFromMap()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
//        updateDrivingRange()
    }
    @objc func settingsButtonPressed(_ sender: UIBarButtonItem) {
        updateDrivingRange()
    }
    
    func updateDrivingRange() {
        let location = CLLocation(latitude: 28.612972, longitude: 77.233529)
        
        let contours = [MapplsDrivingRangeContour(value: 15)]
        let rangeInfo = MapplsDrivingRangeRangeTypeInfo(rangeType: .time, contours: contours)
        
        let speedInfo1 = MapplsDrivingRangeOptimalSpeed()
        
        let drivingRangeOptions = MapplsDrivingRangeOptions(location: location, rangeTypeInfo: rangeInfo, speedTypeInfo: speedInfo1)
        drivingRangeOptions.isShowLocations = true
        self.drivingRangePlugin.isSetMapBoundForDrivingRangeOnLaunch = false
        self.drivingRangePlugin.getAndPlotDrivingRange(options: drivingRangeOptions)
    }
    
    @objc func clearDrivingRange(_ sender: UIBarButtonItem) {
        drivingRangePlugin.clearDrivingRangeFromMap()
    }

}

extension DrivingRangeSampleViewController: MapplsMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let location = CLLocation(latitude: 28.551060, longitude: 77.268989)
        
        let aa = [MapplsDrivingRangeContour(value: 25)]
        let rangeInfo = MapplsDrivingRangeRangeTypeInfo(rangeType: .time, contours: aa)
        
        let spe = MapplsDrivingRangeOptimalSpeed()
        
        let drivingRangeOptions = MapplsDrivingRangeOptions(location: location, rangeTypeInfo: rangeInfo, speedTypeInfo: spe)
        
        self.drivingRangePlugin.getAndPlotDrivingRange(options: drivingRangeOptions)
    }
}


extension DrivingRangeSampleViewController: MapplsDrivingRangeDelegate {
    func drivingRange(_ plugin: MapplsDrivingRange, didFailToGetAndPlotDrivingRange error: Error) {
        print("drivingRange: didFailToGetAndPlotDrivingRange: \(error.localizedDescription)")
        let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alertAction) in
            self.dismiss(animated: false, completion: nil)
        }))
        self.present(alertController, animated: false, completion: nil)
        progressHUD.hide()
    }
    
    func drivingRangeDidSuccessToGetAndPlotDrivingRange(_ plugin: MapplsDrivingRange) {
        print("drivingRange: drivingRangeDidSuccessToGetAndPlotDrivingRange")
       
        progressHUD.hide()
    }
    
    func drivingRangePolygonStyleLayer(_ plugin: MapplsDrivingRange) -> MGLFillStyleLayer? {
        let fillLayer = MGLFillStyleLayer(identifier: "Random", source: MGLShapeSource(identifier: "random"))
        fillLayer.fillColor = NSExpression(forConstantValue: UIColor.red)
        fillLayer.fillOpacity = NSExpression(forConstantValue: 0.5)
        //fillLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor.black)
        return fillLayer
    }

    func drivingRangePolylineStyleLayer(_ plugin: MapplsDrivingRange) -> MGLLineStyleLayer? {
        let lineLayer = MGLLineStyleLayer(identifier: "rail-line", source: MGLShapeSource(identifier: "rail-line"))
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.gray)
        lineLayer.lineWidth = NSExpression(forConstantValue: 5)
        return lineLayer
    }
}
extension DrivingRangeSampleViewController: DrivingRangeSettingViewControllerDelegate {
    func locationsPikcedForDirectionsUI(options: MapplsDrivingRangeOptions) {
        progressHUD.show()
        if let _ = mapView.style {
            self.drivingRangePlugin.getAndPlotDrivingRange(options: options)
        }
    }
}


class ProgressHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}
