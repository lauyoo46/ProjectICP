//
//  Post.swift
//  Incopo
//
//  Created by Laurentiu Ile on 11.02.2021.
//

import UIKit

class Post {
    
    let postID: String
    let poemTitle: String
    let poemText: String
    let authorID: String
    var numberOfLikes: Int
    var numberOfComments: Int
    var comments: [String: String]
    
    init() {
        self.postID = ""
        self.poemTitle = ""
        self.poemText = ""
        self.authorID = ""
        self.numberOfLikes = 0
        self.numberOfComments = 0
        self.comments = [:]
    }
    
    init(postID: String,
         poemTitle: String,
         poemText: String,
         authorID: String,
         numberOfLikes: Int,
         numberOfComments: Int,
         comments: [String: String]) {
        
        self.postID = postID
        self.poemTitle = poemTitle
        self.poemText = poemText
        self.authorID = authorID
        self.numberOfLikes = numberOfLikes
        self.numberOfComments = numberOfComments
        self.comments = comments
    }
}
