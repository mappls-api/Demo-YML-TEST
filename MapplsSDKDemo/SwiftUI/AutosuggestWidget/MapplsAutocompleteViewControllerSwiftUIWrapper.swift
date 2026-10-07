import SwiftUI
import MapplsUIWidgets

struct MapplsAutocompleteViewControllerSwiftUIView: View {
    @Binding var placeSuggestion: MapplsAtlasSuggestion?
    
    var body: some View {
        MapplsAutocompleteViewControllerSwiftUIWrapper(placeSuggestion: $placeSuggestion)
            .navigationBarHidden(true)
    }
}

struct MapplsAutocompleteViewControllerSwiftUIWrapper: UIViewControllerRepresentable {

    @Binding var placeSuggestion: MapplsAtlasSuggestion?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MapplsAutocompleteViewControllerSwiftUIWrapper>) -> MapplsAutocompleteViewController {
        let autocompleteViewController = MapplsAutocompleteViewController()
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

    func updateUIViewController(_ uiViewController: MapplsAutocompleteViewController, context: UIViewControllerRepresentableContext<MapplsAutocompleteViewControllerSwiftUIWrapper>) {
        
    }

    static func dismantleUIViewController(_ uiViewController: MapplsAutocompleteViewController, coordinator: Coordinator) {
        if let navVC = uiViewController.navigationController {
            navVC.dismiss(animated: false)
        }
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, MapplsAutocompleteViewControllerDelegate {
        func didAutocomplete(viewController: MapplsUIWidgets.MapplsAutocompleteViewController, withFavouritePlace place: MapplsUIWidgets.MapplsUIWidgetAutosuggestFavouritePlace) {
            
        }
        
        var parent: MapplsAutocompleteViewControllerSwiftUIWrapper
        
        init(_ parent: MapplsAutocompleteViewControllerSwiftUIWrapper) {
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

struct MapplsAutocompleteViewControllerSwiftUIWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MapplsAutocompleteViewControllerSwiftUIView(placeSuggestion: Binding.constant(nil))
    }
}
