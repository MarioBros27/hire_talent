//
//  JobOffersDAO.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 17/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation
import Firebase

class JobOffersDAO {
    
    // Insert a new job offer in the database.
    // It is used a callback because we depend of the 'result' provided by the setData() function.
    static func addNewOffer(_ userId: String, _ companyRfc: String, _ jobTitle: String, _ jobDescription: String, _ vacants: String, _ startDate: String, _ endDate: String, _ salary: String, _ experience: String, _ companyName: String, _ specialityField: String, completion: @escaping((_ data: String?) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Use a model to organize the employer information
        var jobOffer = JobOffer()
        
        jobOffer.jobTitle = jobTitle
        jobOffer.jobDescription = jobDescription
        jobOffer.vacants = Int(vacants)!
        jobOffer.startDate  = startDate
        jobOffer.endDate = endDate
        jobOffer.salary = Int(salary)!
        jobOffer.experience = Int(experience)!
        jobOffer.specialityField = specialityField
        let collection = db.collection("offers")
        let newDoc = collection.document()
        let key = newDoc.documentID
        let dataKey = ["offerKey": key]
        
        // Set the document data
        db.collection("offers").document(key).setData([
            "userId": userId,
            "companyRfc": companyRfc,
            "companyName": companyName,
            "jobTitle": jobOffer.jobTitle,
            "jobDescription": jobOffer.jobDescription,
            "vacants": jobOffer.vacants,
            "startDate": jobOffer.startDate,
            "endDate": jobOffer.endDate,
            "salary": jobOffer.salary,
            "experience": jobOffer.experience,
            "specialityField": jobOffer.specialityField,
            "interestedStudents": jobOffer.interestedStudents,
            "open": true
        ]) { (error) in
            
            // Check for erros
            if error != nil {
                
                // There was an error adding the offer to the database
                completion("Error")
            }
            newDoc.setData(dataKey, merge: true)
            completion(nil)
        }
    }
    
    static func editOffer( jobOffer:JobOffer, completion: @escaping((_ data: String?) -> Void)){
       
        // Establish the connection with the database
        let db = Firestore.firestore()
        
            // Store the information in the database
        
        db.collection("offers").document(jobOffer.offerKey).updateData([
              "jobTitle": jobOffer.jobTitle,
                      "jobDescription": jobOffer.jobDescription,
                      "vacants": jobOffer.vacants,
                      "startDate": jobOffer.startDate,
                      "endDate": jobOffer.endDate,
                      "salary": jobOffer.salary,
                      "experience": jobOffer.experience,
            
        ]) { (error) in

            // Check for errors
            if error != nil {

                // There was an error adding the user data to the database
                completion("Error editing the offer")
            }

            // If the insertion was executed correctly return nil
            completion(nil)
        }
    }
    
    
    static func editOpen(jobOffer: JobOffer, completion: @escaping((_ data: String?) -> Void)){
    
     // Establish the connection with the database
     let db = Firestore.firestore()
     
         // Store the information in the database
     
     db.collection("offers").document(jobOffer.offerKey).updateData([
           "open": jobOffer.open
         
     ]) { (error) in

         // Check for errors
         if error != nil {

             // There was an error adding the user data to the database
             completion("Error editing the offer opennes in dao")
         }

         // If the insertion was executed correctly return nil
         completion(nil)
     }
    }
    
    
    // Delete a job offer an all the student's notifications including it
    static func deleteOffer(offer: JobOffer){

        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let offerRef = db.collection("offers").document(offer.offerKey)

        offerRef.getDocument() { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                // Get the data of the selected offer
                let offerData = document.data()
                
                // Get the interested students of the offer
                let interestedStudents = offerData!["interestedStudents"] as? [String] ?? []
                
                // If there were interested students then delete all the possible notifications
                if interestedStudents != [] {
                    StudentDAO.deleteNotifications(offer.offerKey, interestedStudents)
                }
                
                // Delete the job offer. This instruction should be inside the closure because if
                // it is not the offer is deleted before the student's notifications
                offerRef.delete() { error in
                    if error != nil {
                        print("There was an error deleting the user")
                    }
                }
            }
        }
    }
    
    
    // Get the information of a job offer
    static func getJobOffer(_ offerId: String, completion: @escaping(((String?), (JobOffer?)) -> Void)) {
    
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let empRef = db.collection("offers").document(offerId)
        
        empRef.getDocument { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                let empData = document.data()
                var offer = JobOffer()
                
                offer.companyName = empData!["companyName"] as? String ?? ""
                offer.endDate = empData!["endDate"] as? String ?? ""
                offer.experience = empData!["experience"] as? Int ?? 0
                offer.interestedStudents = empData!["interestedStudents"] as? [String] ?? []
                offer.jobDescription = empData!["jobDescription"] as? String ?? ""
                offer.jobTitle = empData!["jobTitle"] as? String ?? ""
                offer.salary = empData!["salary"] as? Int ?? 0
                offer.specialityField = empData!["specialityField"] as? String ?? ""
                offer.startDate = empData!["startDate"] as? String ?? ""
                offer.userId = empData!["userId"] as? String ?? ""
                offer.vacants = empData!["vacants"] as? Int ?? 0
                
                // Returns an object employer with all their data
                completion(nil, offer)
            } else {
                
                // Returns an error message
                completion("Error retrieving the offer data", nil)
            }
        }
    }
    
    
    // Retrieve the offers of an employer from the database.
    // It is used a callback because we depend of the 'result' provided by the setData() function.
    static func getOffers(_ userId: String, completion: @escaping(((String?), ([JobOffer]?)) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Queries for the documents owned by the current employer
        let offersRef = db.collection("offers").whereField("userId", isEqualTo: userId)

        offersRef.getDocuments { (snapshot, error ) in
            
            //There is not an error
            if error == nil && snapshot != nil {
                
                // Use a model to organize the offer information
                var jobOffers: [JobOffer] = []
                
                for document in snapshot!.documents {
                    let offerData = document.data()
                    var offer = JobOffer()
                
                    offer.jobOfferId = document.documentID
                    offer.offerKey = offerData["offerKey"] as? String ?? ""
                    offer.companyName = offerData["companyName"] as? String ?? ""
                    offer.endDate = offerData["endDate"] as? String ?? ""
                    offer.experience = offerData["experience"] as? Int ?? 0
                    offer.jobDescription = offerData["jobDescription"] as? String ?? ""
                    offer.jobTitle = offerData["jobTitle"] as? String ?? ""
                    offer.salary = offerData["salary"] as? Int ?? 0
                    offer.startDate = offerData["startDate"] as? String ?? ""
                    offer.vacants = offerData["vacants"] as? Int ?? 0
                    offer.specialityField = offerData["specialityField"] as? String ?? ""
                    offer.open = offerData["open"] as? Bool ?? false
                    offer.interestedStudents = offerData["interestedStudents"] as? [String] ?? []
                    
                    jobOffers.append(offer)
                }
                
                completion(nil, jobOffers)
            } else {
                completion("Failed to retrieve offers from employer", nil)
            }
        }
    }
    
    
    // Get all the Job Offers
    static func getAllJobOffers(completion: @escaping(([JobOffer]?)->Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired collection
        db.collection("offers").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting the documents: \(err)")
                completion(nil)
                
            } else {
                
                var jobOffers: [JobOffer] = []
                var jobOffer = JobOffer()
                for document in querySnapshot!.documents {
                    
                    jobOffer.jobOfferId = document.documentID
                    jobOffer.offerKey = document.data()["offerKey"] as? String ?? ""
                    jobOffer.jobTitle = document.data()["jobTitle"] as? String ?? ""
                    jobOffer.jobDescription = document.data()["jobDescription"] as? String ?? ""
                    jobOffer.vacants = document.data()["vacants"] as? Int ?? 0
                    jobOffer.startDate = document.data()["startDate"] as? String ?? ""
                    jobOffer.endDate = document.data()["endDate"] as? String ?? ""
                    jobOffer.companyName = document.data()["companyName"] as? String ?? ""
                    jobOffer.salary = document.data()["salary"] as? Int ?? 0
                    jobOffer.open = document.data()["open"] as? Bool ?? false
                    jobOffer.experience = document.data()["experience"] as? Int ?? 0
                    jobOffer.interestedStudents = document.data()["interestedStudents"] as? [String] ?? []
                    jobOffers.append(jobOffer)
                }
                
                completion(jobOffers)
            }
        }
    }
    
    
    // Add a interested student in a job offer
    static func addANewInterestedStudentToAJobOffer(_ documentId: String, _ interestedStudents: [String], completion: @escaping(String?) -> Void){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let ref = db.collection("offers").document(documentId)
        
        ref.updateData([
            "interestedStudents": interestedStudents
        ]) { err in
            if err != nil{
                completion("There was some error adding the student")
            } else {
                completion(nil)
            }
        }
    }
    
    
    // Filter the job offers given a speciality field
    static func filterJobOffers(_ specialityField: String, completion: @escaping([JobOffer]?) -> Void){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Filter the job offers based on the speciality field
        db.collection("offers").whereField("specialityField", isEqualTo: specialityField).getDocuments() { (querySnapshot, error) in
            
            if let err = error {
                print("Error getting the document: \(err)")
                completion(nil)
            } else {
                
                // Use a model to organize the offer information
                var jobOffers: [JobOffer] = []
                
                for document in querySnapshot!.documents {
                    let offerData = document.data()
                    var offer = JobOffer()
                
                    offer.open = offerData["open"] as? Bool ?? false
                    
                    if offer.open {
                        offer.jobOfferId = document.documentID
                        offer.offerKey = offerData["offerKey"] as? String ?? ""
                        offer.companyName = offerData["companyName"] as? String ?? ""
                        offer.endDate = offerData["endDate"] as? String ?? ""
                        offer.experience = offerData["experience"] as? Int ?? 0
                        offer.jobDescription = offerData["jobDescription"] as? String ?? ""
                        offer.jobTitle = offerData["jobTitle"] as? String ?? ""
                        offer.salary = offerData["salary"] as? Int ?? 0
                        offer.startDate = offerData["startDate"] as? String ?? ""
                        offer.vacants = offerData["vacants"] as? Int ?? 0
                        
                        offer.interestedStudents = offerData["interestedStudents"] as? [String] ?? []
                        
                        jobOffers.append(offer)
                    }
                    
                }
                completion(jobOffers)
            }
        }
    }
    
    
    // Delete the interested student id caused by the deletion of a student account
    static func deleteInterestStudentId(_ studentID: String, completion: @escaping(String?) -> Void){
        
        // Add the offer key to an array because the arrayRemove() method receives an [Any]
        var studentIDs: [Any] = []
        studentIDs.append(studentID)
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        JobOffersDAO.getAllJobOffers { (jobOffers) in
            for offer in jobOffers! {
                
                // Delete the studentId from offers
                db.collection("offers").document(offer.offerKey).updateData([
                   "interestedStudents": FieldValue.arrayRemove(studentIDs)
                ]) { err in
                    if err != nil{
                        completion("There was some error adding the student")
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
}
