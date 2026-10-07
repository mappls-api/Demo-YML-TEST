//
//  ItemPickerViewController.swift
//  MapplsSDKDemo
//
//  Created by Robin on 17/09/24.
//  Copyright © 2024 MMI. All rights reserved.
//

import UIKit

enum PickerViewType {
    case logoType
}

protocol ItemPickerViewControllerDelegate: AnyObject {
    func itemSelected(sender: ItemPickerViewController, item: Int)
}

class ItemPickerViewController: UIViewController {
    var delegate: ItemPickerViewControllerDelegate?
    
    private var pickerView: UIPickerView?
    
    private var pickerViewTextField: UITextField?
    
    private var toolbarView: UIToolbar?
    
    internal private(set) var pickerViewType: PickerViewType!
    
    private var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    private let logoTypes = ["Auto", "Mappls|MapmyIndia", "Mappls", "MapmyIndia"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    required init(pickerViewType: PickerViewType) {
        super.init(nibName: nil, bundle: nil)
        self.pickerViewType = pickerViewType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.3)
        
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.toolBarDoneButtonClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.toolBarCancelButtonClicked))
        
        
        let toolbarView = UIToolbar()
        toolbarView.barStyle = .default
        toolbarView.isTranslucent = true
        toolbarView.items = [cancelButton, spaceButton, btnDone]
        toolbarView.sizeToFit()
        self.toolbarView = toolbarView
        
        let pickerView: UIPickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        self.pickerView = pickerView
        
        let pickerViewTextField = UITextField()
        pickerViewTextField.inputView = pickerView
        pickerViewTextField.inputAccessoryView = toolbarView
        self.view.addSubview(pickerViewTextField)
        self.pickerViewTextField = pickerViewTextField
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let pickerViewTextField = pickerViewTextField else { return }
        
        pickerViewTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let pickerViewTextField = pickerViewTextField else { return }
        
        pickerViewTextField.resignFirstResponder()
    }
    
    @objc func toolBarDoneButtonClicked() {
        guard let _ = pickerView else { return }
        
        if selectedIndexPath.section == 0 {
            let selectedRow = selectedIndexPath.row
            //let selectedLogoType = logoTypes[selectedRow]
            delegate?.itemSelected(sender: self, item: selectedRow)
            self.dismiss(animated: true)
        }
    }
    
    @objc func toolBarCancelButtonClicked() {
        self.dismiss(animated: true)
    }
}

extension ItemPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerViewType {
        case .logoType:
            return logoTypes.count
        default:
            return 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerViewType {
        case .logoType:
            let logoType = logoTypes[row]
            return logoType
        default:
            return nil
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         selectedIndexPath = IndexPath(row: row, section: component)
    }
}
