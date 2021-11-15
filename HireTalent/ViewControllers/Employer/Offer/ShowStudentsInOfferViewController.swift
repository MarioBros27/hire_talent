//
//  ShowStudentsInOfferViewController.swift
//  HireTalent
//
//  Created by user168029 on 4/28/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class ShowStudentsInOfferViewController: UITableViewController {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet var table: UITableView!
    
    // Variables initialized in EmployerOfferViewController
    var offerId: String = ""
    var students: [String] = []
    var specialityField: String = ""
    
    var studentsData: [Student] = []
    var studentIds: [String] = []
    
    
    var cellSelected: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudents()
    }
    
    // Get the name of all the interested students in the job offer
    func getStudents(){
        StudentDAO.getStudents(students) { (studentsData, studentIds) in
            self.studentsData = studentsData!
            self.studentIds = studentIds!
            self.table.reloadData()
        }
    }
    
    
    // Get the name of all the interested students in the job offer
    func getFilteredStudents(){
        StudentDAO.getFilteredStudents(students, specialityField) { (studentsData, studentIds) in
            self.studentsData = studentsData!
            self.studentIds = studentIds!
            self.table.reloadData()
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let columns = 1
        return columns
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = studentsData.count
        return rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        if studentsData.count != 0 {
            cell.textLabel?.text = studentsData[indexPath.row].firstName + " " + studentsData[indexPath.row].lastName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        cellSelected = indexPath.row
        performSegue(withIdentifier: "showStudent", sender: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showStudent" {
            let destinationController = segue.destination as! ShowStudentDetailViewController
            
            destinationController.student = studentsData[cellSelected]
            destinationController.studentId = studentIds[cellSelected]
            destinationController.offerId = offerId
        }
    }

    @IBAction func filterButtonIsTapped(_ sender: Any) {
        if filterButton.title == "Filter" {
            getFilteredStudents()
            filterButton.title = "Show All"
        } else {
            getStudents()
            filterButton.title = "Filter"
        }
    }
}
