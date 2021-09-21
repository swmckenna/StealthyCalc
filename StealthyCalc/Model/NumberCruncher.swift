//
//  NumberCruncher.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/4/21.
//

import Foundation

struct CalculatedResult {
    var result: Double? = nil
    var resultIsPending: Bool = false
    var negativeIsPending: Bool = false
    var expressionString: String = ""
    var error: String? = nil
}

struct NumberCruncher {
    typealias NullaryFunction = (() -> (result: Double, stringResult: String))
    typealias UnaryMathFunction = ((_ operand: Double) -> Double)
    typealias UnaryStringFunction = ((_ operand: String) -> String)
    typealias UnaryValidationFunction = ((_ operand: Double) -> String?)
    typealias BinaryMathFunction = ((_ firstOperand: Double, _ secondOperand: Double) -> Double)
    typealias BinaryStringFunction = ((_ firstOperand: String, _ secondOperand: String) -> String)
    typealias BinaryValidationFunction = ((_ firstOperand: Double, _ secondOperand: Double) -> String?)
    typealias RepeatsOnEquals = Bool
    typealias Precedence = Int
    
    private enum ExpressionElement {
        case operand(Double)
        case operation(String)
    }
    
    private enum Operation {
        case constant(Double)
        case nullary(NullaryFunction)
        case unary(UnaryMathFunction, UnaryStringFunction?, UnaryValidationFunction?, RepeatsOnEquals)
        case binary (BinaryMathFunction, BinaryStringFunction?, BinaryValidationFunction?, Precedence, RepeatsOnEquals)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let mathFunction: BinaryMathFunction
        var stringFunction: BinaryStringFunction
        let firstOperand: Double
        var firstOperandString: String
        var validation: BinaryValidationFunction?
        var prevPrecedence: Int
        var precedence: Int
        
        func performMath(with secondOperand: Double) -> Double {
            return mathFunction(firstOperand, secondOperand)
        }
        
        func performString(with secondStringOperand: String) -> String {
            var newStringOp = firstOperandString
            if prevPrecedence < precedence {
                newStringOp = "(\(newStringOp))"
            }
            return stringFunction(newStringOp, secondStringOperand)
        }
        
        func validate(with secondOperand: Double) -> String? {
            guard let validation = validation else { return nil }
            return validation(firstOperand, secondOperand)
        }
    }
    
