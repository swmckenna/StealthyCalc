//
//  ViewController.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayContainerView: UIView!
    @IBOutlet weak var themeSelectButton: UIButton!
    @IBOutlet weak var memoryDisplay: UILabel!
    @IBOutlet weak var expressionDisplay: UILabel!
    @IBOutlet weak var radiansLabel: UILabel!
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var scientificButtonsStackView: UIStackView!
    @IBOutlet var laterFunctionalityButtons: [ScientificButton]! //to be implemented properly later
    @IBOutlet var dualPurposeButtons: [ScientificButton]!
    @IBOutlet weak var radiansDegreesButton: ScientificButton!
    
    
    var numberCruncher = NumberCruncher()
    var memoryTally = MemoryTally()
    var userIsTyping = false
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = DisplayNumberFormatter.formatter.string(from: NSNumber(value: newValue))
        }
    }
    
    var displayResult = CalculatedResult() {
        didSet {
            let d = displayResult
            switch (d.result, d.resultIsPending, d.negativeIsPending, d.expressionString, d.error) {
            case (nil, _, _, "", nil):
                displayValue = 0
            case (let result, _, _, _, nil):
                if let r = result {
                    displayValue = r
                }
            case (_, _, _, _, _):
                display.text = "Error"
            }
            
            expressionDisplay.text = displayResult.expressionString != "" ?
                                displayResult.expressionString + (displayResult.resultIsPending ? "…" : "=") : ""
//            memoryDisplay.text =
        }
    }
    
    var showsSecondaryOperations = false {
        didSet {
            for button in dualPurposeButtons {
                let secondary = button.secondaryTitle ?? button.defaultTitle
                button.setTitle(showsSecondaryOperations ? secondary : button.defaultTitle, for: .normal)
            }
        }
    }
    
    var isInDegreeMode = true {
        didSet {
            radiansDegreesButton.setTitle(isInDegreeMode ? "Rad" : "Deg", for: .normal)
            radiansLabel.isHidden = isInDegreeMode
            if scientificButtonsStackView.isHidden {
                radiansLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Temporary
        for button in laterFunctionalityButtons {
            //rather do this than hide for stackview spacing reasons. Plan to implement buttons later anyway
            button.setTitle("", for: .normal)
            button.isEnabled = false
        }
        #warning("Remove above loop when parenthesis and memory functionality is added")

        expressionDisplay.isHidden = true // also implement properly later
        
        Themer.shared?.register(target: self, action: ViewController.handleTheme(_:))
        
        memoryDisplay.text = ""
        expressionDisplay.text = ""
        display.text = "0"
        
        showOrHideSciButtons()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        showOrHideSciButtons()
    }
    
    private func handleTheme(_ theme: CalcTheme) {
        self.view.backgroundColor = theme.settings.caseColor
        buttonsContainerView.backgroundColor = theme.settings.numberPadColor
        displayContainerView.backgroundColor = theme.settings.displayColor
        memoryDisplay.textColor = theme.settings.displayTextColor
        memoryDisplay.font = UIFont(name: theme.settings.displayFontName, size: 18)
        expressionDisplay.textColor = theme.settings.displayTextColor
        expressionDisplay.font = UIFont(name: theme.settings.displayFontName, size: 18)
        radiansLabel.textColor = theme.settings.displayTextColor
        radiansLabel.font = UIFont(name: theme.settings.displayFontName, size: 18)
        display.textColor = theme.settings.displayTextColor
        display.font = UIFont(name: theme.settings.displayFontName, size: 80)
        themeSelectButton.tintColor = theme.settings.settingsButtonTint
        
    }
    
    private func showOrHideSciButtons() {
        let isHidden = traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .compact
        scientificButtonsStackView.isHidden = isHidden
        radiansLabel.isHidden = false
        if isHidden {
            radiansLabel.isHidden = true
        }
        if isInDegreeMode {
            radiansLabel.isHidden = true
        }
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
        
        if var mathematicalSymbol = sender.currentTitle {
            if sender is TrigButton && !isInDegreeMode {
                mathematicalSymbol = "\(mathematicalSymbol)RAD"
            }
            numberCruncher.performOperation(mathematicalSymbol)
        }
        
        displayResult = numberCruncher.evaluate()
    }
    
    @IBAction func showSecondaryTapped(_ sender: UIButton) {
        showsSecondaryOperations = !showsSecondaryOperations
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        userIsTyping = false
        numberCruncher.clear()
        displayResult = numberCruncher.evaluate()
    }
    
    @IBAction func switchRadianDegreesTapped(_ sender: UIButton) {
        isInDegreeMode = !isInDegreeMode
    }
    
    @IBAction func addDisplayedValueToMemory(_ sender: ScientificButton) {
        memoryTally.add(displayValue)
        userIsTyping = false
    }
    
    @IBAction func subtractDisplayedValueFromMemory(_ sender: ScientificButton) {
        memoryTally.subtract(displayValue)
        userIsTyping = false
    }
    
    @IBAction func recallValueStoredInMemory(_ sender: ScientificButton) {
        displayValue = memoryTally.recall() ?? 0
    }
    
    @IBAction func clearMemory(_ sender: ScientificButton) {
        memoryTally.clear()
        userIsTyping = false
    }
    
}

