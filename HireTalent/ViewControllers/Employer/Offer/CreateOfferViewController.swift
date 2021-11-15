//
//  CreateOfferViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 16/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class CreateOfferViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var vacantsTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var newOfferButton: UIButton!
    @IBOutlet weak var specialityPicker: UIPickerView!
    var userId: String = EmployerDAO.getUserId()
    var employer: Employer?
    
    // Variables used for the speciality picker
    var speciality: String = "Sales"
    var specialityData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Stylize the UI elements
        setUpElements()
        
        // Add the functionality to date pickers
        initDatePickers()
        
        // Add the functionality to speciality picker
        initPickerView()
    }
    
    
    // Stylize the UI elements
    func setUpElements() {
        
        // Style the elements
        Utilities.styleFormTextField(titleTextField)
        Utilities.styleFormTextField(startDateTextField)
        Utilities.styleFormTextField(endDateTextField)
        Utilities.styleFormTextField(vacantsTextField)
        Utilities.styleFormTextField(salaryTextField)
        Utilities.styleFormTextField(experienceTextField)
        Utilities.styleFilledButton2(newOfferButton)
    }
    
    
    // Add the functionality to date pickers
    func initDatePickers(){
        self.startDateTextField.setInputViewDatePicker(target: self, selector: #selector(startTapDone))
        self.endDateTextField.setInputViewDatePicker(target: self, selector: #selector(endTapDone))
    }
    
    
    // Display alert
    func displayAlert() {
        let alertController = UIAlertController(title: "Job Offer Created", message: "Your job offer has been successfully created", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { UIAlertAction in
            self.performSegue(withIdentifier: "reloadJobOffer", sender: nil)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // Add a new Job Offer
    func addNewOffer(_ company: Company) {
        
        JobOffersDAO.addNewOffer(self.userId, company.rfc, self.titleTextField.text!, self.descriptionTextView.text!, self.vacantsTextField.text!, self.startDateTextField.text!, self.endDateTextField.text!, self.salaryTextField.text!, self.experienceTextField.text!, company.name, speciality){ (errorHandler) in
                if errorHandler != nil {
                    print(errorHandler!)
                }
                else {
                    self.displayAlert()
                }
        }
    }
    
    // If the 'Create New Offer' button is tapped
    @IBAction func newOfferTapped(_ sender: Any) {
        
        EmployerDAO.getCompamnyRfc(userId) { (companyRfc) in
            CompanyDAO.getCompanyInformation(companyRfc!){
                (error, company) in
                if error != nil{
                    print("error retrieving company Information at create offer view controller in student")
                }

                
                self.addNewOffer(company!)
                
            }
        }
    }
    
}

// Extension of the class used to define the functionalities of date pickers
extension CreateOfferViewController {
    
    // Put the selected start date in the date picker 1 into the start date textfield
    @objc func startTapDone(){
        if let datePicker = self.startDateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.startDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        self.startDateTextField.resignFirstResponder()
    }
    
    // Put the selected end date in the date picker 1 into the start date textfield
    @objc func endTapDone(){
        if let datePicker = self.endDateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.endDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        self.endDateTextField.resignFirstResponder()
    }

}

extension CreateOfferViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Specify the number of columns in the PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Specify the number of rows in the PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return specialityData.count
    }
    
    // Display the rowth element of the departmentData array in the PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return specialityData[row]
    }
    
    // Return the current value of the PickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        speciality = specialityData[row]
    }
    
    // Initialize the PickerView
    func initPickerView(){
        
        // Department
        self.specialityPicker.delegate = self
        self.specialityPicker.dataSource = self
        specialityData = ["Sales", "Export", "IT", "Marketing", "Financial", "Human Resources", "Purchasing", "Logistics"]
    }
}
