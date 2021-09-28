//
//  NumberCruncherUnaryTests.swift
//  StealthyCalcTests
//
//  Created by Stephen McKenna on 9/28/21.
//

import XCTest

class NumberCruncherUnaryTests: XCTestCase {
    var sut: NumberCruncher!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NumberCruncher()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testSignChange() {
        #warning("Implement = rule")

        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, -8)
        XCTAssertEqual(result.expressionString, "˗8")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, -8)
        XCTAssertEqual(result.expressionString, "˗8")

        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, -8)
        XCTAssertEqual(result.expressionString, "˗8")

        sut.performOperation("ᐩ/˗")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 8)
        XCTAssertEqual(result.expressionString, "˗(˗8)")

        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 8)
        XCTAssertEqual(result.expressionString, "˗(˗8)")
    }
    
    func testPercentage() {
        sut .setOperand(8)
        sut.performOperation("%")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 0.08)
        XCTAssertEqual(result.expressionString, "8%")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 0.08)
        XCTAssertEqual(result.expressionString, "8%")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 0.08)
        XCTAssertEqual(result.expressionString, "8%")
        
        sut.setOperand(8)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("%")
        result = sut.evaluate()
        XCTAssertEqual(result.result, -0.08)
        XCTAssertEqual(result.expressionString, "(˗8)%")
        
    }
    
    func testSquared() {
        sut.setOperand(8)
        sut.performOperation("х²")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 64)
        XCTAssertEqual(result.expressionString, "8²")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 4096)
        XCTAssertEqual(result.expressionString, "(8²)²")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("х²")
        sut.performOperation("х²")
        XCTAssertEqual(result.result, 4096)
        XCTAssertEqual(result.expressionString, "(8²)²")

    }
    
    func testCubed() {
        sut.setOperand(8)
        sut.performOperation("х³")
        var result = sut.evaluate()
        XCTAssertEqual(result.result, 512)
        XCTAssertEqual(result.expressionString, "8³")
        
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result, 134217728)
        XCTAssertEqual(result.expressionString, "(8³)³")
        
        sut.clear()
        sut.setOperand(8)
        sut.performOperation("х³")
        sut.performOperation("х³")
        XCTAssertEqual(result.result, 134217728)
        XCTAssertEqual(result.expressionString, "(8³)³")

    }

}
