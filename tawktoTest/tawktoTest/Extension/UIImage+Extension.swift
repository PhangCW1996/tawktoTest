//
//  UIImage+Extension.swift
//  tawktoTest
//
//  Created by Superman on 16/11/2022.
//

import UIKit

extension UIImage {
    func invertedImage() -> UIImage? {
        guard let cgImg = self.cgImage else  { return self }
        
        let img = CoreImage.CIImage(cgImage: cgImg)
        
        if let filter = CIFilter(name: "CIColorInvert"){
            filter.setDefaults()
            filter.setValue(img, forKey: "inputImage")
            
            guard let outputImg = filter.outputImage else { return self }
            let context = CIContext(options:nil)
            guard let cgimg = context.createCGImage(outputImg, from: outputImg.extent) else { return nil }
            return UIImage(cgImage: cgimg)
        }
        
        return self
    }
}
