import Foundation

@objc internal class CustomUISwitch : UISwitch {
    @objc public var tableRowIndexPath: IndexPath? = nil
}

@objc internal class CustomUIStepper : UIStepper {
    @objc public var tableRowIndexPath: IndexPath? = nil
}

@objc internal class CustomUITextField : UITextField {
    @objc public var tableRowIndexPath: IndexPath? = nil
}

@objc internal class CustomUIButton : UIButton {
    @objc public var tableRowIndexPath: IndexPath? = nil
}

class LocationPickerTableCell: UITableViewCell {
    var autocompleteWidgetButton: CustomUIButton!
    var locationTextField = CustomUITextField()
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        locationTextField = CustomUITextField()
        locationTextField.placeholder = ""
        //locationTextField.isHidden = true
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationTextField)
        
        autocompleteWidgetButton = CustomUIButton()
        autocompleteWidgetButton.setTitle("", for: .normal)
        autocompleteWidgetButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(autocompleteWidgetButton)
    }
    
    func setupConstraints() {
        locationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        locationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        locationTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        locationTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        
        autocompleteWidgetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        autocompleteWidgetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        autocompleteWidgetButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        autocompleteWidgetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
