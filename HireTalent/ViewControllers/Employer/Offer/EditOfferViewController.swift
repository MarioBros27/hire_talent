//
//  EditOfferViewController.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 09/05/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class EditOfferViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
       @IBOutlet weak var descriptionTextView: UITextView!
       @IBOutlet weak var startDateTextField: UITextField!
       @IBOutlet weak var endDateTextField: UITextField!
       @IBOutlet weak var vacantsTextField: UITextField!
       @IBOutlet weak var salaryTextField: UITextField!
       @IBOutlet weak var experienceTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var offer: JobOffer?
    var delegate: OfferDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Stylize the UI elements
        setUpElements()
        loadData()
        
        // Add the functionality to date pickers
        initDatePickers()
    }
    
    func loadData(){
        titleTextField.text = offer!.jobTitle
        descriptionTextView.text = offer!.jobDescription
        startDateTextField.text = offer!.startDate
        endDateTextField.text = offer!.endDate
        vacantsTextField.text = String(offer!.vacants)
        salaryTextField.text = String(offer!.salary)
        experienceTextField.text = String(offer!.experience)
        
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        if infoMissing(){
            errorLabel.isHidden = false
            errorLabel.text = "can't leave empty"
            return
        }
        
        readData()
        saveData()
    }
    
    func infoMissing()->Bool{
        if titleTextField.text!.isEmpty || descriptionTextView.text!.isEmpty || startDateTextField.text!.isEmpty || endDateTextField.text!.isEmpty || vacantsTextField.text!.isEmpty || salaryTextField.text!.isEmpty || experienceTextField.text!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func readData(){
        offer!.jobTitle = titleTextField.text!
        offer!.jobDescription = descriptionTextView.text!
        offer!.startDate = startDateTextField.text!
        offer!.endDate = endDateTextField.text!
        offer!.vacants = Int(vacantsTextField.text!)!
         offer!.salary = Int(salaryTextField.text!)!
        offer!.experience = Int(experienceTextField.text!)!
    }
    
    func saveData(){
        JobOffersDAO.editOffer(jobOffer: offer! ){
            (error) in
            if(error != nil){
                print("error editing user")
                self.errorLabel.text = "error with firebase"
            }else{
                self.delegate?.updateOfferView(controller: self, newOffer: self.offer!)
                self.navigationController?.popViewController(animated: true)

            }
        }
    }
    // Add the functionality to date pickers
    func initDatePickers(){
        self.startDateTextField.setInputViewDatePicker(target: self, selector: #selector(startTapDone))
        self.endDateTextField.setInputViewDatePicker(target: self, selector: #selector(endTapDone))
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// Extension of the class used to define the functionalities of date pickers
extension EditOfferViewController {
    
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
