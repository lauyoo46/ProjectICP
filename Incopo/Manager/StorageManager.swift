//
//  StorageManager.swift
//  Incopo
//
//  Created by Laurentiu Ile on 19.02.2021.
//

import Foundation
import Firebase

class StorageManager {
    
    static let shared: StorageManager = StorageManager()
    
    private init() { }
    
    let storageReference: StorageReference = Storage.storage().reference().child(FirebaseConstants.postsStorageReference)
}
