import UIKit
import MapplsUIWidgets

class AutosuggestCustomUISearchControllerVC: UIViewController {

    weak var delegate: AutosuggestWidgetDelegate?
    var searchController: UISearchController?
    var resultsViewController: MapplsAutocompleteResultsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
        
        resultsViewController = MapplsAutocompleteResultsViewController()
        resultsViewController?.autocompleteFilter = getAutocompleteFilter()
        resultsViewController?.delegate = self
        let attributionSetting = MapplsAttributionsSettings()
        attributionSetting.attributionSize = MapplsContentSize(rawValue: UserDefaultsManager.attributionSize) ?? .medium
        attributionSetting.attributionHorizontalContentAlignment = MapplsHorizontalContentAlignment(rawValue: Int(UserDefaultsManager.attributionHorizontalAlignment)) ?? .center
        attributionSetting.attributionVerticalPlacement = MapplsVerticalPlacement(rawValue: UserDefaultsManager.attributionVerticalPlacement) ?? .before
        attributionSetting.attributionLogoType = MapplsAttributionLogoType(rawValue: UserDefaultsManager.attributionLogoType) ?? .auto
        resultsViewController?.attributionSettings = attributionSetting
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = true

        searchController?.searchBar.autoresizingMask = .flexibleWidth
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.delegate = self
        searchController?.searchBar.accessibilityIdentifier = "searchBarAccessibilityIdentifier"
        searchController?.searchBar.sizeToFit()
        
        navigationItem.titleView = searchController?.searchBar
        definesPresentationContext = true

        // Work around a UISearchController bug that doesn't reposition the table view correctly when
        // rotating to landscape.
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true

        searchController?.searchResultsUpdater = resultsViewController
        if UI_USER_INTERFACE_IDIOM() == .pad {
            searchController?.modalPresentationStyle = .popover
        } else {
            searchController?.modalPresentationStyle = .fullScreen
        }
        
        searchController?.isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchController?.searchBar.becomeFirstResponder()
        }
    }
    
    func getAutocompleteFilter() -> MapplsAutocompleteFilter {
        let autocompleteFilter = MapplsAutocompleteFilter()
        return autocompleteFilter
    }
}

extension AutosuggestCustomUISearchControllerVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController?.isActive = false
        searchController?.searchBar.isHidden = true
        if self.parent is UINavigationController {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        delegate?.autocompleteDidCancel(viewController: self)
    }
}

extension AutosuggestCustomUISearchControllerVC: MapplsAutocompleteResultsViewControllerDelegate {
    func didAutocomplete(resultsController: MapplsUIWidgets.MapplsAutocompleteResultsViewController, withFavouritePlace place: MapplsUIWidgets.MapplsUIWidgetAutosuggestFavouritePlace) {
        
    }
    
    func didAutocomplete(resultsController: MapplsAutocompleteResultsViewController, withPlace place: MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType) {
        // Display the results and dismiss the search controller.
        searchController?.isActive = false
        searchController?.searchBar.resignFirstResponder()
        searchController?.dismiss(animated: true, completion: {
            self.delegate?.autocompleteDidSelect(viewController: self, place: place)
        })
    }
    
    func didFailAutocomplete(resultsController: MapplsAutocompleteResultsViewController, withError error: NSError) {
        searchController?.isActive = false
        searchController?.searchBar.resignFirstResponder()
        searchController?.dismiss(animated: true, completion: {
            self.delegate?.autocompleteDidFail(viewController: self, error: error)
        })
    }
    
    func didRequestAutocompletePredictionsForResultsController(resultsController: MapplsAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsFor(resultsController: MapplsAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func didAutocomplete(resultsController: MapplsAutocompleteResultsViewController, withSuggestion suggestion: MapplsSearchPrediction) {
        
    }
    
    
}


