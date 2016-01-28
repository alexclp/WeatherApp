//
//  WeatherProviderTest.swift
//  Weather
//
//  Created by Alexandru Clapa on 28/01/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherProviderTest: XCTestCase {
	
	let validURL = "http://api.openweathermap.org/data/2.5/weather?lat=47.996184&lon=-1.341880&appid=44db6a862fba0b067b1930da0d769e98&units=metric"
	let invalidURL = "http://api.openweathermap.org/data/2.5/weather?lat=47.996184&lon=-1.341880&appid=44db6a862fba0b067b1930da0d7698&units=metric"
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	
	func testServerGETMethodFetchDataIfURLIsValid() {
		
		let expectation = expectationWithDescription("Fetch Data from internet with valid URL")
		
		WeatherServer.sharedServer().GET(validURL) { (response) -> Void in
			
			expectation.fulfill()
			
			switch response {
			case .Success(let data): XCTAssertNotNil(data)
			case _: XCTAssertTrue(false)
			}
		}
		
		waitForExpectationsWithTimeout(10.0) { (error) -> Void in
			print(error)
		}
	}
	
	func testServerGETMethodFetchDataIfURLIsInValid() {
		
		let expectation = expectationWithDescription("Fetch Data from internet with invalid URL")
		
		WeatherServer.sharedServer().GET(invalidURL) { (response) -> Void in
			
			expectation.fulfill()
			
			switch response {
			case .Success(let data): XCTAssertNotNil(data)
			case .Failure(let error): XCTAssertTrue(error == .ParseError)
			}
		}
		
		waitForExpectationsWithTimeout(10.0) { (error) -> Void in
			print(error)
		}
	}
	
}
