//
//  UserListVM.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//


import Foundation
import Combine

final class UserListVM: BaseViewModel, ObservableObject {
    
    private lazy var request: UserListRequest = {
        return UserListRequest()
    }()


    // MARK: Input
    private let sendSubject = PassthroughSubject<Void, Never>()
    
    enum Input {
        case getUserList
        case getMoreUserList
    }
    
    var since = 0
    
    func apply(_ input: Input) {
        switch input {
        case .getUserList:
            self.isNotfirstPage = false
            self.isLastPage = false
            self.since = 0
            self.request.params = ["since" : self.since]
            
            self.sendSubject.send(())
        case .getMoreUserList:
            self.isNotfirstPage = true
            self.footLoading = true
            self.request.params = ["since" : self.since]
            
            self.sendSubject.send(())
        }
    }
    
    // MARK: Output
    @Published private(set) var userList: [User] = []
    
    private lazy var apiService: APIService = {
        return APIService()
    }()
    
    override init() {
        super.init()
        
        self.bindInputs()
    }
    
    private func bindInputs() {
         
        self.bindLoading(loading: self.apiService.apiLoading)
        
        self.bindApiService(request: self.request, apiService: self.apiService, trigger: self.sendSubject) { [weak self] data in
            guard let `self` = self else { return }
            
            self.footLoading = false
            
            let data = data.userList ?? []
            
            if self.isNotfirstPage {
                let new: [User] = data
                
                self.isLastPage = new.count == 0
                self.userList += new
            }else {
                self.userList = data
            }
            
            if let nextSince = data.last?.id{
                self.since = nextSince
            }
        }
    }
    
}
