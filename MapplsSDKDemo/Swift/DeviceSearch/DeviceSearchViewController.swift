//
//  DeviceSearchViewController.swift
//  MapplsSDKDemo
//
//  Created by ceinfo on 31/01/24.
//  Copyright © 2024 MMI. All rights reserved.
//

import UIKit
import MapplsUIWidgets
class DeviceSearchViewController: UIViewController {
    var textField: UITextField!
    let progressHUD = ProgressHUD(text: "Loading..")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextFeild()
        self.view.addSubview(progressHUD)
        progressHUD.hide()
    }
    
    func setupTextFeild() {
        textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.text = "testce00098618"
        textField.placeholder = "Enter Cluster Id"
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        textField.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        let searchButton = UIButton()
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        searchButton.layer.cornerRadius = 5
        searchButton.backgroundColor = .gray
        searchButton.setTitle("Search", for: .normal)
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
    }
    
    @objc func searchButtonAction() {
        textField.resignFirstResponder()
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        sheetViewController?.attemptDismiss(animated: true)
        self.progressHUD.show()
        let options = MapplsDeviceSearchOptions(query: "ClusterId")
        
        MapplsDeviceSearchManager.shared.getDeviceSearchResult(options) { response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let response = response, let results = response.deviceSearchResult else {
                    return
                }
                print(results.first?.entityName)
            }
        }
        
        
        print(text)
        var tableDict1  : [[[String : Any]] ] = [[[String : Any]]]()
        MapplsDeviceSearchManager.shared.getDeviceSearchResult(options) { resposnse, error in
            
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alertAction) in
                    self.dismiss(animated: false, completion: nil)
                }))
                self.present(alertController, animated: false, completion: nil)
            } else {
                guard let resposnse = resposnse, let results = resposnse.deviceSearchResult else {
                    return
                }
                
                for result in results {
                    var tableDict  : [[String : Any]] = [[String : Any]]()
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(result)
                        let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                        guard let dictionary = json as? [String : AnyObject] else {
                            return
                        }
                        let _ = dictionary.keys.map({ key in
                            if let value = dictionary[key] {
                                tableDict.append(["\(key)":"\(value)"])
                            }
                        })
                        
                        tableDict1.append(tableDict)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                

            }
            
            DispatchQueue.main.async {
                if tableDict1.count > 0  {
                    self.openBottomController(tableDict: tableDict1)
                }
                self.progressHUD.hide()
            }
        }
    }
    
    var sheetViewController : MapplsSheetViewController?
    func openBottomController(tableDict: [[[String : Any]] ]) {
        let vc = DeviceTableViewController()
        vc.tableDict = tableDict
        sheetViewController = openSheetViewController(from: self, in: self.view, controller: vc, size: [.percent(0.5), .fullscreen])
    }
    
    func openSheetViewController(from parent: UIViewController, in view: UIView?, controller: UIViewController, size: [SheetSize], sheetOptions: MapplsSheetOptions? = nil ) -> MapplsSheetViewController {
        let useInlineMode = view != nil
        
        var options = MapplsSheetOptions(useInlineMode: useInlineMode)
//        options.pullBarHeight = 0
//        options.presentingViewCornerRadius = 0
        
        if let sheetOptions = sheetOptions {
            options = sheetOptions
        }
        let sheet = MapplsSheetViewController(
            controller: controller,
            sizes: size,
            options: options)
        sheet.allowPullingPastMaxHeight = false
        
        sheet.allowPullingPastMinHeight = false
//        sheet.dismissOnPull = false
        sheet.dismissOnOverlayTap = true
//        sheet.overlayColor = UIColor.clear
//        sheet.pullBarBackgroundColor = .clear
//        sheet.allowGestureThroughOverlay = true
        
        sheet.cornerRadius = 0
        if let view = view {
            sheet.animateIn(to: view, in: parent)
        } else {
            parent.present(sheet, animated: true, completion: nil)
        }
        return sheet
    }

}
