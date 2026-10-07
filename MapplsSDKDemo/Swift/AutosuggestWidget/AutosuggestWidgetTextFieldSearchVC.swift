import Foundation
import MapplsUIWidgets

class AutosuggestWidgetTextFieldSearchVC: UIViewController {

    weak var delegate: AutosuggestWidgetDelegate?
    
    var searchField: UITextField!
    var tableViewController: UITableViewController!
    var tableDataSource: MapplsAutocompleteTableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        searchField = UITextField(frame: CGRect.zero)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.borderStyle = .none
        searchField.backgroundColor = UIColor.white
        searchField.placeholder = NSLocalizedString("Demo.Content.Autocomplete.EnterTextPrompt", comment: "Prompt to enter text for autocomplete demo")
        searchField.autocorrectionType = .no
        searchField.keyboardType = .default
        searchField.returnKeyType = .done
        searchField.clearButtonMode = .whileEditing
        searchField.contentVerticalAlignment = .center
        searchField.becomeFirstResponder()
        
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchField.delegate = self
        
        // Setup the results view controller.
        tableDataSource = MapplsAutocompleteTableDataSource()
        let attributionSetting = MapplsAttributionsSettings()
        attributionSetting.attributionSize = MapplsContentSize(rawValue: UserDefaultsManager.attributionSize) ?? .medium
        attributionSetting.attributionHorizontalContentAlignment = MapplsHorizontalContentAlignment(rawValue: Int(UserDefaultsManager.attributionHorizontalAlignment)) ?? .center
        attributionSetting.attributionVerticalPlacement = MapplsVerticalPlacement(rawValue: UserDefaultsManager.attributionVerticalPlacement) ?? .before
        attributionSetting.attributionLogoType = MapplsAttributionLogoType(rawValue: UserDefaultsManager.attributionLogoType) ?? .auto
        tableDataSource.attributionSettings = attributionSetting
        tableDataSource.delegate = self
        tableDataSource.autocompleteFilter = getAutocompleteFilter()
        
        tableViewController = UITableViewController(style: .plain)
        tableViewController.tableView.delegate = tableDataSource
        tableViewController.tableView.dataSource = tableDataSource

        view.addSubview(searchField)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[searchField]-|", options: [], metrics: nil, views: [
            "searchField" : self.searchField!
        ]))
        NSLayoutConstraint(item: searchField!, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField?) {
        tableDataSource.sourceTextHasChanged(textField?.text)
    }
    
    func dismissResultsController() {
        // Dismiss the results.
        tableViewController.willMove(toParent: nil)
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewController.view.alpha = 0.0
        }) { finished in
            self.tableViewController.view.removeFromSuperview()
            self.tableViewController.removeFromParent()
        }
    }
    
    func getAutocompleteFilter() -> MapplsAutocompleteFilter {
        let autocompleteFilter = MapplsAutocompleteFilter()
        return autocompleteFilter
    }
}

extension AutosuggestWidgetTextFieldSearchVC: MapplsAutocompleteTableDataSourceDelegate {
    func didAutocomplete(tableDataSource: MapplsUIWidgets.MapplsAutocompleteTableDataSource, withFavouritePlace place: MapplsUIWidgets.MapplsUIWidgetAutosuggestFavouritePlace) {
        
    }
    
    func didAutocomplete(tableDataSource: MapplsAutocompleteTableDataSource, withPlace place: MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType) {
        dismissResultsController()
        searchField.resignFirstResponder()
        searchField.isHidden = true
        delegate?.autocompleteDidSelect(viewController: self, place: place)
    }
    

    func didFailAutocomplete(tableDataSource: MapplsAutocompleteTableDataSource, withError error: NSError) {
        dismissResultsController()
        searchField.resignFirstResponder()
        searchField.text = ""
        delegate?.autocompleteDidFail(viewController: self, error: error)
    }
    
    func didRequestAutocompletePredictionsFor(tableDataSource: MapplsAutocompleteTableDataSource) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        tableViewController.tableView.reloadData()
    }
    
    func didUpdateAutocompletePredictionsForTableDataSource(tableDataSource: MapplsAutocompleteTableDataSource) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        tableViewController.tableView.reloadData()
    }
    func didAutocomplete(tableDataSource: MapplsAutocompleteTableDataSource, withSuggestion suggestion: MapplsSearchPrediction) {
        
    }
}

extension AutosuggestWidgetTextFieldSearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addChild(tableViewController)

        // Add the results controller.
        tableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        tableViewController.view.alpha = 0.0
        view.addSubview(tableViewController.view)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[_searchField]-[resultView]-(0)-|", options: [], metrics: nil, views: [
            "_searchField": self.searchField!,
            "resultView": self.tableViewController.view!
        ]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[resultView]-(0)-|", options: [], metrics: nil, views: [
            "resultView": self.tableViewController.view!
        ]))
        
        view.layoutIfNeeded()

        // Reload the data.
        tableViewController.tableView.reloadData()

        // Animate in the results.
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewController.view.alpha = 1.0
        }) { finished in
            self.tableViewController.didMove(toParent: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        dismissResultsController()
        textField.resignFirstResponder()
        textField.text = ""
        tableDataSource.clearResults()
        return false
    }
}