    private var expressionStack = [ExpressionElement]()
    private var operationsDict = [
        "Rand": Operation.nullary({
            return (Double(arc4random())/Double(UInt32.max), "RAND")
        }),
        "e": Operation.constant(M_E),
        "π": Operation.constant(Double.pi),
        "ᐩ/˗": Operation.unary({ -$0 }, { "˗(\($0))" }, nil, false),
        "%": Operation.unary({ $0 / 100 }, { "\($0)%" }, nil, false),
        "х²": Operation.unary({ $0 * $0 }, { "\($0)²" }, nil, true),
        "х³": Operation.unary({ $0 * $0 * $0 }, { "\($0)³" }, nil, true),
        "eˣ": Operation.unary({ pow(M_E, $0) }, { "e^\($0)" }, nil, true),
        "10ˣ": Operation.unary({ pow(10, $0) }, { "10^\($0)" }, nil, false),
        "2ˣ": Operation.unary({ pow(2, $0) }, { "2^\($0)" }, nil, false),
        "¹/ₓ": Operation.unary({ 1/$0 }, { "\($0)⁻¹" }, {$0 == 0 ? "Error" : nil}, false),
        "²√ₓ": Operation.unary({ sqrt($0) }, { "√\($0)" }, { $0 < 0 ? "Error" : nil }, true),
        "³√ₓ": Operation.unary({ pow($0, 1/3) }, { "³√\($0)" }, nil, true),
        "㏑": Operation.unary({ log($0) } , { "㏑(\($0))" }, { $0 <= 0 ? "Error" : nil }, false),
        "㏒₁₀": Operation.unary({ log10($0) }, { "㏒₁₀(\($0)" }, { $0 <= 0 ? "Error" : nil }, false),
        "㏒₂": Operation.unary({ log2($0) }, { "㏒₂(\($0)" }, { $0 <= 0 ? "Error" : nil }, false),
//        "х!": Operation.unary({ $0! }, { "\($0)!" }, { $0 < 0 ? "Error" : nil }, false),
        "sin": Operation.unary({ sin($0) }, { "sin(\($0)" }, nil, false),
        "cos": Operation.unary({ cos($0) }, { "cos(\($0)" }, nil, false),
        "tan": Operation.unary({ tan($0) }, { "tan(\($0)" }, nil, false),
        "sinh": Operation.unary({ sinh($0) }, { "sinh(\($0)" }, nil, false),
        "cosh": Operation.unary({ cosh($0) }, { "cosh(\($0)" }, nil, false),
        "tanh": Operation.unary({ tanh($0) }, { "tanh(\($0)" }, nil, false),
        "sin⁻¹": Operation.unary({ asin($0) }, { "sin⁻¹(\($0))"}, { $0 < -1.0 || $0 > 1.0 ? "Error": nil }, false),
        "cos⁻¹": Operation.unary({ acos($0) }, { "cos⁻¹(\($0))"}, { $0 < -1.0 || $0 > 1.0 ? "Error": nil }, false),
        "tan⁻¹": Operation.unary({ atan($0) }, { "tan⁻¹(\($0))"}, nil, false),
        "sinh⁻¹": Operation.unary({ asinh($0) }, { "sinh⁻¹(\($0))"}, nil, false),
        "cosh⁻¹": Operation.unary({ acosh($0) }, { "cosh⁻¹(\($0))"}, nil, false),
        "tanh⁻¹": Operation.unary({ atanh($0) }, { "tanh⁻¹(\($0))"}, { $0 <= -1.0 || $0 >= 1.0 ? "Error": nil }, false),
        "ʸ√ₓ": Operation.binary({ pow($0, 1/$1) }, { "\($1)√\($0)" }, /*something here*/nil, 2, true),
        "xʸ": Operation.binary({ pow($0, $1) }, { "\($0)^\($1)" }, nil, 2, true),
        "yˣ": Operation.binary({ pow($1, $0) }, { "\($1)^\($0)" }, nil, 2, true),
        "㏒ₓ": Operation.binary({ log($0)/log($1) }, {"㏑(\($0))/㏑(\($1))"}, { $0 <= 0 || $1 <= 0 ? "Error" : nil }, 2, true), //should be log(y)
        "÷": Operation.binary({ $0/$1 }, nil, { $1 == 0 || $1 == -0 ? "Error" : nil }, 1, true),
        "×": Operation.binary({ $0*$1 }, nil, nil, 1, true),
        "−": Operation.binary({ $0-$1 }, nil, nil, 0, true),
        "+": Operation.binary({ $0+$1 }, nil, nil, 0, true),
        "=": Operation.equals
    ]
    #warning("Need a more thorough validation check for the variable root") //6
    #warning("Need a function for factorial that avoids stack overflow") //5
    #warning("change signs to better match iOS calculator, fix log(x/y)")
    #warning("Add parenthesis")
    #warning("Add memory (m+ m- mc mr)") //3
    #warning("Test clear and defined operations")
    #warning("Add Rad and Deg") //4
    
    mutating func setOperand(_ operand: Double) {
        expressionStack.append(ExpressionElement.operand(operand))
    }
    
    mutating func performOperation(_ symbol: String) {
        expressionStack.append(ExpressionElement.operation(symbol))
    }
    
    mutating func clear() {
        expressionStack.removeAll()
    }
    
    mutating func undo() {
        if !expressionStack.isEmpty {
            expressionStack.removeLast()
        }
    }
    
