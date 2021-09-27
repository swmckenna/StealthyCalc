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
    //MARK: BASIC
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
    
    //MARK: INVERSE
    func testSin⁻¹Radians() {
        sut.setOperand(0)
        sut.performOperation("sin⁻¹RAD")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin⁻¹(0)")
        
        sut.setOperand(0.5)
        sut.performOperation("sin⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, Double.pi/6, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin⁻¹(0.5)")
        
        sut.setOperand(-1)
        sut.performOperation("sin⁻¹RAD")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -Double.pi/2, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin⁻¹(-1)")
        
        sut.clear()
        sut.setOperand(2)
        sut.performOperation("²√ₓ")
        sut.performOperation("¹/ₓ")
        sut.performOperation("sin⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, Double.pi/4, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin⁻¹(√2⁻¹)")
        
        sut.clear()
        sut.setOperand(3)
        sut.performOperation("²√ₓ")
        sut.performOperation("÷")
        sut.setOperand(2)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("=")
        sut.performOperation("sin⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -Double.pi/3, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin⁻¹(√3÷˗(2))")
        
        sut.setOperand(1)
        sut.performOperation("sin⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, Double.pi/2, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin⁻¹(1)")
    }
    
    func testCos⁻¹Radians() {
        sut.setOperand(0)
        sut.performOperation("cos⁻¹RAD")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, Double.pi/2, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos⁻¹(0)")
        
        sut.setOperand(0.5)
        sut.performOperation("cos⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, Double.pi/3, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos⁻¹(0.5)")
        
        sut.setOperand(-1)
        sut.performOperation("cos⁻¹RAD")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, Double.pi, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos⁻¹(-1)")
        
        sut.clear()
        sut.setOperand(2)
        sut.performOperation("²√ₓ")
        sut.performOperation("¹/ₓ")
        sut.performOperation("cos⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, Double.pi/4, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos⁻¹(√2⁻¹)")
        
        sut.clear()
        sut.setOperand(3)
        sut.performOperation("²√ₓ")
        sut.performOperation("÷")
        sut.setOperand(2)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("=")
        sut.performOperation("cos⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 5*Double.pi/6, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos⁻¹(√3÷˗(2))")
        
        sut.setOperand(1)
        sut.performOperation("cos⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos⁻¹(1)")
    }
    
    func testTan⁻¹Radians() {
        sut.setOperand(0)
        sut.performOperation("tan⁻¹RAD")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan⁻¹(0)")
        
        sut.setOperand(0.5)
        sut.performOperation("tan⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.463647609000806, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan⁻¹(0.5)")
        
        sut.setOperand(-1)
        sut.performOperation("tan⁻¹RAD")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.785398163397448, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan⁻¹(-1)")
        
        sut.clear()
        sut.setOperand(2)
        sut.performOperation("²√ₓ")
        sut.performOperation("¹/ₓ")
        sut.performOperation("tan⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.615479708670387, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan⁻¹(√2⁻¹)")
        
        sut.clear()
        sut.setOperand(3)
        sut.performOperation("²√ₓ")
        sut.performOperation("÷")
        sut.setOperand(2)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("=")
        sut.performOperation("tan⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.713724378944766, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan⁻¹(√3÷˗(2))")
        
        sut.setOperand(1)
        sut.performOperation("tan⁻¹RAD")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.785398163397448, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan⁻¹(1)")
    }
    
    //MARK: HYPERBOLIC
    func testSinH() {
        sut.performOperation("π")
        sut.performOperation("sinh")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 11.54873935725775, accuracy: 0.00000000000001)
        XCTAssertEqual(result.expressionString, "sinh(π)")
        
        sut.setOperand(0)
        sut.performOperation("sinh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sinh(0)")
        
        sut.setOperand(2)
        sut.performOperation("㏑")
        sut.performOperation("sinh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.75, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sinh(㏑(2))")
        
        sut.clear()
        sut.setOperand(1)
        sut.performOperation("=")
        sut.performOperation("sinh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.175201193643801, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sinh(1)")
        
        sut.clear()
        sut.setOperand(0.5)
        sut.performOperation("㏑")
        sut.performOperation("sinh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.75, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sinh(㏑(0.5))")
    }
    
    func testCosH() {
        sut.performOperation("π")
        sut.performOperation("cosh")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 11.59195327552152, accuracy: 0.00000000000001)
        XCTAssertEqual(result.expressionString, "cosh(π)")
        
        sut.setOperand(0)
        sut.performOperation("cosh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cosh(0)")
        
        sut.setOperand(2)
        sut.performOperation("㏑")
        sut.performOperation("cosh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.25, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cosh(㏑(2))")
        
        sut.clear()
        sut.setOperand(1)
        sut.performOperation("=")
        sut.performOperation("cosh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.543080634815244, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cosh(1)")
        
        sut.clear()
        sut.setOperand(0.5)
        sut.performOperation("㏑")
        sut.performOperation("cosh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.25, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cosh(㏑(0.5))")
    }
    
    func testTanH() {
        sut.performOperation("π")
        sut.performOperation("tanh")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.99627207622075, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh(π)")
        
        sut.setOperand(0)
        sut.performOperation("tanh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh(0)")
        
        sut.setOperand(2)
        sut.performOperation("㏑")
        sut.performOperation("tanh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.6, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh(㏑(2))")
        
        sut.clear()
        sut.setOperand(1)
        sut.performOperation("=")
        sut.performOperation("tanh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.761594155955765, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh(1)")
        
        sut.clear()
        sut.setOperand(0.5)
        sut.performOperation("㏑")
        sut.performOperation("tanh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.6, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh(㏑(0.5))")
        
        sut.setOperand(3)
        sut.performOperation("㏑")
        sut.performOperation("tanh")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.8, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh(㏑(3))")
    }
    
    //MARK: INVERSE HYPERBOLIC
    func testSinH⁻¹() {
        sut.setOperand(0)
        sut.performOperation("sinh⁻¹")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sinh⁻¹(0)")
        
        sut.setOperand(1)
        sut.performOperation("sinh⁻¹")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.881373587019543, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sinh⁻¹(1)")
        
        sut.setOperand(1)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("sinh⁻¹")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.881373587019543)
        XCTAssertEqual(result.expressionString, "sinh⁻¹(˗(1))")
        
        sut.clear()
        sut.performOperation("e")
        sut.performOperation("ᐩ/˗")
        sut.performOperation("sinh⁻¹")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -1.725382558852315, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sinh⁻¹(˗(e))")
    }
    
    func testCosH⁻¹() {
        sut.setOperand(0)
        sut.performOperation("cosh⁻¹")
        var result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "cosh⁻¹(0)")
        
        sut.setOperand(1)
        sut.performOperation("cosh⁻¹")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cosh⁻¹(1)")
        
        sut.setOperand(1)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("cosh⁻¹")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "cosh⁻¹(˗(1))")
        
        sut.clear()
        sut.performOperation("e")
        sut.performOperation("cosh⁻¹")
        sut.performOperation("=")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.657454454153077, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cosh⁻¹(e)")
    }
    
    func testTanH⁻¹() {
        sut.setOperand(0)
        sut.performOperation("tanh⁻¹")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh⁻¹(0)")
        
        sut.setOperand(1)
        sut.performOperation("tanh⁻¹")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "tanh⁻¹(1)")
        
        sut.setOperand(0.5)
        sut.performOperation("tanh⁻¹")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.549306144334055, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh⁻¹(0.5)")
        
        sut.setOperand(2)
        sut.performOperation("㏑")
        sut.performOperation("tanh⁻¹")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.853988047997524, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh⁻¹(㏑(2))")
        
        sut.setOperand(0.85398804799754)
        sut.performOperation("tanh⁻¹")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1.270702909056732, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh⁻¹(0.853988048)")
        
        sut.setOperand(0.28)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("tanh⁻¹")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.287682072451781, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tanh⁻¹(˗(0.28))")
    }
    
    //MARK: DEGREES
    //MARK: BASIC
    func testSinDegrees() {
        sut.setOperand(0)
        sut.performOperation("sin")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(0°)")
        
        sut.setOperand(30)
        sut.performOperation("sin")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.5, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(30°)")
        
        sut.setOperand(30)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("sin")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.5, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(˗(30)°)")

        sut.setOperand(270)
        sut.performOperation("=")
        sut.performOperation("sin")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -1, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(270°)")
        
        sut.clear()
        sut.setOperand(45)
        sut.performOperation("=")
        sut.performOperation("sin")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.707106781186548, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(45°)")
        
        sut.clear()
        sut.setOperand(300)
        sut.performOperation("=")
        sut.performOperation("sin")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.866025403784439, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(300°)")
        
        sut.setOperand(360)
        sut.performOperation("sin")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(360°)")
        
        sut.performOperation("π")
        sut.performOperation("sin")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.05480366514879, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "sin(π°)")
    }
    
    func testCosDegrees() {
        sut.setOperand(0)
        sut.performOperation("cos")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 1, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(0°)")
        
        sut.setOperand(30)
        sut.performOperation("cos")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.866025403784439, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(30°)")
        
        sut.setOperand(30)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("cos")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.866025403784439, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(˗(30)°)")

        sut.setOperand(270)
        sut.performOperation("=")
        sut.performOperation("cos")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(270°)")
        
        sut.clear()
        sut.setOperand(45)
        sut.performOperation("=")
        sut.performOperation("cos")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.707106781186548, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(45°)")
        
        sut.clear()
        sut.setOperand(300)
        sut.performOperation("=")
        sut.performOperation("cos")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.5, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(300°)")
        
        sut.setOperand(360)
        sut.performOperation("cos")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(360°)")
        
        sut.performOperation("π")
        sut.performOperation("cos")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.998497149863864, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "cos(π°)")
    }
    
    func testTanDegrees() {
        sut.setOperand(0)
        sut.performOperation("tan")
        var result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(0°)")
        
        sut.setOperand(30)
        sut.performOperation("tan")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.577350269189626, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(30°)")
        
        sut.setOperand(30)
        sut.performOperation("ᐩ/˗")
        sut.performOperation("tan")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -0.577350269189626, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(˗(30)°)")

        sut.setOperand(270)
        sut.performOperation("=")
        sut.performOperation("tan")
        result = sut.evaluate()
        XCTAssertNotNil(result.error)
        XCTAssertEqual(result.expressionString, "tan(270°)")
        
        sut.clear()
        sut.setOperand(45)
        sut.performOperation("=")
        sut.performOperation("tan")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 1, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(45°)")
        
        sut.clear()
        sut.setOperand(300)
        sut.performOperation("=")
        sut.performOperation("tan")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, -1.732050807568877, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(300°)")
        
        sut.setOperand(360)
        sut.performOperation("tan")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(360°)")
        
        sut.performOperation("π")
        sut.performOperation("tan")
        result = sut.evaluate()
        XCTAssertEqual(result.result!, 0.054886150808003, accuracy: 0.000000000000001)
        XCTAssertEqual(result.expressionString, "tan(π°)")
    }

}
