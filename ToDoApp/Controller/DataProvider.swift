//
//  DataProvider.swift
//  ToDoApp
//
//  Created by Дмитрий Федоринов on 10/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import Foundation
import UIKit

enum Section: Int, CaseIterable {
    case todo
    case done
}
class DataProvider: NSObject {
    var taskManager: TaskManager?
    
}

extension DataProvider: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section),
            let taskManager = taskManager
            else { return 0 }
        
        switch section {
        case .todo:
            return taskManager.tasksCount
        case .done:
            return taskManager.doneTasksCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: indexPath) as! TaskCell
        
        
        if let section = Section(rawValue: indexPath.section),
            let taskManager = taskManager {
            let task: Task
            switch section {
            case .todo:
                task = taskManager.task(at: indexPath.row)
            case .done:
                task = taskManager.doneTask(at: indexPath.row)
            }
            cell.configure(withTask: task)
        }
        return cell
    }
    
    
}
