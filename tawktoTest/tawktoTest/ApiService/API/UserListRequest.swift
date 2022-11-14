//
//  UserListRequest.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import Foundation

class UserListRequest: APIRequestType {
    
    typealias Response = UserListResponse
    
    var path: String { return "/users" }

    var params: [String: Any] = [:]
    
    var method: APIMethod = .get
}
