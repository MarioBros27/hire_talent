//
//  HomeViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 06/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var profilePhotoContainer: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let userId = EmployerDAO.getUserId()
    var employer: Employer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Stylize the UI elements
        activityIndicator.isHidden = true
        setupElements()
        putProfilePicture()
        
        // Get and display the user information
        initProfile()
    }
    
    
    // Initialize the elements
    func setupElements(){
    
        // Stylize the TextFields
        Utilities.styleDisplayTextField(emailTextField)
        Utilities.styleDisplayTextField(positionTextField)
        Utilities.styleDisplayTextField(companyTextField)
        Utilities.styleDisplayTextField(address1TextField)
        Utilities.styleDisplayTextField(address2TextField)
        Utilities.styleDisplayTextField(cityTextField)
        Utilities.styleDisplayTextField(stateTextField)
        
        // Make the TextFields not editable
        emailTextField.isUserInteractionEnabled = false
        positionTextField.isUserInteractionEnabled = false
        companyTextField.isUserInteractionEnabled = false
        address1TextField.isUserInteractionEnabled = false
        address2TextField.isUserInteractionEnabled = false
        cityTextField.isUserInteractionEnabled = false
        stateTextField.isUserInteractionEnabled = false
        
        // Make the profile photo container round
        profilePhotoContainer?.layer.cornerRadius = (profilePhotoContainer?.frame.size.width ?? 0.0)/2
    }
    
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
    // UIImagePickerController is a view controller that lets a user pick media from their photo library.
       let imagePickerController = UIImagePickerController()
       
       // Only allow photos to be picked, not taken.
       imagePickerController.sourceType = .photoLibrary
       
       // Make sure ViewController is notified when the user picks an image.
       imagePickerController.delegate = self
       present(imagePickerController, animated: true, completion: nil)
    
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        profilePhoto.image = nil
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        EmployerDAO.setImage(userId, selectedImage) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.profilePhoto.image = selectedImage
            
        }
            
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    func putProfilePicture(){
        EmployerDAO.getImage(userId, imageView: profilePhoto)
    }
    // Get and display the user information
    func initProfile(){
        
        // Get the employer information
        EmployerDAO.getEmployerInformation(userId) { (error, employer) in
            
            if error != nil {
                
            }
            else {
                self.employer = employer
                self.nameLabel.text = employer!.self.firstName.uppercased() + " " + employer!.self.lastName.uppercased()
                self.emailTextField.text = employer!.self.email
                self.positionTextField.text = employer!.self.position

                let companyRfc = employer!.self.company_rfc
                
                
                // Get the company information of a selected user
                CompanyDAO.getCompanyInformation(companyRfc) { (error, company) in

                    if error != nil {

                    }
                    else {
                        self.companyTextField.text = company!.self.name
                        self.address1TextField.text = company!.self.address_1
                        self.address2TextField.text = company!.self.address_2
                        self.cityTextField.text = company!.self.city
                        self.stateTextField.text = company!.self.state
                    }
                }
            }
        }
    }
}
