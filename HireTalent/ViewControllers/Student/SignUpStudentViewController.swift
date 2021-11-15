//
//  SignUpStudentViewController.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 12/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class SignUpStudentViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var majorPicker: UIPickerView!
    @IBOutlet weak var semesterTextField: UITextField!
    
    var lastName: String?
    var firstName: String?
    var email: String?
    var password:String?
    var confirmPassword:String?
    var city: String?
    var state: String?
    var school: String?
    var semester: String?
    
    // Variables used for the department picker
    var majorData: [String] = [String]()
    var major: String = "Sales"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateTextFields()

        initPickerViews()
        errorLabel.isHidden = true
    }
    
    
    // Specify the number of columns in the PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // Specify the number of rows in the PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majorData.count
    }
    
    
    // Display the rowth element of the departmentData array in the PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majorData[row]

    }
    
    
    // Return the current value of the PickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        major = majorData[row]
    }
    
    
    // Initialize the PickerView
    func initPickerViews(){
        
        // Department
        self.majorPicker.delegate = self
        self.majorPicker.dataSource = self
        majorData = ["Sales", "Export", "IT", "Marketing", "Financial", "Human Resources", "Purchasing", "Logistics"]
    }
    
    
    // Check the fields and validate that the data is correct.
    // Otherwise, it returns the error message.
    @IBAction func next(_ sender: UIBarButtonItem) {
        getValues()
        
        // Check that all fields are filled in
        if(lastName == "" || firstName == "" || email == "" || password == "" || confirmPassword == "" || city == "" || state == "" || school == "" || semester == ""){
            
            errorLabel.isHidden = false
            errorLabel.text = "Fill in all the fields"
            return
        }
        
        //Validate passwords
        if passwordTextField.text!.count<6{
            errorLabel.text = "Password must be at least 6 char"
            return
        }
        
        if(passwordTextField.text != confirmPasswordTextField.text){
            errorLabel.isHidden = false

            errorLabel.text = "passwords don't match"
            return
        }
       
        //Prepare for segue and perform segue to experienceViewController
        performSegue(withIdentifier: "experienceIdentifier", sender: self)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "experienceIdentifier" {
            let destinationExperience = segue.destination as! ExperienceViewController
            destinationExperience.lastName = lastName
            destinationExperience.firstName = firstName
            destinationExperience.email = email
            destinationExperience.password = password
            destinationExperience.city = city
            destinationExperience.state = state
            destinationExperience.school = school
            destinationExperience.major = major
            destinationExperience.semester = semester
        }
    }
    
}

extension SignUpStudentViewController {
    
    func getValues() {
        lastName = lastNameTextField.text ?? ""
        firstName = firstNameTextField.text ?? ""
        email = emailTextField.text ?? ""
        password = passwordTextField.text ?? ""
        confirmPassword = confirmPasswordTextField.text ?? ""
        city = cityTextField.text ?? ""
        state = stateTextField.text ?? ""
        school = schoolTextField.text ?? ""
        semester = semesterTextField.text ?? ""
    }
    
    func delegateTextFields(){
        
        // Do any additional setup after loading the view.
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        schoolTextField.delegate = self
        semesterTextField.delegate = self
    }
    

}
