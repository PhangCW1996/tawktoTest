//
//  DisconnectBannerView.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import UIKit

class DisconnectBannerView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var msg: UILabel!
    
    private var msgStr: String = ""
    
    var nibName: String {
         return String(describing: type(of: self))
     }
    
    init(frame: CGRect, msg: String) {
        super.init(frame: frame)
        self.msgStr = msg
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        self.commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: DisconnectBannerView.self)
        guard let customView = UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: self).first as? UIView else { return }
        customView.frame = bounds
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(customView)
        self.view = customView
        
        self.msg.text = self.msgStr
    }
    
}
