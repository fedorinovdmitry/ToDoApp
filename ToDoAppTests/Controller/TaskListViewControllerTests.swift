//
//  TaskListViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Дмитрий Федоринов on 10/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import XCTest
@testable import ToDoApp

class TaskListViewControllerTests: XCTestCase {

    var sut: TaskListViewController!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        sut = vc as? TaskListViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWhenViewIsLoadedTableViewIsNotNil() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testWhenViewIsLoadedDataProviderIsNotNil() {
        XCTAssertNotNil(sut.dataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDataSourceIsSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    func testWhenIsLoadedTableViewDelegateAndTableViewDataSourceEqualsOneDataProvider() {
        XCTAssertEqual(
            sut.tableView.delegate as? DataProvider,
            sut.tableView.dataSource as? DataProvider)
    }
    
    func testTaskListVCHasAddBarButtonWithSelfTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    // не хранить ассерты в вспомогательных функциях
    func takeNewTaskViewControllerFromSut() -> NewTaskController {
        XCTAssertNil(sut.presentedViewController)
        guard let newTaskButton = sut.navigationItem.rightBarButtonItem,
            let action = newTaskButton.action else {
                XCTFail()
                return NewTaskController()
        }
        //<ToDoApp.NewTaskController: 0x7f849ce3f1c0> on <ToDoApp.TaskListViewController: 0x7f849ce3cc10> whose view is not in the window hierarchy!
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
        
        return sut.presentedViewController as! NewTaskController
    }
    
    func testAddNewTaskPresentsNewTaskViewController() {
        let newTaskViewController = takeNewTaskViewControllerFromSut()
        XCTAssertNotNil(newTaskViewController.titleTextField)
    }
    
    func testSharesSameTaskManagerWithNewTaskVC() {
        let newTaskViewController = takeNewTaskViewControllerFromSut()
        XCTAssertNotNil(sut.dataProvider.taskManager)
        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager)
        
    }
    
    func testWhenViewAppearedTableViewRealod() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    func testTappingCellSendsNotification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager!.add(task: task)
        expectation(forNotification: NSNotification.Name(rawValue: "DidSelectedRownotification"), object: nil) { (notification) -> Bool in
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else {
                return false
            }
            return task == taskFromNotification
        }
        
        let tableView = sut.tableView
        tableView?.delegate?.tableView!(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testSelectedCellNotificationPushesDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        sut.loadViewIfNeeded()
        let task1 = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        
        sut.dataProvider.taskManager?.add(task: task1)
        sut.dataProvider.taskManager?.add(task: task2)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidSelectedRownotification"), object: self, userInfo: ["task": task2])
        
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else {
            XCTFail()
            return
        }
        
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailViewController.task == task2)
    }

}

extension TaskListViewControllerTests {
    class MockTableView: UITableView {
        var isReloaded = false
        override func reloadData() {
            isReloaded = true
        }
    }
}

extension TaskListViewControllerTests {
    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
