//
//  AddPostViewController.swift
//  Incopo
//
//  Created by Laurentiu Ile on 10.02.2021.
//

import UIKit
import FirebaseStorage

class AddPostViewController: UIViewController {

    @IBOutlet weak var poemImage: UIImageView!
    @IBOutlet weak var poemImageWrapperView: UIView!
    @IBOutlet weak var poemTitle: UITextField!
    @IBOutlet weak var poemText: UITextView!
    @IBOutlet weak var saveButton: UIButton!
 
    var imagePicked = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImageInteraction()
    }
    
    func createImageInteraction() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(pickImage(sender:)))
        poemImage.addGestureRecognizer(imageTap)
        poemImage.isUserInteractionEnabled = true
    }
    
    @objc func pickImage(sender: UITapGestureRecognizer) {
        
        let photoSourceRequestController = UIAlertController(title: "".localized,
                                                             message: "Choose photo source".localized,
                                                             preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library".localized, style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        
        if let popoverController = photoSourceRequestController.popoverPresentationController {
            popoverController.sourceView = poemImage
            popoverController.sourceRect = poemImage.bounds
        }
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        guard let poemTitle = poemTitle.text, poemTitle != "",
              let poemText = poemText.text, poemText != "" else {
            
            ICPAlert.showAlert(on: self, with: "Post error".localized, message: "A poem can not have title or text empty".localized)
            return
        }
        
        let currentUserID = fetchUserID()
        
        let postID = FirestoreManager.shared.collection(FirebaseConstants.postCollection).document().documentID
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        
        uploadImage(postID: postID, image: imagePicked) { [weak self] imageURL in
            
            guard let self = self else {
                return
            }
            
            FirestoreManager.shared.collection(FirebaseConstants.postCollection).document(postID).setData([
                FirebaseConstants.postID: postID,
                FirebaseConstants.poemTitle: poemTitle,
                FirebaseConstants.poemText: poemText,
                FirebaseConstants.numberOfLikes: 0,
                FirebaseConstants.numberOfComments: 0,
                FirebaseConstants.comments: [:],
                FirebaseConstants.authorID: currentUserID,
                FirebaseConstants.imageURL: imageURL,
                FirebaseConstants.postTimestamp: timestamp
            ])
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func fetchUserID() -> String {
        let tabBarController = MainTabBarViewController()
        return tabBarController.userID
    }
}

extension AddPostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            poemImage.image = selectedImage
            poemImage.contentMode = .scaleAspectFit
            poemImage.backgroundColor = .clear
            poemImage.clipsToBounds = true
            
            imagePicked = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(postID: String, image: UIImage, completionHandler: @escaping (String) -> Void ) {
        let imageID = postID
        
        let imageStorageReference = StorageManager.shared.storageReference.child("\(imageID).jpg")
        let scaledImage = image.scale(newWidth: 640.0)
        
        guard let imageData = scaledImage.jpegData(compressionQuality: 0.9) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let uploadTask = imageStorageReference.putData(imageData, metadata: metadata)
        uploadTask.observe(.success) { (snapshot) in
            
            snapshot.reference.downloadURL { (url, _) in
                guard let url = url else {
                    return
                }
            
                completionHandler(url.absoluteString)
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            
            if let error = snapshot.error {
                ICPAlert.showAlert(on: self, with: "Image Error".localized, message: error.localizedDescription)
            }
        }
    }
}

extension AddPostViewController: UINavigationControllerDelegate {}
