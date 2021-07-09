//
//  StealthyCalcTests.swift
//  StealthyCalcTests
//
//  Created by Stephen McKenna on 6/4/21.
//

import XCTest
@testable import StealthyCalc

class StealthyCalcTests: XCTestCase {
    var sut: NumberCruncher!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NumberCruncher()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testNumberCruncherMath() {
        // 9 / 3 = 3
        sut.setOperand(9)
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        XCTAssertEqual(sut.result, 3.0)
    }

}
