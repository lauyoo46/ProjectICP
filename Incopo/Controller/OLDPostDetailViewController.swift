//
//  PostDetailViewController.swift
//  Incopo
//
//  Created by Laurentiu Ile on 12.02.2021.
//

import UIKit

class OLDPostDetailViewController: UIViewController {

    @IBOutlet weak var postPictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var byAuthorLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var noLikesLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var likesCommentsStackView: UIStackView!
    @IBOutlet weak var likesCommentsFavoriteStackView: UIStackView!

    var post = Post()
    var authorName: String = "" {
        didSet {
            byAuthorLabel.text = "by ".localized + authorName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        commentsTableView.delegate = self
        commentsTableView.dataSource = self

        configurePostData()
        configurePostPicture()
        configurePostView()
        configureTitleLabel()
        configurePostContentView()
        configureAuthorLabel()
        configureLikesCommentsFavoriteStackView()
        configureCommentsTableView()
    }

    func configurePostData() {
        postContentTextView.isEditable = false

        downloadImage(imageURL: post.imageURL)
        titleLabel.text = post.poemTitle
        postContentTextView.text = post.poemText
        fetchAuthor(authorID: post.authorID)
        noLikesLabel.text = String(post.numberOfLikes)
        noCommentsLabel.text = String(post.numberOfComments)
    }

    func downloadImage(imageURL: String) {

        if let url = URL(string: imageURL) {
            let downloadTask = URLSession.shared.dataTask(with: url) { (data, _, _) in

                guard let imageData = data else {
                    return
                }

                OperationQueue.main.addOperation {
                    guard let image = UIImage(data: imageData) else {
                        return
                    }

                    self.postPictureImageView.image = image
                }
            }

            downloadTask.resume()
        }
    }

    func configurePostPicture() {

        postPictureImageView.translatesAutoresizingMaskIntoConstraints = false
        postPictureImageView.contentMode = .scaleAspectFill

        NSLayoutConstraint.activate([
            postPictureImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postPictureImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postPictureImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postPictureImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9.0/16.0)
        ])
    }

    func configurePostView() {

        postView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: postPictureImageView.bottomAnchor, constant: 10),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            postView.bottomAnchor.constraint(equalTo: commentsTableView.topAnchor, constant: -10)
        ])
    }

    func configureTitleLabel() {
        titleLabel.textAlignment = .center

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: postView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -10)
        ])
    }

    func configurePostContentView() {
        postContentTextView.isScrollEnabled = false

        postContentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postContentTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            postContentTextView.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 10),
            postContentTextView.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -10)
        ])
    }

    func configureAuthorLabel() {
        byAuthorLabel.textAlignment = .left

        byAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            byAuthorLabel.topAnchor.constraint(equalTo: postContentTextView.bottomAnchor, constant: 10),
            byAuthorLabel.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 10),
            byAuthorLabel.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -10)
        ])
    }

    func configureLikesCommentsFavoriteStackView() {
        likesCommentsFavoriteStackView.backgroundColor = .green

        likesCommentsFavoriteStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likesCommentsFavoriteStackView.topAnchor.constraint(equalTo: byAuthorLabel.bottomAnchor, constant: 10),
            likesCommentsFavoriteStackView.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 10),
            likesCommentsFavoriteStackView.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -10),
            likesCommentsFavoriteStackView.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -10)
        ])
    }

    func configureCommentsTableView() {

        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            commentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            commentsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }

    func fetchAuthor(authorID: String) {

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
            }
        }
    }
}

extension OLDPostDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OLDPostDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.numberOfComments
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.commentCell, for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }

        let commentsOwners = Array(post.comments.keys)
        let currentCommentOwner = commentsOwners[indexPath.row]
        let commentsContent = Array(post.comments.values)
        let currentCommentMessage = commentsContent[indexPath.row]

        commentCell.nameLabel.text = currentCommentOwner
        commentCell.commentTextView.text = currentCommentMessage
        return commentCell
    }
}