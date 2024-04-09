//
//  editViewController.swift
//  Assignment4- phone contact app
//
//  Created by Administrator on 04/03/24.
//

import UIKit

protocol editViewControllerDelegate: AnyObject{
    func didUpdateContact(_ contact: Contacts, atIndex index: Int)
}

class editViewController: UIViewController {
    
    weak var delegate: editViewControllerDelegate?

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailID: UITextField!
    
    var data = [Contacts]()
    var img = UIImage()
    var name = ""
    var phnum = ""
    var email = ""
    var contactIndex: Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullName.text = name
        image.image = img
        phoneNumber.text = phnum
        emailID.text = email
        // Do any additional setup after loading the view.
    }

    @IBAction func saveChanges(_ sender: UIButton) {
        if contactIndex >= 0 && contactIndex < data.count{
            data[contactIndex].firstName = fullName.text ?? ""
            data[contactIndex].mobileNumber = phoneNumber.text ?? ""
            data[contactIndex].email = emailID.text ?? ""
            
            //notify the delegate about the updated contact
            delegate?.didUpdateContact(data[contactIndex], atIndex: contactIndex)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
//    private func saveButton(){
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: <#T##UIBarButtonItem.SystemItem#>, target: <#T##Any?#>, action: <#T##Selector?#>)
//    }
}


