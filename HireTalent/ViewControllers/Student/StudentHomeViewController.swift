//
//  StudentHomeViewController.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 12/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import UIKit

class StudentHomeViewController: UIViewController, StudentDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func updateStudentProfile(controller: AnyObject, newStudent: Student) {
        student = newStudent
        updateViews()
    }
    

    @IBOutlet weak var experienceLabel: UITextView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var notificationsBtn: UIBarButtonItem!
    let userId = StudentDAO.getStudentId()
    
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        putProfilePicture()
        
        // Get and display the student information
        initProfile()
        
    }
    @IBAction func chooseImage(_ sender: UITapGestureRecognizer) {
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

        StudentDAO.setImage(userId, selectedImage) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.profilePhoto.image = selectedImage
        }
            
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    func putProfilePicture(){
        StudentDAO.getImage(userId, imageView: profilePhoto)
    }
    // Get and display the student information
    func initProfile(){
          
        // Get the student information
        StudentDAO.getStudent(userId) { (error, student) in
            self.student = student
            if error != nil {
                print(error!)
            }
            else {
                self.updateViews()
            }
        }
    }
    
    func updateViews(){
        self.fullName.text = student!.self.firstName + " " + student!.self.lastName
        self.emailLabel.text = student!.self.email
        self.locationLabel.text = student!.self.city + ", " + student!.self.state
        self.schoolLabel.text = student!.self.school
        self.majorLabel.text = student!.self.major
        self.semesterLabel.text = student!.self.semester
        self.experienceLabel.text = student!.self.experience
        
        if (student!.notifications.count > 0) {
            self.notificationsBtn.tintColor = UIColor.red
        }
    }
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "EditStudentSegue", sender: self)
    }
    
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "myNotifications", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditStudentSegue"{
            let destination = segue.destination as! EditStudentViewController
            destination.student = student
            destination.delegate = self
        } else if (segue.identifier == "myNotifications") {
            let destination = segue.destination as! StudentNotificationsViewController
            if (student!.notifications.count > 0) {
                destination.notifications = student!.notifications
            }
        }
    }
    
}
