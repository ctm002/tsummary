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
    
    func presenterIsNotNil() {
        let presenter: PresenterSemana = PresenterSemana()
        XCTAssertNotNil(presenter)
    }
    
    func calcularSemana()
    {
        let presenter: PresenterSemana = PresenterSemana()
        let calculated = presenter.firstDateOfWeek(getDate(3, 1, 2019))
        let date = getDate(8, 1, 2019)
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
}
