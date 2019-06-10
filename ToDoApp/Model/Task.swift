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
    private(set) var date: Date?
    let location: Location?
    
    init(title: String,
         description: String? = nil,
         location: Location? = nil) {
        self.title = title
        self.description = description
        self.date = Date()
        self.location = location
    }
}
