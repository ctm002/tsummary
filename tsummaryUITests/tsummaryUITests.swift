//
//  tsummaryUITests.swift
//  tsummaryUITests
//
//  Created by Soporte on 30-11-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import XCTest
@testable import tsummary


class tsummaryUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    func presenterIsNotNull()
    {
        let presenter: PresenterSemana = PresenterSemana()
        XCTAssertNotNil(presenter)
    }
    
    func calcularSemana() {
        let presenter: PresenterSemana = PresenterSemana()
        let calculated = presenter.firstDateOfWeek(getDate(3, 1, 2019))
        
        let date = getDate(7, 1, 2019)
        XCTAssertEqual(date, calculated)
    }
    
    private func getDate(_ dia: Int, _ mes: Int, _ año: Int) -> Date?
    {
        let locale = Locale(identifier: "es_CL")
        let tz = TimeZone(abbreviation: "UTC")!
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = locale
        calendar.timeZone = tz
        
        var dtComponents = DateComponents()
        dtComponents.day = dia
        dtComponents.month = mes
        dtComponents.year = año
        let fechaExpected = calendar.date(from:dtComponents)
        return fechaExpected
    }
     */
}
