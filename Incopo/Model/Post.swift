//
//  Post.swift
//  Incopo
//
//  Created by Laurentiu Ile on 11.02.2021.
//

import UIKit

class Post {
    
    var postID: String
    var poemTitle: String
    var poemText: String
    var authorID: String
    var numberOfLikes: Int
    var numberOfComments: Int
    var comments: [String: String]
    var imageURL: String
    var timestamp: Int
    
    init() {
        self.postID = ""
        self.poemTitle = ""
        self.poemText = ""
        self.authorID = ""
        self.numberOfLikes = 0
        self.numberOfComments = 0
        self.comments = [:]
        self.imageURL = ""
        self.timestamp = 0
    }
    
    init(postID: String,
         poemTitle: String,
         poemText: String,
         authorID: String,
         numberOfLikes: Int,
         numberOfComments: Int,
         comments: [String: String],
         imageURL: String,
         timestamp: Int) {
        
        self.postID = postID
        self.poemTitle = poemTitle
        self.poemText = poemText
        self.authorID = authorID
        self.numberOfLikes = numberOfLikes
        self.numberOfComments = numberOfComments
        self.comments = comments
        self.imageURL = imageURL
        self.timestamp = timestamp
    }
}
