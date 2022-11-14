//
//  UserCell.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        img.cornerRadius = img.frame.height / 2
        
        lblName.text = "Temp Name"
        lblType.text = "Type"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model: User?{
        didSet {
            if let model = model{
                lblName.text = model.login
                lblType.text = (model.siteAdmin ?? false) ? "Site Admin" : "Normal"
            }
        }
    }
}
