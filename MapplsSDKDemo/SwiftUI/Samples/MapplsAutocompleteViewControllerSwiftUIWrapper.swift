import SwiftUI
import MapplsUIWidgets

struct ContentView: View {
    var body: some View {
        MapplsAutocompleteViewControllerSwiftUIWrapper().navigationBarHidden(true)
    }
}

struct MapplsAutocompleteViewControllerSwiftUIWrapper: UIViewControllerRepresentable {

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
        autocompleteViewController.delegate = context.coordinator
        autocompleteViewController.attributionSettings = attributionSetting
        autocompleteViewController.autocompleteFilter = MapplsAutocompleteFilter()
        return autocompleteViewController
    }

    func updateUIViewController(_ uiViewController: MapplsAutocompleteViewController, context: UIViewControllerRepresentableContext<MapplsAutocompleteViewControllerSwiftUIWrapper>) {
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, MapplsAutocompleteViewControllerDelegate {
        func didAutocomplete(viewController: MapplsAutocompleteViewController, withSuggestion suggestion: MapplsSearchPrediction) {
            
        }
        
        var parent: MapplsAutocompleteViewControllerSwiftUIWrapper

        init(_ parent: MapplsAutocompleteViewControllerSwiftUIWrapper) {
            self.parent = parent
        }

        func didAutocomplete(viewController: MapplsAutocompleteViewController, withPlace place: MapplsAtlasSuggestion) {
            DispatchQueue.main.async {
                print(place.description.description as Any)
                self.parent.presentationMode.wrappedValue.dismiss()
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
        ContentView()
    }
}
