//
//  APIClientsTests.swift
//  ToDoAppTests
//
//  Created by Дмитрий Федоринов on 11/06/2019.
//  Copyright © 2019 FedorinovDmitry. All rights reserved.
//

import XCTest
@testable import ToDoApp

class APIClientsTests: XCTestCase {

    var sut: APIClient!
    var mockUrlSession: MockURLSession!
    
    override func setUp() {
        self.sut = APIClient()
        self.mockUrlSession = MockURLSession()
        sut.urlSession = mockUrlSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func userLogin() {
        let completionHandler = {(token: String?, error: Error?) in }
        sut.login(withName: "name",
                  password: "%qwerty",
                  completionHandler: completionHandler)
        
    }
    func testLoginUsesCorrectHost() {
        userLogin()
        XCTAssertEqual(mockUrlSession.urlComponents?.host, "todoapp.com")
    }
    
    func testLoginUsesCorrectDestination() {
        userLogin()
        XCTAssertEqual(mockUrlSession.urlComponents?.path, "/login")
    }
    
    func testLoginUsesExpectedQueryParameters() {
        userLogin()
        
        guard let queryItems = mockUrlSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")
        
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }

}

extension APIClientsTests {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            
            return URLSession.shared.dataTask(with: url)
        }
    }
}
