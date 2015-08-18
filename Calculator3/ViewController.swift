//
//  ViewController.swift
//  Calculator3
//
//  Created by iMac21.5 on 4/13/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()  // arrow... ctlr to model
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }
        else {
            display.text! = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
//    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
//        operandStack.append(displayValue)
//        stackDisplay.text = "\(operandStack)"
//        println("stack = \(operandStack)")
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
            stackDisplay.text = "\(brain.opStack)"
        }
        else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
//        switch operation {
//        case "×": performOperation { $1 * $0 }
//        case "÷": performOperation { $1 / $0 }
//        case "+": performOperation { $1 + $0 }
//        case "−": performOperation { $1 - $0 }
//        case "xʸ": performOperation { pow($1, $0) }
//        case "¹/x": performOperation2 { 1.0 / $0 }
//        case "x²": performOperation2 { $0 * $0 }
//        case "√": performOperation2 { sqrt(abs($0)) }
//        case "sin": performOperation2 { sin($0) }
//        case "cos": performOperation2 { cos($0) }
//        case "tan": performOperation2 { tan($0) }
//        case "∛": performOperation2 { cbrt(abs($0)) }
//        case "⁺/−": performOperation2 { -1.0 * $0 }
//        case "eˣ": performOperation2 { pow(M_E, $0) }
//        default: break
//        }
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
            else {
                displayValue = 0
            }
        }
    }
    
//    func performOperation(operation: (Double, Double) -> Double) {
//        if operandStack.count >= 2 {
//            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
//            enter()
//        }
//    }
//    
//    func performOperation2(operation: Double -> Double) {
//        if operandStack.count >= 1 {
//            displayValue = operation(operandStack.removeLast())
//            enter()
//        }
//    }
    
    @IBAction func e() {
        display.text = "\(M_E)"
        enter()
    }
    
    @IBAction func randomUInt32() {
        let min = 2
        let max = 12
        let dice = (Int(arc4random() % 11) + 2)
        //  https://developer.apple.com/library/ios/documentation/System/Conceptual/ManPages_iPhoneOS/man3/arc4random.3.html
        display.text = "\(dice)"
        enter()
    }
    
    @IBAction func perCent(sender: UIButton) {
        display.text = "\(displayValue / 100)"
        enter()
    }
    
    @IBAction func pi(sender: UIButton) {
        display.text = "\(M_PI)"
        enter()
    }
    var mem = 0.0
    @IBAction func memoryClear() {
        mem = 0.0
    }
    
    @IBAction func memoryAdd() {
        mem = mem + displayValue
    }
    
    @IBAction func memoryMinus() {
        mem = mem - displayValue
    }
    
    @IBAction func memoryRecall() {
        displayValue = mem
    }
    
    @IBAction func clearEntry() {
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBOutlet weak var stackDisplay: UILabel!
    @IBAction func clearStack() {
//        operandStack.removeAll()
//        stackDisplay.text = "\(operandStack)"
        brain.opStack.removeAll()
        stackDisplay.text = "\(brain.opStack)"
    }
    
}
