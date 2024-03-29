//
//  contactTableViewCell.swift
//  Assignment4- phone contact app
//
//  Created by Administrator on 06/03/24.
//

import UIKit

class contactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    
    @IBOutlet weak var firstName: UILabel!
       
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var likeTapped: UIButton!
    
    var likeButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton){
        likeButtonTapped?()
    }
    
}
