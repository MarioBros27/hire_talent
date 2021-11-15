//
//  SignUpOptionViewController.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 12/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class SignUpOptionViewController: UIViewController {
    
    @IBOutlet weak var employerButton: UIButton!
    @IBOutlet weak var studentButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    // Style the elements
    func setUpElements(){
        Utilities.styleFilledButton2(employerButton)
        Utilities.styleHollowButton(studentButton)
    }
    
    // When the employee taps the Sign Up Employer button
    @IBAction func employerOptionPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "signUpEmployerScreen", sender: self)
    }
    
    // When the student taps the Sign Up Student button
    @IBAction func studentOptionPressed(_ sender: UIButton) {
         performSegue(withIdentifier: "signUpStudentScreen", sender: self)
    }
    
}
