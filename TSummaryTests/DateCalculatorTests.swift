//
//  DateCalculator.swift
//  tsummaryTests
//
//  Created by OTRO on 09-03-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import XCTest

class DateCalculatorTests: XCTestCase {
    
    var dateCalculator: DateCalculator!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dateCalculator = DateCalculator()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dateCalculator = nil
        super.tearDown()
    }
    
    func testCuandoDateCalculatorEsNoNull() {
        XCTAssertNotNil(dateCalculator)
    }
    
    func testRetornaCalculoDeFechaInicialApartirDeUnaFechaIndicada()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let expected = formatter.date(from: "2018/02/26")
        let dateInicio = dateCalculator.calcularFechaInicio(now: Date())
        XCTAssertEqual(dateInicio, expected)
    }
    
    func testRetornaCalculoDeFechaInicialApartir20180103()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let expected = formatter.date(from: "2017/12/25")
        let now = formatter.date(from: "2018/01/03")
        let dateCalculated = dateCalculator.calcularFechaInicio(now: now!)
        XCTAssertEqual(dateCalculated, expected)
    }
    
    func testRetornaCalculoDeFechaInicialApartir20180108()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let expected = formatter.date(from: "2018/01/01")
        let now = formatter.date(from: "2018/01/08")
        let dateCalculated = dateCalculator.calcularFechaInicio(now: now!)
        XCTAssertEqual(dateCalculated, expected)
    }
    
    func testRetornaCalculoDeFechaTerminoApartir20180305()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let expected = formatter.date(from: "2018/03/11")
        let now = formatter.date(from: "2018/03/05")
        let dateCalculated = dateCalculator.calcularFechaTermino(now: now!)
        XCTAssertEqual(dateCalculated, expected)
    }
    
    func testRetornaCalculoDeFechaTerminoApartir20180309()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let expected = formatter.date(from: "2018/03/11")
        let now = formatter.date(from: "2018/03/09")
        let dateCalculated = dateCalculator.calcularFechaTermino(now: now!)
        XCTAssertEqual(dateCalculated, expected)
    }
    
    func testRetornaCalculoDeFechaTerminoApartir20180311()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let expected = formatter.date(from: "2018/03/11")
        let now = formatter.date(from: "2018/03/11")
        let dateCalculated = dateCalculator.calcularFechaTermino(now: now!)
        XCTAssertEqual(dateCalculated, expected)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
