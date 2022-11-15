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
    @IBOutlet weak var noteImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        img.cornerRadius = img.frame.height / 2
        
        lblName.text = "Temp Name"
        lblType.text = "Type"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
        noteImg.isHidden = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var model: User?{
        didSet {
            if let model = model{
                lblName.text = model.login
                lblType.text = (model.siteAdmin ) ? "Site Admin" : "Normal"
                
                noteImg.isHidden = model.note?.isEmpty ?? true || model.note == ""
                
                if let imgUrl = model.avatarUrl, !imgUrl.isEmpty{
                    ImageLoader.shared.loadImage(urlString: imgUrl) { [weak self] (urlStr,image) in
                        guard let `self` = self, let image = image else { return }
                        //If same url only set
                        if urlStr == self.model?.avatarUrl{
                            self.img.image = image
                        }
                    }
                }
            }
        }
    }
}
