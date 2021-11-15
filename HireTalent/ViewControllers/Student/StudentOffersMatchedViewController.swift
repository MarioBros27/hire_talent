//
//  StudentOffersMatchedViewController.swift
//  HireTalent
//
//  Created by user168029 on 5/23/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class StudentOffersMatchedViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    var notifications: [String] = []
    var offers: [JobOffer] = []
    var employers: [Employer] = []
    var dataLoaded: Bool = false
    let studentId: String = StudentDAO.getStudentId()
    
    var cellSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func prepareView() {
        
        StudentDAO.getStudent(studentId) { (studentError, student) in
            if studentError != nil {
                print("COULDNT RETRIEVE STUDENT")
            } else {
                self.notifications = student!.notifications
                
                var c = 0
                for offerId in self.notifications {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "employerCell", for: indexPath)

        if dataLoaded {
            let thisRow = indexPath.row
            let employerName = "\(employers[thisRow].firstName) \(employers[thisRow].lastName)"
            let offerName = "\(offers[thisRow].jobTitle)"
            
            // Configure the cell...
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.text = "\(employerName): \(offerName)"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        cellSelected = indexPath.row
        performSegue(withIdentifier: "viewEmployer", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewEmployer" {
            let destinationController = segue.destination as! ViewEmployerViewController
            
            destinationController.employer = employers[cellSelected]
            destinationController.employerId = offers[cellSelected].userId
        }
    }

}
