//
//  PostDetailViewController.swift
//  Incopo
//
//  Created by Laurentiu Ile on 24.02.2021.
//

import UIKit

class PostDetailViewController: UITableViewController {
    
    var post = Post()
    var authorName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        configurePostPicture()
    }
    
    func downloadImage(imageURL: String, completionHandler: @escaping (UIImage) -> Void) {
        
        if let url = URL(string: imageURL) {
            let downloadTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
                guard let imageData = data else {
                    return
                }
                
                OperationQueue.main.addOperation {
                    guard let image = UIImage(data: imageData) else {
                        return
                    }
                    completionHandler(image)
                }
            }
            downloadTask.resume()
        }
    }
    
    func fetchAuthor(authorID: String, completionHandler: @escaping () -> Void) {
   
        let userRef = FirestoreManager.shared.collection(FirebaseConstants.userCollection).document(authorID)
        userRef.getDocument { (document, error) in
            
            if error != nil {
                ICPAlert.showAlert(on: self, with: "Author Error".localized, message: "Unable to retrieve author".localized)
            }
            
            guard let document = document else {
                return
            }
            
            let data = document.data()
            
            if let firstName = data?[FirebaseConstants.firstName] as? String,
               let lastName = data?[FirebaseConstants.lastName] as? String {
                self.authorName = "\(firstName) \(lastName)"
                completionHandler()
            }
        }
    }
    
    func configurePostPicture(postPictureImageView: UIImageView, headerView: UIView) {
        
        postPictureImageView.translatesAutoresizingMaskIntoConstraints = false
        postPictureImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            postPictureImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            postPictureImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            postPictureImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            postPictureImageView.heightAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 9.0/16.0)
        ])
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + post.comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        
        case 0:
            guard let imageCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.imageCell, for: indexPath)
                    as? ImageCell else {
                return UITableViewCell()
            }
            
            downloadImage(imageURL: post.imageURL) { (image) in
                imageCell.postImageView.image = image
            }
            
            return imageCell
        
        case 1:
            guard let postDetailCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.postDetailCell, for: indexPath)
                    as? PostDetailCell else {
                return UITableViewCell()
            }
            configurePostCellData(postDetailCell: postDetailCell)
            return postDetailCell
            
        default:
            guard let commentCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.commentCell, for: indexPath)
                    as? CommentCell else {
                return UITableViewCell()
            }

            let commentsOwners = Array(post.comments.keys)
            let currentCommentOwner = commentsOwners[indexPath.row - 2]
            let commentsContent = Array(post.comments.values)
            let currentCommentMessage = commentsContent[indexPath.row - 2]

            commentCell.nameLabel.text = currentCommentOwner
            commentCell.commentTextView.text = currentCommentMessage
            return commentCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configurePostCellData(postDetailCell: PostDetailCell) {
        postDetailCell.postContentTextView.isEditable = false
        
        postDetailCell.titleLabel.text = post.poemTitle
        postDetailCell.postContentTextView.text = post.poemText
        fetchAuthor(authorID: post.authorID) {
            postDetailCell.byAuthorLabel.text = "by ".localized + self.authorName
        }
        postDetailCell.noLikesLabel.text = String(post.numberOfLikes)
        postDetailCell.noCommentsLabel.text = String(post.numberOfComments)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UIScreen.main.bounds.width * 9.0 / 16.0
        }
        
        return UITableView.automaticDimension
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UIScreen.main.bounds.width * 9.0/16.0
//    }
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return UIScreen.main.bounds.width * 9.0 / 16.0
//    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let postPictureImageView = UIImageView()
//
//        downloadImage(imageURL: post.imageURL, postPictureImageView: postPictureImageView)
//
//        let headerView = UIView()
//        headerView.backgroundColor = .white
//        headerView.addSubview(postPictureImageView)
//
//        //configurePostPicture(postPictureImageView: postPictureImageView, headerView: headerView)
//
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        postPictureImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            postPictureImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
//            postPictureImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
//            postPictureImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
//            postPictureImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
//            postPictureImageView.heightAnchor.constraint(equalToConstant: 300)
//        ])
//
//        return headerView
//    }
}
