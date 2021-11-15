//
//  ViewStudentOffersController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 09/05/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class ViewStudentOffersController: UITableViewController {

    var jobOffers: [JobOffer] = []
    var jobOffer: Int = 0
    let studentId = StudentDAO.getStudentId()
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet var jobOffersTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if filterButton.title == "Filter"{
            loadAllOffers()
        }
        else {
            loadFilteredOffers()
        }
        
    }
    
    // Function used to load all the job offers without showing those that are closed
    func loadAllOffers(){
        jobOffers.removeAll()
        JobOffersDAO.getAllJobOffers(){ (jobOffersReturned) in
            
            if jobOffersReturned == nil {
                
            } else {
                for offer in jobOffersReturned!{
                    
                    if offer.open == true{
                        self.jobOffers.append(offer)
                    }
                
                    self.jobOffersTable.reloadData()
                }
            }
        }
    }
    
    // Function used to load the filtered job offers based on the major of the student
    func loadFilteredOffers(){
        jobOffers.removeAll()
        
        StudentDAO.getStudentMajor(self.studentId) { studentMajor in
            JobOffersDAO.filterJobOffers(studentMajor!) { jobOffers in
                self.jobOffers = jobOffers!
                self.jobOffersTable.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections: Int = 1
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobOffers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobOfferCell", for: indexPath)
        
        cell.textLabel?.text = jobOffers[indexPath.row].jobTitle
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        jobOffersTable.deselectRow(at: indexPath, animated: true)
        jobOffer = indexPath.row
        if(jobOffers[jobOffer].open){
           performSegue(withIdentifier: "jobOfferDetail", sender: nil)
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "jobOfferDetail" {
            let jobOfferDetail = segue.destination as? JobOfferDetailViewController
            
            jobOfferDetail?.jobOffer = jobOffers[jobOffer]
        }
    }
    
    // If the filter button is tapped
    @IBAction func filterButtonTapped(_ sender: Any) {
        if(filterButton.title == "Filter"){
            loadFilteredOffers()
            filterButton.title = "Show all"
        }
        
        else {
            loadAllOffers()
            filterButton.title = "Filter"
        }
        
    }
    

}
