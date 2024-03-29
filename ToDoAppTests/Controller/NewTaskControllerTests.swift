//
//  NewTaskControllerTests.swift
//  ToDoAppTests
//
//  Created by Дмитрий Федоринов on 11/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDoApp

class NewTaskControllerTests: XCTestCase {

    var sut: NewTaskController!
    var placemark: MockCLPlacemark!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "NewTaskController") as? NewTaskController
        sut.loadViewIfNeeded()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testHasDateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func testHasLocationTextField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    func testHasAdressTextField() {
        XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionTextField() {
        XCTAssertTrue(sut.desriptionTextField.isDescendant(of: sut.view))
    }
    
    func testHasSafeButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    func testHasCancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
    
    func testSaveUsesGeocoderToConvertCoordinteFromAdress() {
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = df.date(from: "01.01.19")
        
        sut.titleTextField.text = "Foo"
        sut.locationTextField.text = "Bar"
        sut.dateTextField.text = "01.01.19"
        sut.addressTextField.text = "Орел"
        sut.desriptionTextField.text = "Baz"
        
        sut.taskManager = TaskManager()
        
        let mockGeocoder = MockCLGeocoder()
        sut.geocoder = mockGeocoder
        
        sut.save()
        
        
        let cordinate = CLLocationCoordinate2D(latitude: 52.9628043, longitude: 36.0678371)
        let location = Location(name: "Bar", coordinate: cordinate)
        
        let generatedTask = Task(title: "Foo", description: "Baz", date: date, location: location)
        
        placemark = MockCLPlacemark()
        
        
        placemark.mockCoordinate = cordinate
        
        mockGeocoder.completionHandler?([placemark], nil)
        
        let task = sut.taskManager.task(at: 0)
        
        XCTAssertEqual(task, generatedTask)
        
    }
    
    func testSaveButtonHasSaveMethod() {
        let saveButton = sut.saveButton
        guard let action = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        XCTAssertTrue(action.contains("save"))
    }
    
    func testGeocoderFetchesCorrectCoordinates() {
        let geocoderAnswer = expectation(description: "Geocoder answer")
        let addressString = "Орел"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            let placemark = placemarks?.first
            let location = placemark?.location
            guard let latitude = location?.coordinate.latitude,
                let longtitude = location?.coordinate.longitude
                else {
                    XCTFail()
                    return
                }
            XCTAssertEqual(latitude, 52.9628043)
            XCTAssertEqual(longtitude, 36.0678371)
            geocoderAnswer.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSaveDismissesNewTaskViewController() {
        let mockNewTaskViewController = MockNewTaskViewController()
        mockNewTaskViewController.titleTextField = UITextField()
        mockNewTaskViewController.titleTextField.text = "Foo"
        mockNewTaskViewController.locationTextField = UITextField()
        mockNewTaskViewController.locationTextField.text = "Baz"
        mockNewTaskViewController.dateTextField = UITextField()
        mockNewTaskViewController.dateTextField.text = "01.01.19"
        mockNewTaskViewController.addressTextField = UITextField()
        mockNewTaskViewController.addressTextField.text = "Орел"
        mockNewTaskViewController.desriptionTextField = UITextField()
        mockNewTaskViewController.desriptionTextField.text = "Bar"
        
        mockNewTaskViewController.save()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(mockNewTaskViewController.isDismissed)
        }
        
        
    }
}

extension NewTaskControllerTests {
    
    class MockCLGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockCLPlacemark: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D!
        
        override var location: CLLocation? {
            return CLLocation(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude)
        }
    }
}

extension NewTaskControllerTests {
    
    class MockNewTaskViewController: NewTaskController {
        var isDismissed: Bool = false
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            isDismissed = true
        }
    }
    
}
