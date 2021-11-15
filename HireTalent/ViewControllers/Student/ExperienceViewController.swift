//
//  ExperienceViewController.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 12/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class ExperienceViewController: UIViewController, UITextViewDelegate{
    
    var lastName: String?
    var firstName: String?
    var email: String?
    var password:String?
    var city: String?
    var state: String?
    var school: String?
    var major: String?
    var semester: String?
    
    var experience: String?
    
    var startedEditing = false
    
    @IBOutlet weak var experienceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        experienceTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        experience = experienceTextView.text
    }
    
    
    
    @IBAction func signUp(_ sender: UIBarButtonItem) {
        
        // Use a model to organize the employer information
        var student = Student()
        
        student.firstName = firstName!
        student.lastName = lastName!
        student.email = email!
        student.city = city!
        student.school = school!
        student.experience = experienceTextView.text!
        student.major = major!
        student.state = state!
        student.semester = semester!
        
        StudentDAO.createStudentCredentials(student.email, password!){
            (userRetrieved) in
            
            // If the user was not created correctly
            if userRetrieved == nil {
                print("Error creating user 1")
            }
            else {
                
                StudentDAO.addStudent(id: userRetrieved!,student: student){
                    (extraErrorHandler) in
                    if extraErrorHandler != nil {
                        print("Error creating adding user")
                    }
                    else {
                        
                        self.performSegue(withIdentifier: "studentProfileIdentifier", sender: nil)
                        print("success saving student")
                    }
                }
                
                self.addStudentInUsers(userRetrieved)
            }
        }
    }
}

extension ExperienceViewController {

    // Call the function to add a new user and their type
    func addStudentInUsers(_ userRetrieved: String?) {
        
        UserDAO.addStudentInUsers(userRetrieved!){ (userErrorHandler) in
            
            // If there was an error storing the user information
            if userErrorHandler != nil {
                print("error al añadirlo a la coleccion")
            }
        }
    }
}
