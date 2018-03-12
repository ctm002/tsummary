//
//  tsummaryUITests.swift
//  tsummaryUITests
//
//  Created by Soporte on 30-11-17.
//  Copyright © 2017 cariola. All rights reserved.
//

import XCTest
@testable import tsummary

class EditRegistroHoraViewControllerTests: XCTestCase {
    
    var editRegistroViewController: EditHoraViewController!
    var app : XCUIApplication!
    
    override func setUp() {
        super.setUp()
        editRegistroViewController = EditHoraViewController()
        editRegistroViewController.view.layoutIfNeeded()
        
        continueAfterFailure = true
        app = XCUIApplication()
        app.launch()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        editRegistroViewController = nil
        super.tearDown()
    }
    
    func testRegistrarHora()
    {
        editRegistroViewController.proyectoId = 1
        editRegistroViewController.fechaHoraIngreso = Date()
        editRegistroViewController.asunto = ""
        editRegistroViewController.minutos = 30
        editRegistroViewController.horas = 2
        editRegistroViewController.idAbogado = 20
        editRegistroViewController.btnGuardar_Click(nil)
        XCTAssertEqual(true, editRegistroViewController.response.result)
    }
}
