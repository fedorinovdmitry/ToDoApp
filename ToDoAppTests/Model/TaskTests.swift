//
//  TaskTests.swift
//  ToDoAppTests
//
//  Created by Дмитрий Федоринов on 10/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import XCTest
@testable import ToDoApp

class TaskTests: XCTestCase {

    let taskTitle = "Foo"
    let taskDescription = "Bar"
    
    func testInitTaskWithTitle() {
        let task = Task(title: taskTitle) // Foo Bar Baz
        
        XCTAssertNotNil(task)
    }
    
    func testInitTaskWithTitleAndDescription() {
        let task = Task(title: taskTitle, description: taskDescription)
        
        XCTAssertNotNil(task)
    }
    
    func testWhenGivenTitleSetsTitle() {
        let task = Task(title: taskTitle)
        
        XCTAssertEqual(task.title, taskTitle)
        
    }
    
    func testWhenGivenDescriptionSetsDescription() {
        let task = Task(title: taskTitle, description: taskDescription)
        
        XCTAssertEqual(task.description, taskDescription)
    }
    
    func testTaskInitsWithDate() {
        let task = Task(title: taskTitle)
        
        XCTAssertNotNil(task.date)
    }
    
    func testWhenGivenLocationSetsLocation() {
        let location = Location(name: "Foo")
        
        let task = Task(title: taskTitle, description: taskDescription, location: location)
        
        XCTAssertEqual(location, task.location)
    }
}
