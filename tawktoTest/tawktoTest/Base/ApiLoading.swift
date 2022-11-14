//
//  ApiLoading.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import Foundation

final class ApiLoading {
    @Published
    var loading: Bool = false
    
    init(loading: Bool) {
        self.loading = loading
    }
}
