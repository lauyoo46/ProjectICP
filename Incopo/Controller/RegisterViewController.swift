//
//  RegisterViewController.swift
//  Incopo
//
//  Created by Laurentiu Ile on 09.02.2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    let decimalCharacters = CharacterSet.decimalDigits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        self.hideKeyboardWhenTappedOutside()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func singUpPressed(_ sender: Any) {
        
        let user = User(email: emailTextField.text,
                        firstName: firstNameTextField.text,
                        lastName: lastNameTextField.text,
                        password: passwordTextField.text,
                        recents: [],
                        profilePicture: UIImage())
        
        let error = validateUser(user: user)
        if let error = error {
            ICPAlert.showAlert(on: self, with: "Registration failed".localized, message: error)
            return
        }
        
        performRegistration(user: user)
    }
    
    func validateUser(user: User) -> String? {
        var error: String?
        
        let firstNameContainsDecimals = user.firstName?.rangeOfCharacter(from: decimalCharacters)
        if firstNameContainsDecimals != nil {
            error = "First Name must not contain decimals".localized
            return error
        }
        
        let lastNameContainsDecimals = user.lastName?.rangeOfCharacter(from: decimalCharacters)
        if lastNameContainsDecimals != nil {
            error = "Last Name must not contain decimals".localized
            return error
        }
        
        guard let confirmedPassword = confirmPasswordTextField.text else {
            error = "Confirmation field must not be empty".localized
            return error
        }
        if user.password != confirmedPassword {
            error = "Passwords does not match".localized
            return error
        }
        
        return error
    }
    
    func performRegistration(user: User) {
        guard let email = user.email,
              let password = user.password else {
            ICPAlert.showAlert(on: self, with: "Registration Error".localized, message: "Empty field found".localized)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            
            if let registrationError = error {
                ICPAlert.showAlert(on: self, with: "Registration Error".localized, message: registrationError.localizedDescription)
            } else {
                
                let userID = FirestoreManager.shared.collection(FirebaseConstants.userCollection).document().documentID
                UserDefaults.standard.setValue(userID, forKey: email)
                
                FirestoreManager.shared.collection(FirebaseConstants.userCollection).document(userID).setData([
                    FirebaseConstants.userID: userID,
                    FirebaseConstants.email: user.email,
                    FirebaseConstants.firstName: user.firstName,
                    FirebaseConstants.lastName: user.lastName,
                    FirebaseConstants.recents: []
                ])
                
                self.clearFields()
                
                ICPAlert.showAlert(on: self, with: "Registration Message".localized, message: "You registered successfully".localized)
            }
        }
    }
    
    func clearFields() {
        
        emailTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
