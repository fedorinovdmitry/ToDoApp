//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Дмитрий Федоринов on 10/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(withTask task: Task) {
        self.titleLabel.text = task.title
        if let date = task.date {
            setDateToLabel(date: date)
        }
        if let location = task.location {
            locationLabel.text = location.name
        }
        
    }
    
    private func setDateToLabel(date: Date) {
        let df = DateFormatter()
        df.dateFormat = "dd.mm.yy"
        let dateString = df.string(from: date)
        self.dateLabel.text = dateString
    }
}
