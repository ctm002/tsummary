//
//  tsummaryUITests.swift
//  tsummaryUITests
//
//  Created by Soporte on 30-11-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import XCTest
@testable import tsummary

class EditHoraViewControllerTests: XCTestCase {
    
    var editHoraView: EditHoraViewController!
    var app : XCUIApplication!
    
    override func setUp() {
        super.setUp()
        editHoraView = EditHoraViewController()
        
        continueAfterFailure = true
        app = XCUIApplication()
        app.launch()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        editHoraView = nil
        super.tearDown()
    }
    
    func testRegistrarHora()
    {
        editHoraView.view.layoutIfNeeded()
        editHoraView.proyectoId = 1
        editHoraView.fechaHoraIngreso = Date()
        editHoraView.asunto = ""
        editHoraView.minutos = 30
        editHoraView.horas = 2
        editHoraView.idAbogado = 20
        editHoraView.btnGuardar_Click(nil)
        XCTAssertEqual(true, editHoraView.response.result)
    }
}
