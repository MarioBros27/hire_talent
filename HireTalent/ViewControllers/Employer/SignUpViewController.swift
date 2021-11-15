//
//  SignUpViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 06/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rfcTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTexField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var departmentPicker: UIPickerView!
    @IBOutlet weak var stateTextField: UITextField!
    
    // Variables used for the department picker
    var departmentData: [String] = [String]()
    var department: String = "Sales"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Stylize the UI elements
        setUpElements()
        
        // Initialize the PickerView
        initPickerViews()
    }
    
    
    // Specify the number of columns in the PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // Specify the number of rows in the PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departmentData.count
    }
    
    
    // Display the rowth element of the departmentData array in the PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return departmentData[row]

    }
    
    
    // Return the current value of the PickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        department = departmentData[row]
    }

    
    // Stylize the UI elements
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleFormTextField(firstNameTextField)
        Utilities.styleFormTextField(lastNameTextField)
        Utilities.styleFormTextField(emailTextField)
        Utilities.styleFormTextField(passwordTextField)
        Utilities.styleFormTextField(rfcTextField)
        Utilities.styleFormTextField(companyTextField)
        Utilities.styleFormTextField(address1TextField)
        Utilities.styleFormTextField(address2TextField)
        Utilities.styleFormTextField(cityTexField)
        Utilities.styleFormTextField(stateTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    
    // Initialize the PickerView
    func initPickerViews(){
        
        // Department
        self.departmentPicker.delegate = self
        self.departmentPicker.dataSource = self
        departmentData = ["Sales", "Export", "IT", "Marketing", "Financial", "Human Resources", "Purchasing", "Logistics"]
    }
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil.
    // Otherwise, it returns the error message.
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || rfcTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || address2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || cityTexField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || stateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        // Check if the password is secure
        if Utilities.isPasswordValid(passwordTextField.text!) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    
    // Some error ocurred, show the error message
    func showError(_ message: String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    // When Sign Up button tapped then...
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        // Check for errors
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Call the function to create a user
            EmployerDAO.createUser(emailTextField.text!, passwordTextField.text!) { (userRetrieved) in
                
                // If the user was not created correctly
                if userRetrieved == nil {
                    self.showError("There was an error creating the user")
                }
                else {
                    self.addUserInformation(userRetrieved)
                    self.addEmployerInformation(userRetrieved)
                }
            }
        }
    }
}

extension SignUpViewController {
    
    // Call the function to add a new user and their type
    func addUserInformation(_ userRetrieved: String?) {
        
        UserDAO.addUserInformation(userRetrieved!){ (userErrorHandler) in
            
            // If there was an error storing the user information
            if userErrorHandler != nil {
                self.showError(userErrorHandler!)
            }
        }
    }
    
    
    // Call the function to insert the user extra data
    func addEmployerInformation(_ userRetrieved: String?) {
        
        EmployerDAO.addEmployerInformation(userRetrieved!, self.firstNameTextField.text!, self.lastNameTextField.text!, self.emailTextField.text!, self.department, self.rfcTextField.text!) { (employerErrorHandler) in
            
            // If there was an error storing the employer information
            if employerErrorHandler != nil {
                self.showError(employerErrorHandler!)
            }
            else {
                self.addCompanyInformation()
            }
        }
    }
    
    
    // Call the function to add the company information
    func addCompanyInformation() {
        
        CompanyDAO.addCompanyInformation(self.rfcTextField.text!, self.companyTextField.text!, self.address1TextField.text!, self.address2TextField.text!, self.cityTexField.text!, self.stateTextField.text!) { (companyErrorHandler) in
            
            // If there was an error storing the company information
            if companyErrorHandler != nil {
                self.showError(companyErrorHandler!)
            }
            else {
                self.performSegue(withIdentifier: "signedInEmployer", sender: nil)
            }
        }
    }
    
    
}
