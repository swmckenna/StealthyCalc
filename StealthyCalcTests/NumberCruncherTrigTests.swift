//
//  NumberCruncherTrigTests.swift
//  StealthyCalcTests
//
//  Created by Stephen McKenna on 9/24/21.
//

import XCTest

class NumberCruncherTrigTests: XCTestCase {
    var sut: NumberCruncher!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NumberCruncher()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: RADIANS TESTS
    func testSinRadians() {
        sut.performOperation("π")
        sut.performOperation("sinRAD")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(π)")
        
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(6)
        sut.performOperation("=")
        sut.performOperation("sinRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.5, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(π÷6)")
        
        sut.setOperand(3)
        sut.performOperation("×")
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(2)
        sut.performOperation("=")
        sut.performOperation("sinRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -1, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(3×π÷2)")
        
        sut.clear()
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(4)
        sut.performOperation("=")
        sut.performOperation("sinRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.707106781186548, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(π÷4)")
        
        sut.clear()
        sut.setOperand(4)
        sut.performOperation("×")
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        sut.performOperation("sinRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.866025403784439, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(4×π÷3)")
        
        sut.setOperand(0)
        sut.performOperation("sinRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(0)")
    }
    
    func testCosRadians() {
        sut.performOperation("π")
        sut.performOperation("cosRAD")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, -1, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(π)")
        
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(6)
        sut.performOperation("=")
        sut.performOperation("cosRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.866025403784439, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(π÷6)")
        
        sut.setOperand(3)
        sut.performOperation("×")
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(2)
        sut.performOperation("=")
        sut.performOperation("cosRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(3×π÷2)")
        
        sut.clear()
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(4)
        sut.performOperation("=")
        sut.performOperation("cosRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.707106781186548, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(π÷4)")
        
        sut.clear()
        sut.setOperand(4)
        sut.performOperation("×")
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        sut.performOperation("cosRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.5, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(4×π÷3)")
        
        sut.setOperand(0)
        sut.performOperation("cosRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(0)")
    }
    
    func testTanRadians() {
        sut.performOperation("π")
        sut.performOperation("tanRAD")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(π)")
        
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(6)
        sut.performOperation("=")
        sut.performOperation("tanRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.577350269189626, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(π÷6)")
        
        sut.setOperand(3)
        sut.performOperation("×")
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(2)
        sut.performOperation("=")
        sut.performOperation("tanRAD")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "tan(3×π÷2)")
        
        sut.clear()
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(4)
        sut.performOperation("=")
        sut.performOperation("tanRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(π÷4)")
        
        sut.clear()
        sut.setOperand(4)
        sut.performOperation("×")
        sut.performOperation("π")
        sut.performOperation("÷")
        sut.setOperand(3)
        sut.performOperation("=")
        sut.performOperation("tanRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.732050807568877, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(4×π÷3)")
        
        sut.setOperand(0)
        sut.performOperation("tanRAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(0)")
    }
    
    

}
