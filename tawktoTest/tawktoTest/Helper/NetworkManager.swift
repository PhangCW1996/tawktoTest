//
//  NetworkManager.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import UIKit
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
    private let duration: TimeInterval = 0.25
    private var banner: DisconnectBannerView?
    private let showFrame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    private let hideFrame: CGRect = CGRect(x: 0, y: -50, width: UIScreen.main.bounds.width, height: 50)
    var networtSatisfied: Bool = true
    @Published var requiredRefresh = false
    
    func show() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        if let window = windowScenes?.windows.first{
            NetworkManager.shared.requiredRefresh = false
            self.networtSatisfied = false
            if self.banner == nil {
                self.banner = DisconnectBannerView(frame: self.hideFrame, msg: "Network Disconnected")
                if let banner = self.banner{
                    window.addSubview(banner)
                    //                window.isUserInteractionEnabled = false
                    UIView.animate(withDuration: self.duration) { [weak self] in
                        guard let `self` = self else { return }
                        self.banner?.frame = self.showFrame
                    }
                }
            }
        }
    }
    
    func hide() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let _ = windowScenes?.windows.first
        
        NetworkManager.shared.requiredRefresh = true
        self.networtSatisfied = true
        UIView.animate(withDuration: self.duration) { [weak self] in
            guard let `self` = self else { return }
            self.banner?.frame = self.hideFrame
            //            window.isUserInteractionEnabled = true
        } completion: { [weak self] _ in
            guard let `self` = self else { return }
            self.banner?.removeFromSuperview()
        }
        
    }
}


