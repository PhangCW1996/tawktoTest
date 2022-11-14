//
//  BaseViewController.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    var cancellables: [AnyCancellable] = []
    var rightBtnCallback: (() -> ())?
    var leftBtnCallback: (() -> ())?
    
    func localized() {}
    func refresh() {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.localized()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
        
    @objc private func pop() {
        if let leftBtnCallback = self.leftBtnCallback {
            leftBtnCallback()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func callback() {
        self.rightBtnCallback?()
    }
    
}
