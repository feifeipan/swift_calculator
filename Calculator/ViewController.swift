//
//  ViewController.swift
//  Calculator
//
//  Created by feifeipan on 16/4/26.
//  Copyright © 2016年 feifeipan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTyping: Bool = false
    
    let brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsInTheMiddleOfTyping){
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
        
    }
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping{
            enter()
        }
        
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
        
    }
    
    var displayValue :Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
        }
    }
}

