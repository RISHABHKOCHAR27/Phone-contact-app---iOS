//
//  newContactViewController.swift
//  Assignment4- phone contact app
//
//  Created by Administrator on 04/03/24.
//

import UIKit

class newContactViewController: UIViewController{

    @IBOutlet weak var contactImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactImage.layer.masksToBounds = true
        contactImage.layer.cornerRadius = contactImage.frame.height/2
        
        // Do any additional setup after loading the view.
    }
   

}

//extension newContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        image.image = info[.originalImage] as? UIImage
//        dismiss(animated: true)
//    }
//}
