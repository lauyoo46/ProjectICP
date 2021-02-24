//
//  MainTabBarViewController.swift
//  Incopo
//
//  Created by Laurentiu Ile on 17.02.2021.
//

import UIKit
import Firebase

class MainTabBarViewController: UITabBarController {

    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let userEmail = Auth.auth().currentUser?.email,
              let currentUserID = UserDefaults.standard.string(forKey: userEmail) else {
            return
        }
        
        userID = currentUserID
    }
}
