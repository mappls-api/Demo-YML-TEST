import UIKit
import MapplsAPIKit

class PredictiveRouteManeuversVC: UITableViewController {
   
    public var trip: MapplsPredictiveRouteTrip? = nil
    
    var tripManeuvers = [MapplsPredictiveRouteManeuver]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Direction List"
        if let trip = trip, let routeLegs = trip.legs {
            for routeLeg in routeLegs {
                if let maneuvers = routeLeg.maneuvers {
                    self.tripManeuvers.append(contentsOf: maneuvers)
                }
            }
        }
        self.tableView.register(PredictiveRouteManeuverCell.self, forCellReuseIdentifier: "PredictiveRouteManeuverCell")
        self.tableView.reloadData()
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tripManeuvers.count > 0 {
            return tripManeuvers.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell: UITableViewCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PredictiveRouteManeuverCell", for: indexPath) as? PredictiveRouteManeuverCell {
            returnCell = cell
        } else {
            returnCell = PredictiveRouteManeuverCell(style: .default, reuseIdentifier: "PredictiveRouteManeuverCell")
        }
        if let cell = returnCell as? PredictiveRouteManeuverCell {
            let maneuver = tripManeuvers[indexPath.row]
            
            cell.instructionLabel.text = maneuver.instruction
            cell.timeLabel.text = "\(maneuver.time ?? 0) seconds"
            cell.distanceLabel.text = "\(maneuver.length ?? 0) km"
        }
        return returnCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
