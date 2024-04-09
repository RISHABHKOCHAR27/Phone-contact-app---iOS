//
//  newContactViewController.swift
//  Assignment4- phone contact app
//
//  Created by Administrator on 04/03/24.
//

import UIKit

class newContactViewController: UIViewController{
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var contactImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactImage.layer.masksToBounds = true
        contactImage.layer.cornerRadius = contactImage.frame.height/2
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveContacts(_ sender: UIButton){
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else{
            displayError(message: "Enter First Name")
            return
        }
        guard let lastName = lastNameTextField.text, !firstName.isEmpty else{
            displayError(message: "Enter First Name")
            return
        }
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            displayError(message: "Please enter phone number")
            return
        }
        
        guard isValidPhoneNumber(phoneNumber) else {
            displayError(message: "Please enter valid phone number")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            displayError(message: "Please enter email")
            return
        }
        
        guard isValidEmail(email) else {
            displayError(message: "Please enter valid email")
            return
        }
        
        let newContact = Contacts(firstName: firstName, lastName: lastName, avatarUrl: "123", isFavourite: true, mobileNumber: phoneNumber, email: email, id: "5")
        
        if let contactListVC = navigationController?.viewControllers.first(where: {$0 is contactListViewController}) as? contactListViewController{
            contactListVC.addNewContact(newContact)
        }
            
        
        // need to save, add to data source and update UI
        
        navigationController?.popViewController(animated: true)
    }
    
    private func displayError(message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
            let phoneNumberRegex = #"^\d{10}$"#
            let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
            return phoneNumberPredicate.evaluate(with: phoneNumber)
        }

        private func isValidEmail(_ email: String) -> Bool {
            let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    
}

//extension newContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        image.image = info[.originalImage] as? UIImage
//        dismiss(animated: true)
//    }
//}
