//
//  UserNoteCell.swift
//  tawktoTest
//
//  Created by Superman on 15/11/2022.
//

import UIKit

class UserNoteCell: UITableViewCell, CustomUserCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var noteImg: UIImageView!
    
    var requiredInvert = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        selectionStyle = .none
        img.cornerRadius = img.frame.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withModel: CustomUserModel, row: Int) {
        if let model = withModel as? User{
            self.model = model
            
            self.requiredInvert = (row % 4) == 0
        }
    }
    
    
    var model: User?{
        didSet {
            if let model = model{
                lblName.text = model.login
                lblType.text = (model.siteAdmin ) ? "Site Admin" : "Normal"
                
                if model.seen{
                    backgroundColor = .lightGray.withAlphaComponent(0.2)
                }
                
                if let imgUrl = model.avatarUrl, !imgUrl.isEmpty{
                    ImageLoader.shared.loadImage(urlString: imgUrl) { [weak self] (urlStr,image) in
                        guard let `self` = self, let image = image else { return }
                        //If same url only set
                        if urlStr == self.model?.avatarUrl{
                            self.img.image = image
                            
                            if self.requiredInvert{
                                self.invertImg()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func invertImg(){
        self.img.image = img.image?.invertedImage()
    }
}
