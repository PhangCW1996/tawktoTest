//
//  UserListVC.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import UIKit
import SwiftUI

class UserListVC: BaseViewController,SkeletonDisplayable {
    
    @IBOutlet weak var tblView: UITableView!
    
    private lazy var userVM: UserListVM = {
        return UserListVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTblView()
        bind()
        
        userVM.apply(.getUserList)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        showSkeleton()
    }
    
    @objc func refreshBottom() {
        self.userVM.apply(.getUserList)
    }
    
    private func bind(){
        userVM.$userList
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] list in
                guard let `self` = self else { return }
                self.tblView.reloadData()
            })
            .store(in: &self.cancellables)
    }
}

extension UserListVC: UITableViewDataSource, UITableViewDelegate{
    
    private func setupTblView(){
        tblView.register(UserCell.getNib(), forCellReuseIdentifier: UserCell.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVM.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell{
            cell.selectionStyle = .none
            
            cell.model = userVM.userList[indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hostingController = UIHostingController(rootView: UserDetailView())
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    

}
