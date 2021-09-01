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
    typealias Precedence = Int
    
    private enum ExpressionElement {
        case operand(Double)
        case operation(String)
    }
    
    private enum Operation {
        case constant(Double)
        case nullary(NullaryFunction)
        case unary(UnaryMathFunction, UnaryStringFunction?, UnaryValidationFunction?)
        case binaryOperation (BinaryMathFunction, BinaryStringFunction?, BinaryValidationFunction?, Precedence)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let mathFunction: BinaryMathFunction
        var stringFunction: BinaryStringFunction
        let firstOperand: Double
        var firstStringOperand: String
        var validation: BinaryValidationFunction?
        var prevPrecedence: Int
        var precedence: Int
        
        func performMath(with secondOperand: Double) -> Double {
            return mathFunction(firstOperand, secondOperand)
        }
        
        func performString(with secondStringOperand: String) -> String {
            var newStringOp = firstStringOperand
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
        "ᐩ/˗": Operation.unary({-$0}, nil, nil),
        "÷": Operation.binaryOperation({ $0/$1 }, nil, { $1 == 0 ? "Error" : nil }, 1)
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
    
    func evaluate() -> (tally: Double?, isPending: Bool, expressionString: String, error: String?) {
        var cache: (tally: Double?, expressionAccumulator: String?)
        var error: String?
        var prevPrecedence = Int.max
        var pbo: PendingBinaryOperation?
        
        var expressionString: String? {
            get {
                if pbo == nil {
                    return cache.expressionAccumulator
                } else {
                    return pbo!.stringFunction(pbo!.firstStringOperand, cache.expressionAccumulator ?? "")
                }
            }
        }
        
        var result: Double? {
            get {
                return cache.tally
            }
        }
        
        var resultIsPending: Bool {
            get {
                return pbo != nil
            }
        }
        
        func setOperand(_ operand: Double) {
            cache.tally = operand
            if let value = cache.tally {
                cache.expressionAccumulator = DisplayNumberFormatter.formatter.string(from: NSNumber(value: value)) ?? ""
                prevPrecedence = Int.max
            }
        }
        
        func performOperation(_ symbol: String) {
            if let operation = operationsDict[symbol] {
                error = nil
                switch operation {
                case .constant(let value):
                    cache = (tally: value, expressionAccumulator: symbol)
                    
                case .nullary(let nullaryFunction):
                    let function = nullaryFunction()
                    cache = (tally: function.result, expressionAccumulator: function.stringResult)
                    
                case .unary(let mathFunction, var stringFunction, let validationFunction):
                    if let tally = cache.tally {
                        error = validationFunction?(tally)
                        cache.tally = mathFunction(tally)
                        if stringFunction == nil {
                            stringFunction = { "\(symbol)(\($0))" }
                        }
                        cache.expressionAccumulator = stringFunction!(cache.expressionAccumulator!)
                    }
                    
                case .binaryOperation(let mathFunction, var stringFunction, let validationFunction, let precedence):
                    performPendingBinaryOperation()
                    if let tally = cache.tally {
                        if stringFunction == nil {
                            stringFunction = { "\($0) \(symbol) \($1)" }
                        }
                        pbo = PendingBinaryOperation(mathFunction: mathFunction,
                                                     stringFunction: stringFunction!,
                                                     firstOperand: tally,
                                                     firstStringOperand: cache.expressionAccumulator!,
                                                     validation: validationFunction,
                                                     prevPrecedence: prevPrecedence,
                                                     precedence: precedence)
                        cache = (nil, nil)
                    }
                    
                case .equals:
                    performPendingBinaryOperation()
                }
            }
        }
        
        func performPendingBinaryOperation() {
            if let pb = pbo, let tally = cache.tally, let exp = cache.expressionAccumulator {
                error = pb.validate(with: tally)
                cache.tally = pb.performMath(with: tally)
                cache.expressionAccumulator = pb.performString(with: exp)
                prevPrecedence = pb.precedence
                pbo = nil
            }
        }
    
        //Actual meat of the function here
        guard !expressionStack.isEmpty else { return (tally: nil, isPending: false, expressionString: " ", error: nil) }
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
        return (result, resultIsPending, expressionString ?? " ", error)
        //

    }
    

    
//    private typealias Tally = (Double, String)
//    private typealias Precedence = Int
//    private typealias IsCommutative = Bool
//    private enum Operation {
//        case constant(Double)
//        case unary((Tally) -> Tally)
//        case binary(Precedence, IsCommutative, (Tally, Double) -> Tally)
//        case equals
//    }
//
//    private struct PendingBinaryOperation {
//        let f: (Tally, Double) -> Tally
//        let lhs: Tally
//
//        func perform(with rhs: Double) -> Tally {
//            return f(lhs, rhs)
//        }
//    }
//
//    var result: Double? {
//        get {
//            return tally?.value
//        }
//    }
//
//    var equation: String? {
//        get {
//            return tally?.expression
//        }
//    }
//
//    private var tally: (value:Double, expression:String)?
//    private var pendingBinaryOperation: PendingBinaryOperation?
//    private var operationsDict = [
//        "ᐩ/˗": Operation.unary({ (-$0.0, self.pendingBinaryOperation == nil &&  "˗\($0.1)") }), //TODO: parenthesis depends on if contains binary operation
//        "%": Operation.unary({ ($0.0 / 100.0, "(\($0.1))%") }), //TODO: parenthesis depends on if contains binary operation
//        "÷": Operation.binary(2, false, { ($0.0 / $1, "\($0.1)÷" + DisplayNumberFormatter.formatter.string(from: NSNumber(value: $1))!) }),
////        "×": Operation.binary({ $0 * $1 }),
////        "−": Operation.binary({ $0 - $1 }),
////        "+": Operation.binary({ $0 + $1 }),
//        "=": Operation.equals //TODO: add "=" in UI (not in number cruncher tally)
//    ]
//
//    mutating func setOperand(_ value: Double) {
//        let string = DisplayNumberFormatter.formatter.string(from: NSNumber(value: value))!
//        let newExpression: String = tally?.expression ?? "" + string
//        tally = (value, newExpression)
//    }
//
//    mutating func performOperation(_ symbol: String) {
//        if let operation = operationsDict[symbol] {
//            switch operation {
//            case .unary(let function):
//                if let tally = tally {
//                    self.tally = function(tally)
//                }
//            case .binary(_, _, let function):
//                if let tally = tally {
//                    pendingBinaryOperation = PendingBinaryOperation(f: function, lhs: tally)
//                }
//            case .equals:
//                performPendingBinaryOperation()
//            default:
//                break
//            }
//        }
//    }
//
//    mutating func performPendingBinaryOperation() {
//        if let pbo = pendingBinaryOperation, let tally = tally {
//            self.tally = pbo.perform(with: tally.value)
//            pendingBinaryOperation = nil
//        }
//    }
    
}
