//
//  EmployerOfferViewController.swift
//  HireTalent
//
//  Created by user168029 on 4/28/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class EmployerOfferViewController: UIViewController,OfferDelegate {
    func updateOfferView(controller: AnyObject, newOffer: JobOffer) {
        offer = newOffer
        loadData()
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var vacantslabel: UILabel!

    @IBOutlet weak var openSwitch: UISwitch!
    
    @IBOutlet weak var interestedStudentsButton: UIButton!
    @IBOutlet var jobDescription:UITextView!
    
    // Variable initialized by JobOffersViewController
    var offer: JobOffer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = offer!.jobTitle
        loadData()
        Utilities.styleFilledButtonBlue(interestedStudentsButton)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = offer!.jobTitle
        loadData()
    }
    
    
    func loadData(){
        titleLabel.text = offer!.jobTitle
        salaryLabel.text = String(offer!.salary)
        startLabel.text = offer!.startDate
        endLabel.text = offer!.endDate
        experienceLabel.text = String(offer!.experience)
        vacantslabel.text = String(offer!.vacants)
        jobDescription.text = offer!.jobDescription
        openSwitch.isOn = offer!.open
        
    }
    @IBAction func openSwitchPressed(_ sender: UISwitch) {
        offer!.open = sender.isOn
        displayAlert()
    
        JobOffersDAO.editOpen(jobOffer: offer! ){
            (error) in
            if error != nil{
                print("couldn't update the open in employerofferviewcontroller")
            }
        }
    }
    
    
    @IBAction func clickStudentButton(_ sender: UIButton) {
        performSegue(withIdentifier: "interestedStudents", sender: nil)
    }
    @IBAction func editOfferPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditOfferSegue", sender: nil)
    }
    // Display alert
    func displayAlert() {
        let alert = UIAlertController()
        if(offer!.open){
            alert.title = "Offer opened"
            alert.message = "Offer has been opened"
        }else{
            alert.title = "Offer closed"
            alert.message = "Offer has been closeed"
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { UIAlertAction in
            
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "interestedStudents" {
            let destinationController = segue.destination as! ShowStudentsInOfferViewController
            
            destinationController.students = offer!.interestedStudents
            destinationController.offerId = offer!.offerKey
            destinationController.specialityField = offer!.specialityField
        }
        
        if segue.identifier == "EditOfferSegue"{
            let destination = segue.destination as! EditOfferViewController
            destination.offer = offer
            destination.delegate = self
        }
    }
}

