//
//  ViewController.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var themeSelectButton: UIButton!
    @IBOutlet weak var memoryDisplay: UILabel!
    @IBOutlet weak var expressionDisplay: UILabel!
    @IBOutlet weak var display: UILabel!
    
    var numberCruncher = NumberCruncher()
    var userIsTyping = false
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = DisplayNumberFormatter.formatter.string(from: NSNumber(value: newValue))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memoryDisplay.text = ""
        expressionDisplay.text = ""
        display.text = "0"
    }

    @IBAction func showThemesPopOver(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let themesVC = storyboard.instantiateViewController(
                   withIdentifier: "themesPopOverVC")
         
        themesVC.modalPresentationStyle = .popover

        themesVC.popoverPresentationController?.sourceView = themeSelectButton
        themesVC.popoverPresentationController?.sourceRect =
            themeSelectButton.frame

        self.present(themesVC, animated: true) {
        }
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
        
        if let tally = numberCruncher.evaluate().tally {
            displayValue = tally
        }
    }

}

