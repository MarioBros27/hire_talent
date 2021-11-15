//
//  CompanyDAO.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 09/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation
import Firebase

class CompanyDAO {
    
    // Add the company data.
    // It is used a callback because we depend of the 'result' provided by the setData() function.
    static func addCompanyInformation(_ rfc: String, _ name: String, _ address_1: String, _ address_2: String, _ city: String, _ state: String, completion: @escaping((_ data: String?) -> Void)) {
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Use a model to organize the company information
        var company = Company()
        
        company.rfc = rfc
        company.name = name
        company.address_1 = address_1
        company.address_2 = address_2
        company.city = city
        company.state = state
        
        // Check if the company data is already registered
        let companyRef = db.collection("company").document(company.rfc)

        companyRef.getDocument { (document, error) in

            // If document already exists
            if let document = document, document.exists {
                completion(nil)
            }
            else {
                db.collection("company").document(company.rfc).setData([
                    "name": company.name,
                    "address_1": company.address_1,
                    "address_2": company.address_2,
                    "city": company.city,
                    "state": company.state
                ]) { (error) in

                   // Check for errors
                    if error != nil {

                        // There was an error creating the company
                        completion("There was an error creating the company")
                    }
                }
                completion(nil)
            }
        }
    }
    
    
    // Get the general information of a compnay
    static func getCompanyInformation(_ rfc: String, completion: @escaping(((String?), (Company?)) -> Void)) {
    
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let compRef = db.collection("company").document(rfc)
        
        compRef.getDocument { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                let compData = document.data()
                var company = Company()
                company.rfc = rfc
                company.name = compData!["name"] as? String ?? ""
                company.address_1 = compData!["address_1"] as? String ?? ""
                company.address_2 = compData!["address_2"] as? String ?? ""
                company.city = compData!["city"] as? String ?? ""
                company.state = compData!["state"] as? String ?? ""
                
                // Returns an object company with all its data
                completion(nil, company)
            } else {
                
                // Returns an error message 
                completion("Error retrieving the user data", nil)
            }
        }
    }

}
