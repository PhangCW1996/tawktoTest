//
//  UITableViewCell+Extension.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import UIKit

extension UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    static func getNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
