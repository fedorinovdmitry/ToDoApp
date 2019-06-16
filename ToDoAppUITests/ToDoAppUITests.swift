//
//  ToDoAppUITests.swift
//  ToDoAppUITests
//
//  Created by Дмитрий Федоринов on 04/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import XCTest

class ToDoAppUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--UITesting")
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testAddNewTask() {
        
        
        XCTAssertTrue(app.isOnMainView)
        app.navigationBars["List of Tasks"].buttons["Add"].tap()
        
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("3st Task")
        
        app.textFields["Location"].tap()
        app.textFields["Location"].typeText("Orel")
        
        app.textFields["Date"].tap()
        app.textFields["Date"].typeText("01.01.19")
        
        app.textFields["Address"].tap()
        app.textFields["Address"].typeText("Orel")
        
        app.textFields["Description"].tap()
        app.textFields["Description"].typeText("My description")
        
        XCTAssertFalse(app.isOnMainView)
        app.buttons["Save"].tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let app = self.app!
            XCTAssertTrue(app.isOnMainView)
            XCTAssertTrue(app.tables.staticTexts["2st Task"].exists)
            XCTAssertTrue(app.tables.staticTexts["01.01.19"].exists)
            XCTAssertTrue(app.tables.staticTexts["Orel"].exists)
        }
        
    }
    
    func testWhenCellIsSwipedLeftDoneButtonApeared() {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.isOnMainView)
        app.navigationBars["List of Tasks"].buttons["Add"].tap()
        
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("1st Task")
        
        app.textFields["Location"].tap()
        app.textFields["Location"].typeText("Orel")
        
        app.textFields["Date"].tap()
        app.textFields["Date"].typeText("01.01.19")
        
        app.textFields["Address"].tap()
        app.textFields["Address"].typeText("Orel")
        
        app.textFields["Description"].tap()
        app.textFields["Description"].typeText("My description")
        
        XCTAssertFalse(app.isOnMainView)
        app.buttons["Save"].tap()
        
        
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).swipeLeft()
            
        tablesQuery.element(boundBy: 0).buttons["Done"].tap()
            
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "data").label, "")
            
        
    }

}
extension XCUIApplication {
    var isOnMainView: Bool {
        return otherElements["mainView"].exists
    }
}
