//
//  UserDetailRequest.swift
//  tawktoTest
//
//  Created by Superman on 15/11/2022.
//

import Foundation

class UserDetailRequest: APIRequestType {
    
    typealias Response = UserDetailResponse
    
    var path: String = ""

    var params: [String: Any] = [:]
    
    var method: APIMethod = .get
}
