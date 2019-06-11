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
    
    func configure(withTask task: Task, done: Bool = false) {
        
        if done {
            let attributedString = NSAttributedString(string: task.title, attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            titleLabel.attributedText = attributedString
            dateLabel = nil
            locationLabel = nil
        } else {
            self.titleLabel.text = task.title
            setDateToLabel(date: task.date)
            if let location = task.location {
                locationLabel.text = location.name
            }
        }
        
        
    }
    
    private func setDateToLabel(date: Date) {
        let df = DateFormatter()
        df.dateFormat = "dd.mm.yy"
        let dateString = df.string(from: date)
        self.dateLabel.text = dateString
    }
}
