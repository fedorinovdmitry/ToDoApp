//
//  Task.swift
//  ToDoApp
//
//  Created by Дмитрий Федоринов on 10/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import Foundation

struct Task {
    let title: String
    let description: String?
    var date: Date
    let location: Location?
    var isDone: Bool = false
    
    var dictionary: [String : Any] {
        var dic: [String : Any] = [:]
        dic["title"] = title
        dic["description"] = description
        dic["date"] = date
        if let locatioDic = location?.dictionary {
            dic["location"] = locatioDic
        }
        return dic
    }
    
    init(title: String,
         description: String? = nil,
         date: Date? = nil,
         location: Location? = nil) {
        self.title = title
        self.description = description
        self.date = date ?? Date()
        self.location = location
    }
}

extension Task {
    typealias plistDictionary = [String : Any]
    init?(dict: plistDictionary) {
        self.title = dict["title"] as! String
        self.description = dict["description"] as? String
        self.date = dict["date"] as? Date ?? Date()
        if let locationDict = dict["location"] as? [String : Any] {
            self.location = Location(dict: locationDict)
        } else {
           self.location = nil
        }
        
    }
    
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        
        if lhs.title == rhs.title,
            lhs.description == rhs.description,
            lhs.location == rhs.location {
            return true
        }
        return false
    }
}
