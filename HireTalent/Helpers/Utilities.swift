//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleFormTextField(_ textfield: UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height, width: textfield.frame.width, height: 1)
        
        bottomLine.backgroundColor = UIColor.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleDisplayTextField(_ textfield: UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height + 5, width: textfield.frame.width, height: 1)
        
        bottomLine.backgroundColor = UIColor.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    
    static func styleDisplayLabel(_ label: UILabel) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: label.frame.height + 5, width: label.frame.width, height: 1)
        
        bottomLine.backgroundColor = UIColor.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 1).cgColor
        
        // Add the line to the text field
        label.layer.addSublayer(bottomLine)
        
    }
    
    
    static func styleFilledButton(_ button: UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 255/255, green: 111/255, blue: 111/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleFilledButton2(_ button: UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 122/255, green: 159/255, blue: 200/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    static func styleFilledButtonBlue(_ button: UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 62/255, green: 51/255, blue: 99/255, alpha: 1)

        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.init(red: 46/255, green: 252/255, blue: 223/255, alpha: 1)
    }
    
    static func styleHollowButton(_ button: UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
