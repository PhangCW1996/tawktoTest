//
//  UserDetailResponse.swift
//  tawktoTest
//
//  Created by Superman on 15/11/2022.
//

import Foundation

class UserDetailResponse: Codable {
    
    var data: UserModel?
    
    required init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(){
            data = try container.decode(UserModel.self)
        }else{
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: ""))
        }
        
    }

}
