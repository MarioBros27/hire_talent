//
//  ViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 05/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import AVKit
import FirebaseDatabase


class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    // This method is called before the view controller's view is about to be added to a view hierarchy and before any
    // animations are configured for showing the view.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    // This method is called before the view is actually removed and before any animations are configured.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // Style the elements
    func setUpElements() {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
    
    
    // When the user taps the Sign Up button
    @IBAction func signUpTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "signUpOptionScreen", sender: self)
    }
    
    
    // When the user taps the Login button
    @IBAction func loginTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "loginScreen", sender: self)
    }
    
}

