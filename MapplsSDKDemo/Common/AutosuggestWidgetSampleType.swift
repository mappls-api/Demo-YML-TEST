import Foundation

@objc public enum AutosuggestWidgetSampleType: Int, CaseIterable, Identifiable {
    
    public var id: String {
        return "\(self.rawValue)"
    }
    
    case defaultController
    
    case customTheme
    
    case customUISearchController
    
    case textFieldSearch
    
    var title: String {
        switch self {
        case .defaultController:
            return "Default Controller"
        case .customTheme:
            return "Custom Theme"
        case .customUISearchController:
            return "Custom UISearchController"
        case .textFieldSearch:
            return "UITextField Search"
        }
    }
}

enum StyledAutosuggestWidgetSampleType: Int, CaseIterable, Identifiable {
    var id: String {
        return "\(self.rawValue)"
    }
    
    case yellowAndBrown
    
    case whiteOnBlack
    
    case blueColors
    
    case hotDogStand
    
    var title: String {
        switch self {
        case .yellowAndBrown:
            return "Yellow And Brown"
        case .whiteOnBlack:
            return "White On Black"
        case .blueColors:
            return "Blue Colors"
        case .hotDogStand:
            return "Hot Dog Stand"
        }
    }
}
