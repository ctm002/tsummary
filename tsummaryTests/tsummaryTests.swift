//
//  tsummaryTests.swift
//  tsummaryTests
//
//  Created by Soporte on 30-11-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import XCTest
@testable import tsummary

class tsummaryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testPresenterNotNil(){
        let presenter = PresenterSemana()
        XCTAssertNotNil(presenter)
    }
    
    func testCalcularSemana03012019()
    {
        let presenter: PresenterSemana = PresenterSemana()
        let calculated = presenter.firstDateOfWeek(getDate(3, 1, 2019))
        let now = getDate(7, 1, 2019)
        XCTAssertEqual(now, calculated)
    }
    
    func testCalcularSemana19012018()
    {
        let presenter: PresenterSemana = PresenterSemana()
        let calculated = presenter.firstDateOfWeek(getDate(19, 1, 2018))
        let now = getDate(22, 1, 2018)
        XCTAssertEqual(now, calculated)
    }
    
    func testCalcularSemana15012018()
    {
        let presenter: PresenterSemana = PresenterSemana()
        let calculated = presenter.firstDateOfWeek(getDate(15, 1, 2018))
        let now = getDate(22, 1, 2018)
        XCTAssertEqual(now, calculated)
    }
    
    
    func getDate(_ dia: Int, _ mes: Int, _ año: Int) -> Date?
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
}
