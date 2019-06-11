//
//  DetailViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Дмитрий Федоринов on 11/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import XCTest
import CoreLocation
import MapKit
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
    
    func testHasLocation() {
        XCTAssertNotNil(sut.locationLabel)
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }
    
    func testHasMapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }

    func configureTaskAndImitateWillApear() {
        let coordinate = CLLocationCoordinate2D(latitude: 40.7143528, longitude: -74.0059731)
        let location = Location(name: "Baz", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1546300800)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        sut.task = task
        
        //имитируем работу willApear viewDidApear
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    func testSettingTaskSetsTitleLabel() {
        configureTaskAndImitateWillApear()
        XCTAssertEqual(sut.titleLabel.text, "Foo")
    }
    
    func testSettingTaskSetsDescriptionLabel() {
        configureTaskAndImitateWillApear()
        XCTAssertEqual(sut.descriptionLabel.text, "Bar")
    }
    
    func testSettingTaskSetsLocationLabel() {
        configureTaskAndImitateWillApear()
        XCTAssertEqual(sut.locationLabel.text, "Baz")
    }
    
    func testSettingTaskSetsDateLabel() {
        configureTaskAndImitateWillApear()
        XCTAssertEqual(sut.dateLabel.text, "01.01.19")
    }
    
    func testSettingTaskSetsMapView() {
        configureTaskAndImitateWillApear()
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 40.7143528, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, -74.0059731, accuracy: 0.001)
    }

    
}
