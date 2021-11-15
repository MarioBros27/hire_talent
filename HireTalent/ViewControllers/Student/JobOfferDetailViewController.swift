//
//  JobOfferDetailViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 09/05/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import Firebase
class JobOfferDetailViewController: UIViewController {

    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var vacantsTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var experienceTextField: UITextField!
    
    
    var jobOffer = JobOffer()
    var studentId = StudentDAO.getStudentId()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        initJobOffer()
    }
    
    // Initialize the elements
    func setupElements(){
        
        // Stylize the elements
        Utilities.styleDisplayTextField(jobTitleTextField)
        Utilities.styleDisplayLabel(jobDescriptionLabel)
        Utilities.styleDisplayTextField(vacantsTextField)
        Utilities.styleDisplayTextField(salaryTextField)
        Utilities.styleDisplayTextField(startDateTextField)
        Utilities.styleDisplayTextField(endDateTextField)
        Utilities.styleDisplayTextField(experienceTextField)
        
        // Make the TextFields not editable
        jobTitleTextField.isUserInteractionEnabled = false
        vacantsTextField.isUserInteractionEnabled = false
        salaryTextField.isUserInteractionEnabled = false
        startDateTextField.isUserInteractionEnabled = false
        endDateTextField.isUserInteractionEnabled = false
        experienceTextField.isUserInteractionEnabled = false
        
        // Change the position of the imagei in the button
        applyButton.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
    }

    
    func initJobOffer(){
        jobTitleTextField.text = jobOffer.jobTitle
        jobDescriptionLabel.text = jobOffer.jobDescription
        vacantsTextField.text = String(jobOffer.vacants)
        salaryTextField.text = String(jobOffer.salary)
        startDateTextField.text = jobOffer.startDate
        endDateTextField.text = jobOffer.endDate
        experienceTextField.text = String(jobOffer.experience)
        companyNameLabel.text = jobOffer.companyName
        
    }
    
    
    // Verify if a student has already applied to a job offer
    func verifyApplicant() -> Bool {
        
        for student in jobOffer.interestedStudents {
            if studentId == student {
                return true
            }
        }
        return false
    }
    
    
    // Display a successful alert
    func displaySuccessfulAlert() {
        
        let alert = UIAlertController(title: "Thank you!", message: "You have applied succesffully to this job offer", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "applicationSent", sender: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Display an unsuccessful alert
    func displayOfferNoLongerAlert() {
        
        let alert = UIAlertController(title: "Sorry", message: "Offer is no longer open", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            UIAlertAction in
        })
                
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Display an unsuccessful alert
    func displayApplicationDeniedAlert() {
        
        let alert = UIAlertController(title: "Application denied", message: "You already are an applicant to this offer.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            UIAlertAction in
        })
                
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // When Apply button is tapped
    @IBAction func applyButtonIsTapped(_ sender: Any) {
        
        // Establish the connection with the database
        let db = Firestore.firestore()
            
        // Variable used to know if the offer is open
        var open = true
            
        let docRef = db.collection("offers").document(jobOffer.offerKey)
        
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                
                open = document.data()?["open"] as? Bool ?? true
                
                if(open){
                    
                    // Verify if the student has already applied to the job offer
                    let applicant = self.verifyApplicant()
                    
                    if applicant {
                        self.displayApplicationDeniedAlert()
                    } else {
                       
                        // Add the student to interested students
                        self.jobOffer.interestedStudents.append(self.studentId)
                        
                        // Update the job offer with the interested students
                        JobOffersDAO.addANewInterestedStudentToAJobOffer(self.jobOffer.jobOfferId, self.jobOffer.interestedStudents) { (errorHandler) in
                        
                            if errorHandler != nil {
                                print(errorHandler!)
                            } else {
                                self.displaySuccessfulAlert()
                            }
                        }
                    }
                } else {
                    
                    self.displayOfferNoLongerAlert()
                }
            }
        }
    }
}
