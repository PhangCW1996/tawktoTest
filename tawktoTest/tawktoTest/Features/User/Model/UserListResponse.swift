//
//  UserListResponse.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import Foundation
import CoreData

class UserListResponse: Codable {
    
    var userList: [UserModel]?
    
    required init(from decoder: Decoder) throws {
        if var container = try? decoder.unkeyedContainer(){
            var result = [UserModel]()
            while !container.isAtEnd{
                result.append(try container.decode(UserModel.self))
            }
            userList = result
        }else{
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: ""))
        }
        
    }
    
}


struct UserModel: Codable {
    var id: Int?
    var login: String?
    var siteAdmin: Bool?
}
