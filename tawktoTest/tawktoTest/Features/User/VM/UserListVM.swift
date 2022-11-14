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
            self.isNotfirstPage = true
            self.since = 0
            self.request.params = ["since" : self.since]
            
            self.sendSubject.send(())
        case .getMoreUserList:
            self.isNotfirstPage = false
            self.request.params = ["since" : self.since]
            
            self.sendSubject.send(())
        }
    }
    
    // MARK: Output
    let responseSubject = PassthroughSubject<UserListResponse, Never>()
    @Published private(set) var userList: [User] = []
    
    private lazy var apiService: APIService = {
        return APIService()
    }()
    
    override init() {
        super.init()
        
        self.bindInputs()
        self.bindOutputs()
    }
    
    private func bindInputs() {
         
        self.bindLoading(loading: self.apiService.apiLoading)
        
        self.bindApiService(request: self.request, apiService: self.apiService, trigger: self.sendSubject) { [weak self] data in
            guard let `self` = self else { return }
            
            self.responseSubject.send(data)
           
        }

    }
    
    private func bindOutputs() {
        self.responseSubject
            .print()
            .map {
                
                if self.isNotfirstPage {
                    let new: [User] = $0.userList ?? []
                    self.userList += new
                }else {
                    self.userList = $0.userList ?? []
                }
                
                if let nextSince = $0.userList?.last?.id{
                    self.since = nextSince
                    print("nextsince \(self.since)")
                }
                
                return $0.userList ?? []
            
            }
            .assign(to: \.self.userList, on: self)
            .store(in: &self.cancellables)
    
    }
    
}
