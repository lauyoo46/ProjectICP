//
//  User.swift
//  Incopo
//
//  Created by Laurentiu Ile on 10.02.2021.
//

import UIKit

class User {
    
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var recents: [String?]
    var profilePicture: UIImage? = UIImage()
    
    init(
        email: String?,
        firstName: String?,
        lastName: String?,
        password: String?,
        recents: [String?],
        profilePicture: UIImage?
    ) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.recents = recents
        self.profilePicture = profilePicture
    }
}
