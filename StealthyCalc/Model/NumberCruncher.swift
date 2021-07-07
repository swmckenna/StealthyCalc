//
//  NumberCruncher.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/4/21.
//

import Foundation

struct NumberCruncher {
    private typealias Tally = (Double, String)
    private enum Operation {
        case constant(Double)
        case unary((Tally) -> Tally)
        case binary((Tally, Double) -> Tally)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let f: (Tally, Double) -> Tally
        let lhs: Tally
        
        func perform(with rhs: Double) -> Tally {
            return f(lhs, rhs)
        }
    }
    
    var result: Double? {
        get {
            return tally?.value
        }
    }
    private var tally: (value:Double, expression:String)?
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var operationsDict = [
        "ᐩ/˗": Operation.unary({ (-$0.0, "-(\($0.1))") }), //TODO: parenthesis depends on if contains binary operation
        "%": Operation.unary({ ($0.0 / 100.0, "(\($0.1))%") }), //TODO: parenthesis depends on if contains binary operation
        "÷": Operation.binary({ ($0.0 / $1, "\($0.1)/\($1)") }),
//        "×": Operation.binary({ $0 * $1 }),
//        "−": Operation.binary({ $0 - $1 }),
//        "+": Operation.binary({ $0 + $1 }),
        "=": Operation.equals
    ]
    
    mutating func setOperand(_ value: Double) {
        let string = String(value)
        let newExpression: String = tally?.expression ?? "" + string
        tally = (value, newExpression)
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operationsDict[symbol] {
            switch operation {
            case .unary(let function):
                if let tally = tally {
                    self.tally = function(tally)
                }
            case .binary(let function):
                if let tally = tally {
                    pendingBinaryOperation = PendingBinaryOperation(f: function, lhs: tally)
                }
            case .equals:
                performPendingBinaryOperation()
            default:
                break
            }
        }
    }
    
    mutating func performPendingBinaryOperation() {
        if let pbo = pendingBinaryOperation, let tally = tally {
            self.tally = pbo.perform(with: tally.value)
            pendingBinaryOperation = nil
        }
    }
    
}
