//
//  FileManagerTests.swift
//  tsummaryTests
//
//  Created by OTRO on 09-03-18.
//  Copyright © 2018 cariola. All rights reserved.
//

import XCTest

class FileConfigTests: XCTestCase {
    
    var fileConfig : FileConfig!
    
    override func setUp() {
        super.setUp()
        fileConfig = FileConfig.instance
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFileConfigIsNotNull() {
        XCTAssertNotNil(fileConfig)
    }
    
    func testSaveDataIntoFile()
    {
        fileConfig.saveWith(key: "newKey", value: "docroom.cariola.cl", result : { (value: Bool) in
            XCTAssert(value)
        })
    }
    
    func testGetDataByKeyServerIntoFile()
    {
        fileConfig.saveWith(key: "newKey", value: "docroom.cariola.cl", result : { (value: Bool) in
            let value: String = fileConfig.fetch(key: "newKey")
            XCTAssertEqual(value, "docroom.cariola.cl")
        })
    }
}
