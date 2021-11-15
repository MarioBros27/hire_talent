//
//  EmployerDAO.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 08/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
import Kingfisher

class EmployerDAO {
    
    // Create the user adding it to the Authentication Section of Firebase.
    // It is used a callback because we depend of the 'result' provided by the createUser() function.
    static func createUser(_ email:String, _ password: String, completion: @escaping((_ data: String?) -> Void)) {
        
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            // Check for errors
            if err != nil {
                
                // There was an error creating the user
                completion(nil)
            }
            else {
                
                // Add extra data about the user
                completion(result!.user.uid)
            }
        }
    }
    
    
    // Insert extra data about the user in the database.
    // It is used a callback because we depend of the 'result' provided by the setData() function.
    static func addEmployerInformation(_ userId: String, _ firstName: String, _ lastName: String, _ email: String, _ position: String, _ company_rfc: String, completion: @escaping((_ data: String?) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Use a model to organize the employer information
        var employer = Employer()

        employer.firstName = firstName
        employer.lastName = lastName
        employer.email = email
        employer.position = position
        employer.company_rfc = company_rfc


        // Store the information in the database
        db.collection("employers").document(userId).setData([
            "firstName": employer.firstName,
            "lastName": employer.lastName,
            "email": employer.email,
            "position": employer.position,
            "company_rfc": employer.company_rfc
        ]) { (error) in

            // Check for errors
            if error != nil {

                // There was an error adding the user data to the database
                completion("Error creating the user")
            }
            
            // If the insertion was executed correctly return nil
            completion(nil)
        }
    }
    
    static func addRating(_ userId: String, _ rating: [Float], completion: @escaping((_ data: String?) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Use a model to organize the employer information
        var employer = Employer()

        employer.rating = rating


        // Store the information in the database
        db.collection("employers").document(userId).setData([
            "rating": employer.rating
        ], merge: true) { (error) in

            // Check for errors
            if error != nil {

                // There was an error adding the user data to the database
                completion("Error creating the user")
            }
            
            // If the insertion was executed correctly return nil
            completion(nil)
        }
    }
    
    // Delete employer offets
    static func deleteEmployerOffers(_ userId: String, completion: @escaping((_ data: String?) -> Void)){
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Delete all the student notifications of the job offers
        db.collection("offers").whereField("userId", isEqualTo: userId).getDocuments() { (documents, err) in
           
            if let error = err {
                completion("Error getting the documents \(error)")
            } else {
                
                // For each employer's offer
                for document in documents!.documents {

                    var jobOffer = JobOffer()
                    jobOffer.offerKey = document.documentID
                    
                    JobOffersDAO.deleteOffer(offer: jobOffer)
                }
            }
            completion("Job offers deleted successfully")
        }
    }
    
    
    // Delete the employer profile and login information
    static func deleteEmployer(_ userId: String){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Delete their information in the employer's collection
        db.collection("employers").document(userId).delete()
        
        // Delete their information in the user's collection
        db.collection("users").document(userId).delete()
        
        // Delete the information from authentication
        Auth.auth().currentUser?.delete()
    }
    
    
    static func getImage(_ userId: String, imageView: UIImageView){
        // Establish the connection with the database
        let db = Firestore.firestore()
        
         
       // Set a reference to the desired document
       let empRef = db.collection("employers").document(userId)
       
       empRef.getDocument { (document, error) in
           
           // If the specified document exist
           if let document = document, document.exists {
               
               let empData = document.data()
            guard let urlString = empData!["profilePicture"] as? String else{
                //print("error: does not have profile picture")
                return
            }
            guard let url = URL(string: urlString) else{
                print("error with url string ")
                return
            }
            let resource = ImageResource(downloadURL: url)
            imageView.kf.setImage(with: resource, completionHandler: { (result) in
                switch result{
                    
                case .success(_):
                    print("succesfully got image to the imageview")
                case .failure(_):
                    print("ERROR coudn't get image to the imageview")
                }
            })
           } else {
               
               print("did not find document for the url in getImage employerDAO")
           }
        
        }
    }
    static func setImage(_ userId: String, _ image: UIImage, completion: @escaping ()-> Void){
        print("going to upload picture to the db")
        let data = image.jpegData(compressionQuality: 0.1)
        
        
        let imageName = UUID().uuidString
        
        let imageReference = Storage.storage().reference().child("employerImages").child(imageName)
        
        imageReference.putData(data!, metadata: nil){(metadata, error) in
            
            if error != nil{
                print("error puting image url")
                return
            }
            imageReference.downloadURL { (url, error) in
                if error != nil{
                    print("error retrieving image url")
                    return
                }
                if url == nil{
                    print("error retrieving image url, it's null")
                    return
                }
                let urlString = url?.absoluteString
                let db = Firestore.firestore()
                
                    // Store the information in the database
                    db.collection("employers").document(userId).updateData([
                        "profilePicture": urlString ?? "error"
                    ]) { (error) in

                        // Check for errors
                        if error != nil {
                            print("error uploading image to the db")
                            return
                        }
                        print("succesfully added image to the db")
                        completion()
                        
                    }
        }
    }
        
   
        
        
    }
    // Get the user id
    static func getUserId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    
    // Get the company rfc
    static func getCompamnyRfc(_ userId: String, completion: @escaping((_ data: String?) -> Void)) {
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let empRef = db.collection("employers").document(userId)
        
        empRef.getDocument { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                let empData = document.data()
                var companyRfc: String
                
                companyRfc = empData!["company_rfc"] as? String ?? ""
                
                // Returns an object company with all its data
                completion(companyRfc)
            } else {
                
                // Returns an error message
                completion("Error retrieving the user data")
            }
        }
    }
    
    
    // Get the general information of the employer
    static func getEmployerInformation(_ userId: String, completion: @escaping(((String?), (Employer?)) -> Void)) {
    
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let empRef = db.collection("employers").document(userId)
        
        empRef.getDocument { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                let empData = document.data()
                var employer = Employer()
                
                employer.firstName = empData!["firstName"] as? String ?? ""
                employer.lastName = empData!["lastName"] as? String ?? ""
                employer.email = empData!["email"] as? String ?? ""
                employer.position = empData!["position"] as? String ?? ""
                employer.company_rfc = empData!["company_rfc"] as? String ?? ""
                
                // Returns an object employer with all their data
                completion(nil, employer)
            } else {
                
                // Returns an error message
                completion("Error retrieving the user data", nil)
            }
        }
    }
    
    static func getEmployerRatings(_ userId: String, completion: @escaping(((String?), ([Float]?)) -> Void)) {
    
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let empRef = db.collection("employers").document(userId)
        
        empRef.getDocument { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                let empData = document.data()
                
                let rating: [Float] = empData!["rating"] as? [Float] ?? []
                
                // Returns an object employer with all their data
                completion(nil, rating)
            } else {
                
                // Returns an error message
                completion("Error retrieving the employer rating", nil)
            }
        }
    }
}
