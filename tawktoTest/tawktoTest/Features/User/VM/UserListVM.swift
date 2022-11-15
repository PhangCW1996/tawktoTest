//
//  UserListVM.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//


import Foundation
import UIKit
import Combine
import CoreData

final class UserListVM: BaseViewModel, ObservableObject {
    
    private lazy var request: UserListRequest = {
        return UserListRequest()
    }()
    
    
    // MARK: Input
    private let sendSubject = PassthroughSubject<Void, Never>()
    
    @Published var filter = ""
    
    enum Input {
        case getUserList
    }
    
    var since = 0
    
    func apply(_ input: Input) {
        switch input {
        case .getUserList:
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
            
            for userModel in data {
                User.createOrUpdate(item: userModel, with: AppDelegate.sharedAppDelegate.coreDataStack)
            }
        
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in Core Data
            
            self.isLastPage = data.count == 0
            
            let allUser =  User.getAllUsers(with: AppDelegate.sharedAppDelegate.coreDataStack)
            self.userList = allUser
            
            if let nextSince = allUser.last?.id{
                self.since = Int(nextSince)
            }
                    
            print("Alluser \(allUser.count)")
        }
        
        
        
        $filter
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] keyword in
                guard let `self` = self else { return }
                if keyword == ""{
                    let allUser =  User.getAllUsers(with: AppDelegate.sharedAppDelegate.coreDataStack)
                    self.userList = allUser
                }else{
                    let allUser =  User.searchUsers(keyword: keyword ,with: AppDelegate.sharedAppDelegate.coreDataStack)
                    self.userList = allUser
                }
            })
            .store(in: &self.cancellables)
    }
    
    

    
}
