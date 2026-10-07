import UIKit

class PredictiveRouteManeuverCell: UITableViewCell {

    var instructionLabel: UILabel!
    
    var bottomContainerView: UIStackView!
    var timeLabel: UILabel!
    var distanceLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
    
    func setupViews(){
        bottomContainerView = UIStackView()
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.distribution = .fillEqually
        bottomContainerView.alignment = .fill
        bottomContainerView.axis = .horizontal
        self.addSubview(bottomContainerView)
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "Style Name descriptions wiht is te"
        timeLabel.numberOfLines = 0
        timeLabel.textColor = .black
        self.bottomContainerView.addArrangedSubview(timeLabel)
        
        distanceLabel = UILabel()
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.text = "Style Name descriptions wiht is te"
        distanceLabel.numberOfLines = 0
        distanceLabel.textColor = .black
        self.bottomContainerView.addArrangedSubview(distanceLabel)
        
        instructionLabel = UILabel()
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.text = "Style Name"
        instructionLabel.textColor = .black
        instructionLabel.numberOfLines = 0
        instructionLabel.font = .boldSystemFont(ofSize: 17)
        self.addSubview(instructionLabel)
        
        bottomContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        bottomContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        bottomContainerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        instructionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        instructionLabel.bottomAnchor.constraint(equalTo: self.bottomContainerView.topAnchor, constant: -8).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        instructionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
}
