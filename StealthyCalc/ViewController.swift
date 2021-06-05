//
//  ViewController.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var numberCruncher = NumberCruncher()
    var userIsTyping = false
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func digitTapped(_ sender: UIButton) {
        let number = sender.currentTitle!
        if userIsTyping {
            if number == "." && display.text!.contains(".") {
                return
            }
            let numberSoFar = display.text!
            display.text = numberSoFar + number
        } else {
            display.text = number
            userIsTyping = true
        }
    }
    
    @IBAction func operationTapped(_ sender: UIButton) {
        if userIsTyping {
            numberCruncher.setOperand(displayValue)
            userIsTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            numberCruncher.performOperation(mathematicalSymbol)
        }
        
        if let result = numberCruncher.result {
            displayValue = result
        }
    }
}

