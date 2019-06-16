//
//  ViewController.swift
//  ToDoApp
//
//  Created by Дмитрий Федоринов on 04/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {

    
    // MARK: - Custom types
    
    // MARK: - Constants
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var dataProvider: DataProvider!
    
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let taskManager = TaskManager()
        dataProvider.taskManager = taskManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetailsWithNotification), name: NSNotification.Name(rawValue: "DidSelectedRownotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - IBAction
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: NewTaskController.self)) as? NewTaskController {
            viewController.taskManager = self.dataProvider.taskManager
            present(viewController, animated: true, completion: nil)

        }
        
    }
    
    
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    @objc private func showDetailsWithNotification(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let task = userInfo["task"] as? Task,
            let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }
        detailVC.task = task
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    // MARK: - Navigation

    
    
    


}


