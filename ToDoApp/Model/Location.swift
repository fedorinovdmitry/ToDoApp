//
//  Location.swift
//  ToDoApp
//
//  Created by Дмитрий Федоринов on 10/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    init (name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
    
}

extension Location {
    init?(dict: [String:Any]) {
        self.name = dict["name"] as! String
        if let latitude = dict["latitude"] as? Double,
            let longtitude = dict["longitude"] as? Double {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            
        } else {
            self.coordinate = nil
        }
    }
}
extension Location: Equatable {
    static func == (lhs: Location,
                    rhs: Location) -> Bool {
        guard lhs.coordinate?.latitude == rhs.coordinate?.latitude &&
            lhs.coordinate?.longitude == rhs.coordinate?.longitude &&
            lhs.name == rhs.name else {
                return false
        }
        return true
    }
}
