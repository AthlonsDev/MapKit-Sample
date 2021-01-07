//
//  MapKit_SampleTests.swift
//  MapKit SampleTests
//
//  Created by Athlosn90 on 09/07/2020.
//  Copyright © 2020 Athlosn90. All rights reserved.
//

import XCTest
@testable import MapKit_Sample

class MapKit_SampleTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLocation() {
        let vc = ViewController()
        
        print(vc.sourceCoordinate)
        
       
    }

}
