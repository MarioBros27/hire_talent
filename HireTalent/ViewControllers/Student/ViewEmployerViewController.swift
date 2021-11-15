//
//  ViewEmployerViewController.swift
//  HireTalent
//
//  Created by user168029 on 5/26/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class ViewEmployerViewController: UIViewController {

    @IBOutlet weak var employerName: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    
    var employer: Employer = Employer()
    var employerId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startView()
    }
    func startView(){
        let empName = "\(employer.firstName) \(employer.lastName)"
        self.employerName.text = empName
        
        self.ratingLabel.text = "Rating: \(Int(ratingSlider.value))"
    }
    
    @IBAction func ratingChanged(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(.down), animated: true)
        self.ratingLabel.text = "Rating: \(Int(ratingSlider.value))"
    }
    
    @IBAction func rateEmployer(_ sender: UIButton) {
        employer.rating.append(ratingSlider.value)
        EmployerDAO.addRating(employerId, employer.rating) { (error) in
            if error != nil {
                print("There was a serious problem adding that rating")
            } else {
                let alert = UIAlertController(title: "Rating sent!", message: "Thanks for rating your employer, this will help them improve", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Thats cool!", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
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
