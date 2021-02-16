//
//  NewsFeedViewController.swift
//  Incopo
//
//  Created by Laurentiu Ile on 09.02.2021.
//

import UIKit
import Firebase

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchPosts()
    }
    
    @objc func fetchPosts() {
        
        FirestoreManager.shared.collection(FirebaseConstants.postCollection).getDocuments(completion: { (snapshot, error) in
            
            if error != nil {
                ICPAlert.showAlert(on: self, with: "Newsfeed Error".localized, message: "No posts available".localized)
            }
            
            guard let documents = snapshot?.documents else {
                return
            }
            
            for document in documents {
                let data = document.data()
                
                if let postID = data[FirebaseConstants.postID] as? String,
                   let poemTitle = data[FirebaseConstants.poemTitle] as? String,
                   let poemText = data[FirebaseConstants.poemText] as? String,
                   let authorID = data[FirebaseConstants.authorID] as? String,
                   let numberOfLikes = data[FirebaseConstants.numberOfLikes] as? Int,
                   let numberOfComments = data[FirebaseConstants.numberOfComments] as? Int,
                   let comments = data[FirebaseConstants.comments] as? [String: String] {
                    let post = Post(postID: postID,
                                    poemTitle: poemTitle,
                                    poemText: poemText,
                                    authorID: authorID,
                                    numberOfLikes: numberOfLikes,
                                    numberOfComments: numberOfComments,
                                    comments: comments)
                    self.posts.append(post)
                }
            }
            
            self.collectionView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueConstants.showDetailVC {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                
                guard let destinationController = segue.destination as? PostDetailViewController else {
                    return
                }
                destinationController.post = posts[selectedIndexPath.row]
            }
        }
    }
}

extension NewsFeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellConstants.postCell, for: indexPath)
                as? PostCell else {
            return UICollectionViewCell()
        }
        
        postCell.titleLabel.text = posts[indexPath.row].poemTitle
        postCell.textLabel.text = posts[indexPath.row].poemText
        postCell.noLikesLabel.text = String(posts[indexPath.row].numberOfLikes)
        postCell.noCommentsLabel.text = String(posts[indexPath.row].numberOfComments)
        
        return postCell
    }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let iPadDevice = traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular
        
        let collectionViewSize = collectionView.frame.size
        let insets = 10
        let spacing = 10
        let cellHeight = collectionViewSize.height / 2
        
        if iPadDevice {
            let cellWidth = (Int(collectionViewSize.width) - (insets * 4) - spacing ) / 2
            
            return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
        }
        
        let cellWidth = Int(collectionViewSize.width) - (insets * 2)
        return CGSize(width: CGFloat(cellWidth), height: CGFloat(cellHeight))
    }
    
}
