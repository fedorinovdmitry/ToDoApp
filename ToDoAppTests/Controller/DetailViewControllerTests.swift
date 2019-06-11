//
//  DetailViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Дмитрий Федоринов on 11/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import XCTest
@testable import ToDoApp

class DetailViewControllerTests: XCTestCase {

    var sut: DetailViewController!
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHasTitleLabel() {
        
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
        
    }
    
    func testHasDescriptionLabel() {
        
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
        
    }
    
    func testHasDateLabel() {

        XCTAssertNotNil(sut.dateLabel)
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
        
    }
    
    func testHasMapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }

}
