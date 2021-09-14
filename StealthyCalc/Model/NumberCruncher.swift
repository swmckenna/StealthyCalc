//
//  NumberCruncher.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/4/21.
//

import Foundation

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
        "ᐩ/˗": Operation.unary({-$0}, {"˗(\($0))"}, nil, false),
        "%": Operation.unary({$0 / 100}, {"\($0)%"}, nil, false),
        "х²": Operation.unary({$0 * $0}, { "\($0)²"}, nil, true),
        "÷": Operation.binary({ $0/$1 }, nil, { $1 == 0 || $1 == -0 ? "Error" : nil }, 1, true),
        "×": Operation.binary({ $0*$1 }, nil, nil, 1, true),
        "+": Operation.binary({ $0+$1 }, nil, nil, 0, true),
        "=": Operation.equals
    ]
    
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
    
    func evaluate() -> (result: Double?, resultIsPending: Bool, negativeIsPending: Bool, expressionString: String, error: String?) {
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
                        cache.expressionAccumulator = "˗(0)"
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
        guard !expressionStack.isEmpty else { return (result: nil, resultIsPending: false, negativeIsPending: false, expressionString: "", error: nil) }
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
        return (result, resultIsPending, negativeIsPending, expressionString ?? "", error)
        //

    }
      
}
