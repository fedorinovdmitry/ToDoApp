//
//  TaskManager.swift
//  ToDoApp
//
//  Created by Дмитрий Федоринов on 10/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import Foundation
import UIKit

class TaskManager {
    
    private var tasks: [Task] = []
    private var doneTasks: [Task] = []
    
    var tasksCount: Int {
        return tasks.count
    }
    var doneTasksCount: Int {
        return doneTasks.count
    }
    
    var tasksURl: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
           fatalError()
        }
        
        return documentURL.appendingPathComponent("tasks.plist")
    }
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        if let data = try? Data(contentsOf: tasksURl) {
            let dictionaries = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String : Any]]
            for dict in dictionaries! {
                if let task = Task(dict: dict) {
                    tasks.append(task)
                }
            }
        }
    }
    
    deinit {
        save()
    }
    
    @objc func save() {
        let tasksDictionaries = self.tasks.map { $0.dictionary }
        guard tasksDictionaries.count > 0 else {
            try? FileManager.default.removeItem(at: tasksURl)
            return
        }
        
        let plistData = try? PropertyListSerialization.data(fromPropertyList: tasksDictionaries, format: .xml, options: PropertyListSerialization.WriteOptions(0))
        try? plistData?.write(to: tasksURl , options: .atomic)
        
    }
    
    func add(task: Task) {
        if !tasks.contains(task) {
            tasks.append(task)
        }
    }
    
    func task(at index: Int) -> Task {
        return tasks[index]
    }
    
    func checkTask(at index: Int) {
        var task = tasks.remove(at: index)
        task.isDone.toggle()
        doneTasks.append(task)
        
    }
    
    func uncheckTask(at index: Int) {
        var task = doneTasks.remove(at: index)
        task.isDone.toggle()
        tasks.append(task)
    }
    
    func doneTask(at index: Int) -> Task {
        return doneTasks[index]
    }
    
    func removeAll() {
        tasks.removeAll()
        doneTasks.removeAll()
    }
}
