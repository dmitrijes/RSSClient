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
    
    var images = [URL: UIImage]()
    
    func tryGetImageFromCache(url: URL) -> UIImage? {
        if let image = images[url] {
            return image
        }
        return nil
    }
    
    func loadImage(imageUrl: URL, callback: @escaping (UIImage?, URLResponse?, Error?) -> Void) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: imageUrl) { (data, response, error) in
            guard let data = data else {
                callback(nil, nil, error)
                return
            }
            let image = UIImage(data: data)
            self.images[imageUrl] = image
            callback(image, nil, nil)
        }
        task.resume()
        
        
        
        
        
        //if let imageURLData = try? Data(contentsOf: imageUrl) {
        //    DispatchQueue.global().async {
        //        if let image = UIImage(data: imageURLData) {
        //            callback(image)
        //        }
        //    }
        //}
    }
    
}
