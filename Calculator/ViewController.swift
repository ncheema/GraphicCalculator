//
//  ViewController.swift
//  Calculator
//
//  Created by Navjot Cheema on 9/28/15.
//  Copyright © 2015 Navjot Cheema. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //@IBOutlet creates the UI connection for easy access
    //optinal so intitlized to nil automatically
    //implicitly unwrapped optional
   
    @IBOutlet weak var history: UILabel!
    
    @IBOutlet weak var display: UILabel!
    var userIsInMiddleOfTypingANumber = false
    var brain = CalculatorBrain();
    
    //argument name is sender, type is UIButton
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        print("t : + \(display.text!)")
        if userIsInMiddleOfTypingANumber {
            if (digit == ".") {
                if (display.text!.rangeOfString(digit) == nil) {
                    display.text = display.text! + digit
                }
            }
            else {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInMiddleOfTypingANumber = true
        }
        print("digit = \(digit)")
    }
    
    @IBAction func enter() {
        userIsInMiddleOfTypingANumber = false
        print("digit = \(displayValue)")
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
    }
    
    //computed property
    var displayValue : Double {
        get {
            
            if(display.text! == "π") {
                return M_PI
            }
            
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            //if you do displayValue = 5, newValue gets that
            
            display.text! = "\(newValue)"
            userIsInMiddleOfTypingANumber = false
        }
    }
    @IBAction func operate(sender: UIButton) {
        
        if userIsInMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            print("oepration = \(operation)")
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        
    }
    
    @IBAction func allClear(sender: UIButton) {
        displayValue = brain.clearStack();
    }
}





