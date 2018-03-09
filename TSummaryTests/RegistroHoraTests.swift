//
//  HoraTest.swift
//  tsummaryTests
//
//  Created by OTRO on 09-03-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import XCTest

class RegistroHoraTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsNotNil() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let hora = RegistroHora()
        XCTAssertNotNil(hora)
    }
    
    func testIsValid()
    {
        let hora = RegistroHora()
        hora.minutosTrabajados = 0
        XCTAssertTrue(!hora.isValid())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
