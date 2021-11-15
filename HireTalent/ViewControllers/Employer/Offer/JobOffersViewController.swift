//
//  JobOffersViewController.swift
//  HireTalent
//
//  Created by user168029 on 4/26/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import Firebase

class JobOffersViewController: UITableViewController {
    
    let employer = EmployerDAO.getUserId()
    var studentsPerOffer: [Int] = []
    var offers: [JobOffer] = []
    var cellSelected: Int = 0
    
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        JobOffersDAO.getOffers(employer) { (error, jobOffers) in
            if error != nil {
                
            } else {
                self.offers = jobOffers!
                self.table.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
         JobOffersDAO.getOffers(employer) { (error, jobOffers) in
                   if error != nil {
                       
                   } else {
                       self.offers = jobOffers!
                       self.table.reloadData()
                   }
               }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfColumns: Int = 1
        return numberOfColumns
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return offers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobOfferCell", for: indexPath) as! JobOffersCell
        
        cell.jobOfferTitle.text = offers[indexPath.row].jobTitle
        cell.numberOfInteresed.text = String(offers[indexPath.row].interestedStudents.count)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        cellSelected = indexPath.row
        performSegue(withIdentifier: "myOffer", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            JobOffersDAO.deleteOffer(offer: offers[indexPath.row])
            offers.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    //This function allow us to pass information between views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "myOffer" {
            let destinationController = segue.destination as! EmployerOfferViewController
            
            destinationController.offer = offers[cellSelected]
        }
    }

}
