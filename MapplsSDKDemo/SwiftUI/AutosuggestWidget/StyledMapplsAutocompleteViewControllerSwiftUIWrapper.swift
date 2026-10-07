import SwiftUI
import MapplsUIWidgets

struct StyledMapplsAutocompleteViewControllerSwiftUIView: View {
    @Binding var placeSuggestion: MapplsAtlasSuggestion?
    
    @State var withBackgroundColor: UIColor
    @State var selectedTableCellBackgroundColor: UIColor
    @State var darkBackgroundColor: UIColor
    @State var primaryTextColor: UIColor
    @State var highlightColor: UIColor
    @State var secondaryColor: UIColor
    @State var tintColor: UIColor
    @State var searchBarTintColor: UIColor
    @State var separatorColor: UIColor
    
    var body: some View {
        StyledMapplsAutocompleteViewControllerSwiftUIWrapper(placeSuggestion: $placeSuggestion, withBackgroundColor: $withBackgroundColor, selectedTableCellBackgroundColor: $selectedTableCellBackgroundColor, darkBackgroundColor: $darkBackgroundColor, primaryTextColor: $primaryTextColor, highlightColor: $highlightColor, secondaryColor: $secondaryColor, tintColor: $tintColor, searchBarTintColor: $searchBarTintColor, separatorColor: $separatorColor)
            .navigationBarHidden(true)
    }
}

struct StyledMapplsAutocompleteViewControllerSwiftUIWrapper: UIViewControllerRepresentable {

    @Binding var placeSuggestion: MapplsAtlasSuggestion?
    
