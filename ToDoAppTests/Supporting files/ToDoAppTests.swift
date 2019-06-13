//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Дмитрий Федоринов on 04/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import XCTest
@testable import ToDoApp

class ToDoAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialViewControllerIsTaskListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            XCTFail()
            return
        }
        guard let rootViewController = navigationController.viewControllers.first as? TaskListViewController else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(rootViewController is TaskListViewController)
    }
    

}
