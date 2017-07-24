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
    
    var images = NSCache<NSString, UIImage>()
    
    let fileSystem = FileManager.default
    
    func tryGetImageFromCache(url: URL) -> UIImage? {
        if let image = images.object(forKey: urlToHash(url: url) as NSString) {
            return image
        }
        
        if let image = getImageFromFileSystem(url: url) {
            images.setObject(image, forKey: urlToHash(url: url) as NSString)
            return image
        }
        return nil
    }
    
    func loadImage(imageUrl: URL, callback: @escaping (UIImage?, URLResponse?, Error?) -> Void) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: imageUrl) { [unowned images] (data, response, error) in
            guard let data = data else {
                callback(nil, nil, error)
                return
            }
            
            if let image = UIImage(data: data) {
                self.writeImageToFileSystem(image: image, imageUrl: imageUrl)
                images.setObject(image, forKey: self.urlToHash(url: imageUrl) as NSString)
                callback(image, nil, nil)
            }
        }
        task.resume()
    }
    
    private func writeImageToFileSystem(image: UIImage?, imageUrl: URL) {
        
        if let imageExist = image {
            
            let newDir = cacheFolder().path
        
            if !fileSystem.fileExists(atPath: newDir) {
                createNewDir(path: newDir)
            }
            
            let imageData = UIImagePNGRepresentation(imageExist)
            let hashImageName = urlToHash(url: imageUrl)
            let imageSavePath = getDicImagePath(urlImage: hashImageName).path
            
            fileSystem.createFile(atPath: imageSavePath, contents: imageData, attributes: nil)
        }
    }
    
    private func getImageFromFileSystem(url: URL) -> UIImage? {
        
        let hashImageName = urlToHash(url: url)
        
        if let data = fileSystem.contents(atPath: getDicImagePath(urlImage: hashImageName).path) {
            let image = UIImage(data: data)
            return image
        }
        
        return nil
    }
    
    private func urlToHash(url: URL) -> String {
        return (url.path).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    private func getDocumentDir() -> URL {
        let dirPath = fileSystem.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDir = dirPath[0]
        return docsDir
    }
    
    private func createNewDir(path: String) {
        do {
            try fileSystem.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print("Error \(error.localizedDescription)")
        }
    }
    
    private func cacheFolder() -> URL {
        let docsDir = getDocumentDir()
        return docsDir.appendingPathComponent(Constans.directoryName.dicName)
    }

    private func getDicImagePath(urlImage: String) -> URL {
        return cacheFolder().appendingPathComponent(urlImage)
    }
    
    
}