    func evaluate() -> CalculatedResult {
        var cache: (accumulator: Double?, expressionAccumulator: String?)
        var error: String?
        var prevPrecedence = Int.max
        var operationOfRecord: (symbol: String, operand: Double?)?
        var pbo: PendingBinaryOperation?
        var negativeIsPending = false
        
        var expressionString: String? {
            get {
                if pbo == nil {
                    return cache.expressionAccumulator
                } else {
                    return pbo!.stringFunction(pbo!.firstOperandString, cache.expressionAccumulator ?? "")
                }
            }
        }
        
        var result: Double? {
            get {
                return cache.accumulator
            }
        }
        
        var resultIsPending: Bool {
            get {
                return pbo != nil
            }
        }
        
        func setOperand(_ operand: Double) {
            cache.accumulator = operand
            if let value = cache.accumulator {
                cache.expressionAccumulator = DisplayNumberFormatter.formatter.string(from: NSNumber(value: value)) ?? ""
                prevPrecedence = Int.max
            }
        }
        
        func performOperation(_ symbol: String) {
            if let operation = operationsDict[symbol] {
                error = nil
                switch operation {
                case .constant(let value):
                    cache = (accumulator: value, expressionAccumulator: symbol)
                    
                case .nullary(let nullaryFunction):
                    let function = nullaryFunction()
                    cache = (accumulator: function.result, expressionAccumulator: function.stringResult)
                    
                case .unary(let mathFunction, var stringFunction, let validationFunction, let repeats):
                    if let accumulator = cache.accumulator {
                        error = validationFunction?(accumulator)
                        cache.accumulator = mathFunction(accumulator)
                        if repeats {
                            operationOfRecord = (symbol, nil)
                        }
                        if stringFunction == nil {
                            stringFunction = { "\(symbol)(\($0))" }
                        }
                        cache.expressionAccumulator = stringFunction!(cache.expressionAccumulator!)
                    } else if symbol == "ᐩ/˗" {
                        negativeIsPending = !negativeIsPending
                        cache.accumulator = 0
                        cache.expressionAccumulator = "0"
                    }
                    
                case .binary(let mathFunction, var stringFunction, let validationFunction, let precedence, let repeats):
                    performPendingBinaryOperation()
                    if let accumulator = cache.accumulator {
                        if stringFunction == nil {
                            stringFunction = { "\($0)\(symbol)\($1)" }
                        }
                        pbo = PendingBinaryOperation(mathFunction: mathFunction,
                                                     stringFunction: stringFunction!,
                                                     firstOperand: accumulator,
                                                     firstOperandString: cache.expressionAccumulator!,
                                                     validation: validationFunction,
                                                     prevPrecedence: prevPrecedence,
                                                     precedence: precedence)
                        if repeats {
                            operationOfRecord = (symbol, nil)
                        }
                        cache = (nil, nil)
                    }
                    
                case .equals:
                    if let opOfRecord = operationOfRecord,
                       let op = operationsDict[opOfRecord.symbol] {
                        switch op {
                        case .unary(_, _, _, _):
                            performOperation(opOfRecord.symbol)
                        case .binary(let math, let string, let valid, let prec, _):
                            if let firstOperand = cache.accumulator,
                               let firstOperandString = cache.expressionAccumulator,
                               let secondOperand = opOfRecord.operand {
                                let pb = PendingBinaryOperation(mathFunction: math, stringFunction: string ?? { "\($0)\(opOfRecord.symbol)\($1)" }, firstOperand: firstOperand, firstOperandString: firstOperandString, validation: valid, prevPrecedence: prevPrecedence, precedence: prec)
                                error = pb.validate(with: secondOperand)
                                cache.accumulator = pb.performMath(with: secondOperand)
                                cache.expressionAccumulator = pb.performString(with: DisplayNumberFormatter.formatter.string(from: NSNumber(value: secondOperand)) ?? "")
                                prevPrecedence = pb.precedence
                            }
                        default:
                            break
                        }
                    }
                    performPendingBinaryOperation()
                }
            }
        }
        
        func performPendingBinaryOperation() {
            if negativeIsPending {
                performOperation("ᐩ/˗")
            }
            negativeIsPending = false
            if let pb = pbo, let accumulator = cache.accumulator, let exp = cache.expressionAccumulator {
                //run the math and string functions, update cache
                error = pb.validate(with: accumulator)
                cache.accumulator = pb.performMath(with: accumulator)
                cache.expressionAccumulator = pb.performString(with: exp)
                prevPrecedence = pb.precedence
                if let symbol = operationOfRecord?.symbol,
                   case let Operation.binary(_, _, _, _, repeats) = operationsDict[symbol]!,
                   repeats {
                    operationOfRecord?.operand = accumulator
                }
                pbo = nil
            }
        }
    
        //MARK: EVALUATE()
        guard !expressionStack.isEmpty else { return CalculatedResult() }
        prevPrecedence = Int.max
        pbo = nil
        for element in expressionStack {
            switch element {
            case .operand(let operand):
                setOperand(operand)
            case .operation(let operation):
                performOperation(operation)
            }
        }
        return CalculatedResult(result: result, resultIsPending: resultIsPending, negativeIsPending: negativeIsPending, expressionString: expressionString ?? "", error: error)
        //

    }
      
}
