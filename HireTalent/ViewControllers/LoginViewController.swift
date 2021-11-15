//
//  LoginViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 06/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the navigation bar for the HomeViewController (LoginViewController -> HomeViewController)
        setUpElements()
    }

    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleFormTextField(emailTextField)
        Utilities.styleFormTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    
    // Validate Text Fields
    func validateFields() -> String? {
        
        if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in the email and password"
        }
        
        return nil
    }
    
    
    // Some error ocurred, show the error message
    func showError(_ message: String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        // Validate Text Fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else {
            
            // Signing in the user
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                // Check for errors
                if error != nil {
                    
                    // There was an error creating the user
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                    self.getUserType(result!.user.uid)
                }
            }
        }
    }
}

extension LoginViewController {
    
    // Get the user type
    func getUserType(_ userId: String) {
        UserDAO.getType(userId) { (userType) in
            
            if userType == "Employer" {
                
                // Transition to the employer home screen
                self.performSegue(withIdentifier: "loggedInEmployer", sender: nil)
            }
                
            else if userType == "Student" {
                
                //Transition to the student home screen
                self.performSegue(withIdentifier: "loggedInStudent", sender: nil)
            }
        }
    }
}
