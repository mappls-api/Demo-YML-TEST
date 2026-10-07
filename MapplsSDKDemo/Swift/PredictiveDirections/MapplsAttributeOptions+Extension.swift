import Foundation
import MapplsAPIKit

extension MapplsAttributeOptions: CaseIterable {
    public static var allCases: [MapplsAttributeOptions] {
        [.distance, .expectedTravelTime, .speed, .speedLimits, .congestionLevel, .nodes, .baseDuration, .tollRoad]
    }
    
    public var descriptionText: String {
        switch self {
        case .distance:
            return "Distance"
        case .expectedTravelTime:
            return "Expected Travel Time"
        case .speed:
            return "Speed"
        case .speedLimits:
            return "Speed Limits"
        case .congestionLevel:
            return "Congestion Level"
        case .nodes:
            return "Nodes"
        case .baseDuration:
            return "Base Duration"
        case .tollRoad:
            return "Toll Road"
        default:
            return ""
        }
    }
}
