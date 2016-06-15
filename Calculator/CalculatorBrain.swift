//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by feifeipan on 16/4/29.
//  Copyright © 2016年 feifeipan. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: CustomStringConvertible{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        
        var description: String{
            get{
                switch self{
                case .Operand(let operation):
                    return "\(operation)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    private func evaluate(ops:[Op]) -> (result:Double?, remainingOps:[Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return(operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operandEvaluation1 = evaluate(remainingOps)
                if let operand1 = operandEvaluation1.result{
                    let operandEvaluation2 = evaluate(operandEvaluation1.remainingOps)
                    if let operand2 = operandEvaluation2.result{
                        return(operation(operand1,operand2), operandEvaluation2.remainingOps)
                    }
                }
                
            }
        }
        return (nil, ops)
    }
    
    
    func evaluteTotal() -> Double?{
        let (result, remainingOps) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainingOps) left over")
        return result
    }
    
    init(){
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷", {$1 / $0})
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−", {$1 - $0})
        knownOps["√"] = Op.UnaryOperation("√",sqrt)
    }
    
    func pushOperand(operand:Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluteTotal()
    }
    
    func performOperation(symbol:String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluteTotal()
    }
}
