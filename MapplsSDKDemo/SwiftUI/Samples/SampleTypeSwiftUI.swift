import Foundation

struct SectionInfoSwiftUI: Identifiable {
    var id: String?
    
    var rows : [SampleTypeSwiftUI] = []
    var headerTitle : String?
}


enum SampleTypeSwiftUI: String, CaseIterable, Identifiable {
    var id: String {
        return self.rawValue
    }
    case map
    case placePicker
    case autosuggestWidget
    
    var title: String {
        switch self {
        case .map:
            return "Show Map"
        case .placePicker:
            return "Place Picker"
        case .autosuggestWidget:
            return "Autosuggest Widget"
        }
    }
}
