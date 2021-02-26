//
//  Constants.swift
//  Incopo
//
//  Created by Laurentiu Ile on 10.02.2021.
//

import Foundation

struct FirebaseConstants {
    
    static let userCollection = "users"
    static let userID = "userID"
    static let email = "email"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let recents = "recents"
    
    static let postCollection = "posts"
    static let postID = "postID"
    static let poemTitle = "poemTitle"
    static let poemText = "poemText"
    static let authorID = "authorID"
    static let numberOfLikes = "numberOfLikes"
    static let numberOfComments = "numberOfComments"
    static let comments = "comments"
    static let imageURL = "imageURL"
    static let postTimestamp = "postTimestamp"
    
    static let storageURL = "gs://incopo-c916c.appspot.com"
    static let postsStorageReference = "posts"
}

struct CellConstants {
    
    static let imageCell = "ImageCell"
    static let postCell = "PostCell"
    static let postDetailCell = "PostDetailCell"
    static let commentCell = "CommentCell"
}

struct SegueConstants {
    
    static let showDetailVC = "showDetailVC"
}
