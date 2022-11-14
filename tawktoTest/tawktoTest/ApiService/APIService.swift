//
//  APIService.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import Foundation
import Combine
import UIKit


protocol APIServiceType {
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType
}

final class APIService: APIServiceType {
    
    let apiLoading: ApiLoading = ApiLoading(loading: false)
    var encoding: APIEncoding = .url
    var uploadPath: String = ""
    private var baseURL: URL?
    private var baseString: String
    
    init() {
        self.baseString = "https://api.github.com/"
        self.baseURL = URL(string: self.baseString)
    }

    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType {
        
        if let pathURL = URL(string: request.path, relativeTo: self.baseURL),
           var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true),
           let url: URL = urlComponents.url {
//            var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)
            
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
            switch self.encoding {
            case .url:
                urlComponents.queryItems =  request.getQueryItems()
                if let url = urlComponents.url {
                    urlRequest.url = url
                }
            case .json:
                let json = try? JSONSerialization.data(withJSONObject: request.params)
                urlRequest.httpBody = json
            }

            urlRequest.httpMethod = request.method.rawValue

            self.apiLoading.loading = true
            
            let decorder = JSONDecoder()
            decorder.keyDecodingStrategy = .convertFromSnakeCase
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .map { [weak self] data, urlResponse in
//                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
//                    print("json: \(json ?? "n/a")")
                    
                    self?.apiLoading.loading = false
                    
                    return data }
                .mapError { _ in APIServiceError.responseError }
                .decode(type: Request.Response.self, decoder: decorder)
                .mapError(APIServiceError.parseError)
                .receive(on: RunLoop.main)
                .retry(3)
                .eraseToAnyPublisher()
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