    @Binding var withBackgroundColor: UIColor
    @Binding var selectedTableCellBackgroundColor: UIColor
    @Binding var darkBackgroundColor: UIColor
    @Binding var primaryTextColor: UIColor
    @Binding var highlightColor: UIColor
    @Binding var secondaryColor: UIColor
    @Binding var tintColor: UIColor
    @Binding var searchBarTintColor: UIColor
    @Binding var separatorColor: UIColor

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<StyledMapplsAutocompleteViewControllerSwiftUIWrapper>) -> MapplsAutocompleteViewController {
        UINavigationBar.appearance(whenContainedInInstancesOf: [DemoStyledAutocompleteViewController.self]).barTintColor = darkBackgroundColor
        UINavigationBar.appearance(whenContainedInInstancesOf: [DemoStyledAutocompleteViewController.self]).tintColor = searchBarTintColor
        
        // Color of typed text in search bar.
        let searchBarTextAttributes = [
            NSAttributedString.Key.foregroundColor: searchBarTintColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
        ]
        UITextField.appearance(whenContainedInInstancesOf: [DemoStyledAutocompleteViewController.self]).defaultTextAttributes = searchBarTextAttributes

        // Color of the "Search" placeholder text in search bar. For this example, we'll make it the same
        // as the bar tint color but with added transparency.
        let increasedAlpha = searchBarTintColor.cgColor.alpha * 0.75
        let placeHolderColor = searchBarTintColor.withAlphaComponent(increasedAlpha)
        
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: placeHolderColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)

        UITextField.appearance(whenContainedInInstancesOf: [DemoStyledAutocompleteViewController.self]).attributedPlaceholder = attributedPlaceholder

        // Change the background color of selected table cells.
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = selectedTableCellBackgroundColor
        let tableCellAppearance = UITableViewCell.appearance(whenContainedInInstancesOf: [DemoStyledAutocompleteViewController.self])
        tableCellAppearance.selectedBackgroundView = selectedBackgroundView
        
        let autocompleteViewController = DemoStyledAutocompleteViewController()
        
        autocompleteViewController.tableCellBackgroundColor = withBackgroundColor
        autocompleteViewController.tableCellSeparatorColor = separatorColor
        autocompleteViewController.primaryTextColor = primaryTextColor
        autocompleteViewController.primaryTextHighlightColor = highlightColor
        autocompleteViewController.secondaryTextColor = secondaryColor
        autocompleteViewController.tintColor = tintColor
        
        let attributionSetting = MapplsAttributionsSettings()
        attributionSetting.attributionSize = MapplsContentSize(rawValue: UserDefaultsManager.attributionSize) ?? .medium
        attributionSetting.attributionHorizontalContentAlignment = MapplsHorizontalContentAlignment(rawValue: Int(UserDefaultsManager.attributionHorizontalAlignment)) ?? .center
        attributionSetting.attributionVerticalPlacement = MapplsVerticalPlacement(rawValue: UserDefaultsManager.attributionVerticalPlacement) ?? .before
        attributionSetting.attributionLogoType = MapplsAttributionLogoType(rawValue: UserDefaultsManager.attributionLogoType) ?? .auto
        autocompleteViewController.delegate = context.coordinator
        autocompleteViewController.attributionSettings = attributionSetting
        autocompleteViewController.autocompleteFilter = MapplsAutocompleteFilter()
        return autocompleteViewController
    }

    func updateUIViewController(_ uiViewController: MapplsAutocompleteViewController, context: UIViewControllerRepresentableContext<StyledMapplsAutocompleteViewControllerSwiftUIWrapper>) {
        
    }

    static func dismantleUIViewController(_ uiViewController: MapplsAutocompleteViewController, coordinator: Coordinator) {
        if let navVC = uiViewController.navigationController {
            navVC.dismiss(animated: false)
        }
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, MapplsAutocompleteViewControllerDelegate {
        func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withFavouritePlace place: MapplsUIWidgets.MapplsUIWidgetAutosuggestFavouritePlace) {
            
        }
        
        var parent: StyledMapplsAutocompleteViewControllerSwiftUIWrapper
        
        init(_ parent: StyledMapplsAutocompleteViewControllerSwiftUIWrapper) {
            self.parent = parent
        }
        
        func didAutocomplete(viewController: MapplsAutocompleteViewController, withSuggestion suggestion: MapplsSearchPrediction) {
            
        }
        
        func didAutocomplete(viewController: MapplsAutocompleteViewController, withPlace place: MapplsAtlasSuggestion, resultType type: MapplsAutosuggestResultType) {
            DispatchQueue.main.async {
                print(place.description.description as Any)
                self.parent.presentationMode.wrappedValue.dismiss()
                self.parent.placeSuggestion = place
            }
        }
        
        func didFailAutocomplete(viewController: MapplsAutocompleteViewController, withError error: NSError) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(viewController: MapplsAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct StyledMapplsAutocompleteViewControllerSwiftUIWrapper_Previews: PreviewProvider {
    static let withBackgroundColor = UIColor(red: 215.0 / 255.0, green: 204.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    static let selectedTableCellBackgroundColor = UIColor(red: 236.0 / 255.0, green: 225.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    static let darkBackgroundColor = UIColor(red: 93.0 / 255.0, green: 64.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    static let primaryTextColor = UIColor(white: 0.33, alpha: 1.0)
    
    static let highlightColor = UIColor(red: 255.0 / 255.0, green: 235.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    static let secondaryColor = UIColor(white: 114.0 / 255.0, alpha: 1.0)
    static let tintColor = UIColor(red: 219 / 255.0, green: 207 / 255.0, blue: 28 / 255.0, alpha: 1.0)
    static let searchBarTintColor = UIColor.yellow
    static let separatorColor = UIColor(white: 182.0 / 255.0, alpha: 1.0)
    
    static var previews: some View {
        StyledMapplsAutocompleteViewControllerSwiftUIView(placeSuggestion: Binding.constant(nil), withBackgroundColor: withBackgroundColor, selectedTableCellBackgroundColor: selectedTableCellBackgroundColor, darkBackgroundColor: darkBackgroundColor, primaryTextColor: primaryTextColor, highlightColor: highlightColor, secondaryColor: secondaryColor, tintColor: tintColor, searchBarTintColor: searchBarTintColor, separatorColor: separatorColor)
    }
}
