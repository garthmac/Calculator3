//
//  CalculatorBrain.swift
//  Calculator3
//
//  Created by iMac21.5 on 4/13/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .UnaryOperation(let mathString, _):
                        return "\(mathString)"
                    case .BinaryOperation(let mathString, _):
                        return "\(mathString)"
                }
            }
        }
    }

    var opStack = [Op]()
    private var knownOps = [String:Op]()   // Dictionary<String, Op>()
    
    // let brain = CalculatorBrain()  is the caller (viewC)
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(.BinaryOperation("×", *))
        learnOp(.BinaryOperation("÷", { $1 / $0 } ))
        learnOp(.BinaryOperation("+", +))
        learnOp(.BinaryOperation("−", { $1 - $0 } ))
        learnOp(.BinaryOperation("xʸ", { pow($1, $0) }))
        learnOp(.UnaryOperation("¹/x", { 1.0 / $0 } ))
        learnOp(.UnaryOperation("x²", { $0 * $0 } ))
        learnOp(.UnaryOperation("√", { sqrt(abs($0)) } ))
        learnOp(.UnaryOperation("sin", sin))
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["tan"] = Op.UnaryOperation("tan", tan)
        knownOps["∛"] = Op.UnaryOperation("∛") { cbrt(abs($0)) }
        knownOps["⁺/−"] = Op.UnaryOperation("⁺/−") { -1.0 * $0 }
        knownOps["eˣ"] = Op.UnaryOperation("eˣ") { pow(M_E, $0) }
    }
    
    // recursively call helper function "evaluate(ops)" [6, 5, +, 4, x]...4*(5+6)
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops  // copy of stack
            let op = remainingOps.removeLast()
            switch op {
                case .Operand(let operand):
                    return (operand, remainingOps)
                case .UnaryOperation(_, let operation):
                    let operandEval = evaluate(remainingOps)  //tuple.result
                    if let operand = operandEval.result {
                        return (operation(operand), operandEval.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let operandEval1 = evaluate(remainingOps)
                    if let operand1 = operandEval1.result {
                        let operandEval2 = evaluate(operandEval1.remainingOps)
                        if let operand2 = operandEval2.result {
                            return (operation(operand1, operand2), operandEval2.remainingOps)
                        }
                    }
            }
        }
        return(nil, ops)
    }
    func evaluate() -> Double? {  //don't care about remainder... _
        let (result, _) = evaluate(opStack) // tuple = eval entire stack copy
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(mathQuote: String) -> Double? {
        if let operation = knownOps[mathQuote] {
            opStack.append(operation)
        }
        return evaluate()
    }
}