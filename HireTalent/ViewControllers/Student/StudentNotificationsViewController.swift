//
//  StudentNotificationsViewController.swift
//  HireTalent
//
//  Created by user168029 on 5/22/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class StudentNotificationsViewController: UITableViewController {

    var notifications: [String] = []
    var offers: [JobOffer] = []
    var employers: [Employer] = []
    var dataLoaded: Bool = false
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func prepareView() {
        var c = 0
        for offerId in notifications {
            JobOffersDAO.getJobOffer(offerId) { (error, offer) in
                if error != nil {
                    print("Couldnt retrieve the job offer")
                } else {
                    self.offers.insert(offer!, at: 0)
                    EmployerDAO.getEmployerInformation(offer!.userId) { (err, employer) in
                        if err != nil {
                            print("couldnt retrieve the employer")
                        } else {
                            self.employers.insert(employer!, at: 0)
                            
                            c += 1
                            if c == self.notifications.count{
                                self.dataLoaded = true
                                self.table.reloadData()
                            }
                        }
                    }
                }
            }
        
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let numColumns = 1
        return numColumns
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = notifications.count
        return numRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let thisRow = indexPath.row
        
        // Configure the cell...
        
        //We wait for all the database data to be loaded into the view to srart configuring the table
        if dataLoaded {
            let employerName = "\(employers[thisRow].firstName) \(employers[thisRow].lastName)"
            let offerName = offers[thisRow].jobTitle
            let companyName = offers[thisRow].companyName
            let employerMail = employers[thisRow].email
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.text = "\(employerName) is interested in you for the internship '\(offerName)' at \(companyName)!\nSend your curriculum to the email below as soon as posible.\n\(employerMail)"
        }
        

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
