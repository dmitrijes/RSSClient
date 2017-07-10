//
//  ImageLoaderService.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 10.07.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation
import UIKit

class ImageLoaderService {
    
    var images = [Int: UIImage]()
    
    func tryGetImageFromCache(num: Int, imageUrl: URL, complition: @escaping (UIImage, Int) -> Void) {
        if let image = images[num] {
            complition(image, num)
        } else {
            loadImage(imageUrl: imageUrl) { (result) in
                guard let image = result else {
                    self.images[num] = #imageLiteral(resourceName: "imagePlaceHolder")
                    //DispatchQueue.main.async {
                        complition(self.images[num]!, num)
                    //}
                    return
                }
                self.images[num] = image
                //DispatchQueue.main.async {
                    complition(self.images[num]!, num)
                //}
            }
            
        }
    }
    
    private func loadImage(imageUrl: URL, callback: @escaping (UIImage?) -> Void) {
        if let imageURLData = try? Data(contentsOf: imageUrl) {
            DispatchQueue.global().async {
                if let image = UIImage(data: imageURLData) {
                    callback(image)
                }
            }
        }
    }
    
}
