//
//  APIServiceError.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import Foundation

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
    case apiError
}

enum ApiResult<Value, Error> {
    case success(Value)
    case failure(Error)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: Error){
        self = .failure(error)
    }
}

struct ApiErrorMsg: Decodable, Hashable {
    var status: Bool
    var code: Int
    var msg: String
}
