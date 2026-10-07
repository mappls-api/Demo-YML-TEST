class MapplsTrackingSample: UIViewController {
    
    var settingButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTrackingButton()
//        setSettingModeButton()
    }
    
//    func setSettingModeButton() {
//        view.addSubview(settingButton)
//        settingButton.setTitle("Setting", for: .normal)
//        settingButton.addTarget(self, action: #selector(settingMode(sender:)), for: .touchUpInside)
//        settingButton.backgroundColor = .gray
//        settingButton.setTitleColor(.white, for: .normal)
//        settingButton.translatesAutoresizingMaskIntoConstraints = false
//        settingButton.layer.cornerRadius = 5
//        
//        settingButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
//        settingButton.topAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 20).isActive = true
//        
//        settingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        settingButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
//    }
    
    var button = UIButton()
    func setTrackingButton() {
        
        view.addSubview(button)
        button.setTitle("Open Tracking mode", for: .normal)
        button.addTarget(self, action: #selector(enableTracking(sender:)), for: .touchUpInside)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        
        button.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    
    @objc func enableTracking(sender: UIButton) {
        let mapRouteController = MapRouteViewController()
        self.navigationController?.pushViewController(mapRouteController, animated: false)
    }
    
//    @objc func settingMode(sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let vc = storyboard.instantiateViewController(withIdentifier: "MapplsSettingsVC") as? MapplsSettingsVC {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
}
