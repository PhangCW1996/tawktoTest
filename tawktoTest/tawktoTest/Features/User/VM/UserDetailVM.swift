//
//  UserDetailVM.swift
//  tawktoTest
//
//  Created by Superman on 15/11/2022.
//

import Foundation
import UIKit
import Combine
import CoreData

final class UserDetailVM: BaseViewModel, ObservableObject {
    
    private lazy var request: UserDetailRequest = {
        return UserDetailRequest()
    }()
    
    // MARK: Input
    private let sendSubject = PassthroughSubject<Void, Never>()
    
    enum Input {
        case getUserDetail
    }
    
    func apply(_ input: Input) {
        switch input {
        case .getUserDetail:
            self.request.path = "users/\(user?.login ?? "")"
            self.sendSubject.send(())
        }
    }
    
    // MARK: Output
    @Published private(set) var userList: [User] = []
    
    @Published var user: User?
    @Published var requiredRefresh = false
    
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
            if let model = data.data {
                
                DispatchQueue.global().async {
    
                    self.user?.updateUserDetail(item: model)
                    AppDelegate.sharedAppDelegate.coreDataStack.synchronize()
        
                    //Update UI on main thread
                    DispatchQueue.main.async { [weak self] in
                        guard let `self` = self else { return }
                        if let user = User.getUserById(item: model, with: AppDelegate.sharedAppDelegate.coreDataStack.managedContext){
                            self.user = user
                        }
                    }
                }
            }
        }
        
    }
    
    //Save CD note
    func saveNote(note: String){
        // Use private MOC to perform background task
        let privateContext = AppDelegate.sharedAppDelegate.coreDataStack.privateMOC
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            privateContext.perform {
                self.user?.addOrUpdateNote(note: note)
                AppDelegate.sharedAppDelegate.coreDataStack.synchronize()
                self.requiredRefresh = true
            }
        }

    }
    
    //Update CD seen
    func updateSeen(){
        if !(self.user?.seen ?? false) {
            // Use private MOC to perform background task
            let privateContext = AppDelegate.sharedAppDelegate.coreDataStack.privateMOC
            DispatchQueue.global().async { [weak self] in
                guard let `self` = self else { return }
                privateContext.perform {
                    
                    self.user?.updateSeen()
                    AppDelegate.sharedAppDelegate.coreDataStack.synchronize()
                    self.requiredRefresh = true
                }
            }
        }
    }

}
