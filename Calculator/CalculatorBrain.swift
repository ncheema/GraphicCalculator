//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Navjot Cheema on 10/18/15.
//  Copyright © 2015 Navjot Cheema. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
            
        }
    }
    
    init() {
        func learnOp(op : Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷", {$1 / $0}))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-", {$1 - $0}))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("Sin", sin))
        learnOp(Op.UnaryOperation("Cos", cos))
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    //helper
    private func evaluate(ops: [Op]) -> (result: Double?, remainingStack: [Op], operationCalculated : String) {
        if (!ops.isEmpty) {
            var remainingOps = ops
            let op  = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps, "\(operand)")
            case .UnaryOperation(let symbol, let operation):
                let opEval = evaluate(remainingOps)
                if let op1 = opEval.result {
                    return(operation (op1), opEval.remainingStack, symbol + " ( \(op1) )")
                }
            case .BinaryOperation(let symbol, let operation):
                let opEval = evaluate(remainingOps)
                if let op1 = opEval.result {
                    let opEval2 = evaluate(opEval.remainingStack)
                    if let op2 = opEval2.result {
                        return (operation(op1, op2), opEval2.remainingStack, " [ \(op1) " + symbol + " \(op2) ]")
                    }
                }
                
                
            }
        }
        return(nil, ops, "Error")
        
    }
    
    func evaluate () -> Double? {
        let (result, remainder, evaluatedOperation) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over" )
        print(evaluatedOperation)
        return result
    }
    
    
    // FIXME: make return optional or figure out a better way to reset screen
    func clearStack() -> Double {
        opStack.removeAll()
        return 0.0
    }
}




