//
//  EditStudentViewController.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 09/05/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class EditStudentViewController: UIViewController {

    var student: Student?
    var delegate: StudentDelegate?
    
    @IBOutlet weak var errotLabel: UILabel!
    
    @IBOutlet weak var firstNameLabel: UITextField!
    
    @IBOutlet weak var lastNameLabel: UITextField!
    
    @IBOutlet weak var cityLabel: UITextField!
    
    @IBOutlet weak var stateLabel: UITextField!
    
    @IBOutlet weak var schoolLabel: UITextField!
    
    @IBOutlet weak var majorLabel: UITextField!
    
    @IBOutlet weak var semesterLabel: UITextField!
    
    @IBOutlet weak var experienceTextArea: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews(){
        firstNameLabel.text = student?.firstName
        lastNameLabel.text = student?.lastName
        cityLabel.text = student?.city
        stateLabel.text = student?.state
        schoolLabel.text = student?.school
        majorLabel.text = student?.major
        semesterLabel.text = student?.semester
        experienceTextArea.text = student?.experience
    }
    
   
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        if infoMissing(){
            errotLabel.isHidden = false
            errotLabel.text = "can't leave empty"
            return
        }
        readData()
        saveData()
    }
    func saveData(){
        StudentDAO.editStudent(id: StudentDAO.getStudentId(), student: student!){
            (error) in
            if(error != nil){
                print("error editing user")
                self.errotLabel.text = "error with firebase"
            }else{
                self.delegate?.updateStudentProfile(controller: self, newStudent: self.student!)
                self.navigationController?.popViewController(animated: true)

            }
        }
    }
    func readData(){
        student?.firstName = firstNameLabel.text!
        student?.lastName = lastNameLabel.text!
        student?.city = cityLabel.text!
        student?.state = stateLabel.text!
        student?.school = schoolLabel.text!
        student?.major = majorLabel.text!
        student?.semester = semesterLabel.text!
        student?.experience = experienceTextArea.text
    }
    func infoMissing()-> Bool{
        if (firstNameLabel.text!.isEmpty || lastNameLabel.text!.isEmpty ||
            cityLabel.text!.isEmpty ||
            stateLabel.text!.isEmpty ||
            schoolLabel.text!.isEmpty || majorLabel.text!.isEmpty || semesterLabel.text!.isEmpty ||
            experienceTextArea.text!.isEmpty){
            
            return true
        }else{
            return false
        }
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
