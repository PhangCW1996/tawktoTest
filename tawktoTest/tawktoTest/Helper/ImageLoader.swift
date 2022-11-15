//
//  ImageLoader.swift
//  tawktoTest
//
//  Created by Superman on 15/11/2022.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    func getCachedImage(key: String) -> UIImage?{
        return self.cache.object(forKey: NSString(string: key))
    }
    
    func loadImage(urlString: String,completion: @escaping (String,UIImage?) -> ()) {
        if urlString == "" {return}
        
        if let cacheImage = getCachedImage(key: urlString){
            DispatchQueue.main.async {
                print("Using a cached image for url: \(urlString)")
                completion(urlString,cacheImage)
            }
        }else{
            utilityQueue.async {
                let url = URL(string: urlString)!
                
                guard let data = try? Data(contentsOf: url) else { return }
                if let image = UIImage(data: data){
                    self.cache.setObject(image, forKey: NSString(string: urlString))
                    DispatchQueue.main.async {
                        completion(urlString,image)
                    }
                }
            }
        }
    }
}

