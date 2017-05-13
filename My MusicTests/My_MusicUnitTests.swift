//
//  My_MusicTests.swift
//  My MusicTests
//
//  Created by Sinisa Vukovic on 04/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import XCTest
@testable import My_Music

class My_MusicTests: XCTestCase {
  
  var formatedTestTime:String?
    
    override func setUp() {
        super.setUp()

        formatedTestTime = Utils.timeString(time: 128.0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeStringFunc() {
      XCTAssertEqual(formatedTestTime, "02:08", "Formatting TimeInterval into string not working correct!")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
