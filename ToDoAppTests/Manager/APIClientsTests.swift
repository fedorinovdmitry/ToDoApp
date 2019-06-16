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
        super.setUp()
        self.sut = APIClient()
        self.mockUrlSession = MockURLSession(data: Data(),
                                             urlResponse: nil,
                                             responseError: nil)
        sut.urlSession = mockUrlSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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

    // token -> Data -> completionHandler -> DataTask -> urlSession
    func testSuccessfulLoginCreatesToken() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        mockUrlSession = MockURLSession(data: jsonDataStub,
                                        urlResponse: nil,
                                        responseError: nil)
        sut.urlSession = mockUrlSession
        
        let tokenExpectation = expectation(description: "Token expectation")
        
        var caughtToken: String?
        sut.login(withName: "login",
                  password: "password") { (token, _) in
            caughtToken = token
                    tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertEqual(caughtToken, "tokenString")
            
        }
    }
    
    func testLoginInvalidJSONReturnsError() {
        
        mockUrlSession = MockURLSession(data: Data(),
                                        urlResponse: nil,
                                        responseError: nil)
        sut.urlSession = mockUrlSession
        
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login",
                  password: "password") { (_, error) in
                    caughtError = error
                    errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertNotNil(caughtError)
            
        }
    }
    
    func testLoginWhenDataIsNillReturnsError() {
        
        mockUrlSession = MockURLSession(data: nil,
                                        urlResponse: nil,
                                        responseError: nil)
        sut.urlSession = mockUrlSession
        
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login",
                  password: "password") { (_, error) in
                    caughtError = error
                    errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertNotNil(caughtError)
            
        }
    }
    
    enum ServerError: Error {
        case wrongLogin
    }
    
    func testLoginWhenServerReturnError() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        mockUrlSession = MockURLSession(data: jsonDataStub,
                                        urlResponse: nil,
                                        responseError: ServerError.wrongLogin)
        sut.urlSession = mockUrlSession
        
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login",
                  password: "password") { (_, error) in
                    caughtError = error
                    errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertNotNil(caughtError)
            
        }
    }
}

extension APIClientsTests {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        
        private let mockDataTask: MockURLSessionDataTask
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            mockDataTask = MockURLSessionDataTask(data: data,
                                                  urlResponse: urlResponse,
                                                  responseError: responseError)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
            
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(
                    self.data,
                    self.urlResponse,
                    self.responseError
                )
            }
        }
    }
}
