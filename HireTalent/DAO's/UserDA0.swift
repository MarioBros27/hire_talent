//
//  UserDA0.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 19/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class UserDAO {
    
    // Create the user adding it to the Authentication Section of Firebase.
    // It is used a callback because we depend of the 'result' provided by the createUser() function.
    static func addUserInformation(_ userId: String, completion: @escaping((_ data: String?) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        
        // Store the information in the database
        db.collection("users").document(userId).setData([
            "type": "Employer"
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
    
     static func addStudentInUsers(_ userId: String, completion: @escaping((_ data: String?) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Store the information in the database
        db.collection("users").document(userId).setData([
            "type": "Student"
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
    
    
    // Get the type of the user
    static func getType(_ userId: String, completion: @escaping((_ data: String?) -> Void)) {
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                let userData = document.data()
                var userType: String
                
                userType = userData!["type"] as? String ?? ""
                
                // Returns an object company with all its data
                completion(userType)
            } else {
                
                // Returns an error message
                completion("Error retrieving the user data")
            }
        }
    }
}
