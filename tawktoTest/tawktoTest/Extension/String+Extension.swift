//
//  String+Extension.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}
