//
//  ViewController.swift
//  Calculator
//
//  Created by Bryan Cheng on 2016/8/30.
//  Copyright (c) 2016年 Bryan Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var stackDisplay: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var hasDecimalPoint = false
    
    var brian = CalculatorBrian()
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brian.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        stackDisplay.text = brian.getStack()
    }
    
    @IBAction func clear(sender: UIButton) {
        endUserTyping()
        brian.removeAllOpStack()
        displayValue = 0
        stackDisplay.text = brian.getStack()
    }
    
    @IBAction func appendDecimalPoint(sender: UIButton) {
        let digit = sender.currentTitle!
        if !hasDecimalPoint {
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text = "0."
                userIsInTheMiddleOfTypingANumber = true
            }
            hasDecimalPoint = true
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func enter() {
        endUserTyping()
        if let result = brian.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        stackDisplay.text = brian.getStack()
    }
    
    func endUserTyping() {
        userIsInTheMiddleOfTypingANumber = false
        hasDecimalPoint = false
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            endUserTyping()
        }
    }
}

