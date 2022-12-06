//
//  UserListVC.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import UIKit
import SwiftUI

class UserListVC: BaseViewController,SkeletonDisplayable {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    private lazy var userVM: UserListVM = {
        return UserListVM()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTblView()
        bind()
    
        // Do any additional setup after loading the view.
    }
    
    override func refresh() {
        userVM.apply(.getUserList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func bind(){
        searchBar.delegate = self
        
        userVM.$userList
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] list in
                guard let `self` = self else { return }
            
                self.tblView.reloadData()
                self.tblView.stopLoading()
            })
            .store(in: &self.cancellables)
        
        searchBar.searchTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                guard let `self` = self else { return }
                self.userVM.filter = text
            })
            .store(in: &self.cancellables)
        
    }
}

//SearchBar Delegate
extension UserListVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides the keyboard.
    }
}

extension UserListVC: UITableViewDataSource, UITableViewDelegate{
    
    private func setupTblView(){
        tblView.register(UserCell.getNib(), forCellReuseIdentifier: UserCell.identifier)
        tblView.register(UserNoteCell.getNib(), forCellReuseIdentifier: UserNoteCell.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVM.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = userVM.userList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.type.getCellIdentifier()) as! CustomUserCell
        cell.configure(withModel: userVM.userList[indexPath.row], row: indexPath.row + 1)
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = userVM.userList[indexPath.row] as? User
        var vc = UserDetailView(user: model)
        vc.callback = { [weak self] user in
            guard let `self` = self else { return }
            self.userVM.userList[indexPath.row] = user
        }
        let hostingController = UIHostingController(rootView: vc)
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Add bottom loading when reach the end
        
        //If is not last page and is not loading and not doing filter
        if !self.userVM.isLastPage && !self.userVM.footLoading && self.userVM.filter == ""{
            tableView.addLoading(indexPath) {
                self.userVM.footLoading = true
                self.userVM.apply(.getUserList)
            }
        }
    }

}


enum CustomUserType: String {
    case normal
    case note
    
    func getCellIdentifier() -> String{
        switch self{
        case .note:
            return UserNoteCell.identifier
        case .normal:
            return UserCell.identifier
        }
    }
}

protocol CustomUserModel: AnyObject {
    var type: CustomUserType { get }
}

protocol CustomUserCell: AnyObject {
    func configure(withModel: CustomUserModel, row: Int)
}

extension User:CustomUserModel{
    
    var type: CustomUserType {
        get {
            if self.note == "" || self.note == nil{
                return .normal
            }
            return .note
        }
    }
}
