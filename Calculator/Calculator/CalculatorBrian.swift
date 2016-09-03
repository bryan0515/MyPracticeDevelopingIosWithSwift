//
//  CalculatorBrian.swift
//  Calculator
//
//  Created by Bryan Cheng on 2016/9/1.
//  Copyright (c) 2016年 Bryan Cheng. All rights reserved.
//

import Foundation

class CalculatorBrian {
    
    private enum Op: Printable {
        case Operand(Double)
        case NullaryOperation(String, Double)
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
                case .NullaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }

    private var opStack = [Op]()
    
    private var knownOp = [String:Op]()

    init() {
        func learnOp(op:Op) {
            knownOp[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        knownOp["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOp["+"] = Op.BinaryOperation("+", +)
        knownOp["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOp["√"] = Op.UnaryOperation("√", sqrt)
        knownOp["sin"] = Op.UnaryOperation("sin", sin)
        knownOp["cos"] = Op.UnaryOperation("cos", cos)
        knownOp["π"] = Op.NullaryOperation("π", M_PI)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .NullaryOperation(_, let constant):
                return (constant, remainingOps)
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOp[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func getStack() -> String {
        return "\(opStack)"
    }
    
    func removeAllOpStack() {
        opStack.removeAll(keepCapacity: false)
        println("stack cleared: \(opStack)")
    }
}