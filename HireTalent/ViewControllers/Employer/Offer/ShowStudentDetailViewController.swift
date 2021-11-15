//
//  ShowStudentDetailViewController.swift
//  HireTalent
//
//  Created by user168029 on 5/19/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class ShowStudentDetailViewController: UIViewController {

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentMajorLabel: UILabel!
    @IBOutlet weak var StudentSemesterLabel: UILabel!
    @IBOutlet weak var studentSchoolLabel: UILabel!
    @IBOutlet weak var studentExperienceText: UITextView!
    
    // Variables initialized by ShowStudentsInOfferViewController
    var studentId: String = ""
    var student: Student = Student()
    var offerId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentNameLabel.text = student.firstName + " " + student.lastName
        studentMajorLabel.text = student.major
        StudentSemesterLabel.text = student.semester
        studentSchoolLabel.text = student.school
        studentExperienceText.text = student.experience

        
    }
    
    @IBAction func clickInterestedButton(_ sender: UIButton) {
        student.notifications.insert(offerId, at: 0)
        StudentDAO.editStudent(id: studentId, student: student) { (error) in
            if (error != nil) {
                let alert = UIAlertController(title: "Failure", message: "There was a problem sending the notification to the student", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "F", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Success", message: "A notification has been sent to the student", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "NICE", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
