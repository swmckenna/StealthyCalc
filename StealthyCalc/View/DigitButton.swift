//
//  DigitButton.swift
//  StealthyCalc
//
//  Created by Stephen McKenna on 6/5/21.
//

import UIKit

class DigitButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButton()
    }
    
    private func setUpButton() {
//        self.layer.backgroundColor =
//        self.layer.cornerRadius = 5.0
        clipsToBounds = true
    }

}
