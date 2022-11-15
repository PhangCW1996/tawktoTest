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
    var avatarUrl: String?
    
    var followers: Int?
    var following: Int?
    
    var name: String?
    var company: String?
    var blog: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID
        case avatarUrl
        case siteAdmin
        case followers, following
        case name, company, blog
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        login = try? values.decode(String.self, forKey: .login)
        siteAdmin = try? values.decode(Bool.self, forKey: .siteAdmin)
        avatarUrl = try? values.decode(String.self, forKey: .avatarUrl)
        followers = try? values.decode(Int.self, forKey: .followers)
        following = try? values.decode(Int.self, forKey: .following)
        
        name = try? values.decode(String.self, forKey: .name)
        company = try? values.decode(String.self, forKey: .company)
        blog = try? values.decode(String.self, forKey: .blog)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(login, forKey: .login)
        try container.encode(siteAdmin, forKey: .siteAdmin)
        try container.encode(avatarUrl, forKey: .avatarUrl)
        try container.encode(followers, forKey: .followers)
        try container.encode(following, forKey: .following)
        
        try container.encode(name, forKey: .name)
        try container.encode(company, forKey: .company)
        try container.encode(blog, forKey: .blog)
    }
}
