//
//  UserListVC.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import UIKit
import SwiftUI

class UserListVC: UIViewController,SkeletonDisplayable {
    
    @IBOutlet weak var tblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTblView()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell{
            cell.selectionStyle = .none
            

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hostingController = UIHostingController(rootView: UserDetailView())
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    
}
