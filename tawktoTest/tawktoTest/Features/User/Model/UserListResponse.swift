//
//  UserListResponse.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import Foundation

class UserListResponse: Codable {
    
    var userList: [User]?
    
    required init(from decoder: Decoder) throws {
        if var container = try? decoder.unkeyedContainer(){
            var result = [User]()
            while !container.isAtEnd{
                result.append(try container.decode(User.self))
            }
            userList = result
        }else{
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: ""))
        }
        
    }
    
}


struct User: Codable {
    var id: Int?
    var login: String?
    var siteAdmin: Bool?
}
