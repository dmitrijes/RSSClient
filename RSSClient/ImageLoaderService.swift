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
    
    private struct Constants {
        static let dicName = "ImagesForTable"
    }
    
    func tryGetImageFromCache(url: URL) -> UIImage? {
        if let image = images.object(forKey: url.urlToHash as NSString) {
            return image
        }
        
        if let image = getImageFromFileSystem(url: url) {
            images.setObject(image, forKey: url.urlToHash as NSString)
            return image
        }
        return nil
    }
    
    func loadImage(imageUrl: URL, callback: @escaping (UIImage?, Error?) -> Void) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: imageUrl) { [weak self] (data, response, error) in
            guard let data = data else {
                callback(nil, error)
                return
            }
            
            if let image = UIImage(data: data) {
                self?.writeImageToFileSystem(image: image, imageUrl: imageUrl)
                self?.images.setObject(image, forKey: imageUrl.urlToHash as NSString)
                callback(image, nil)
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
            let imageSavePath = getDicImagePath(urlImage: imageUrl.urlToHash).path
            
            fileSystem.createFile(atPath: imageSavePath, contents: imageData, attributes: nil)
        }
    }
    
    private func getImageFromFileSystem(url: URL) -> UIImage? {
        
        if let data = fileSystem.contents(atPath: getDicImagePath(urlImage: url.urlToHash).path) {
            let image = UIImage(data: data)
            return image
        }
        
        return nil
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
        return docsDir.appendingPathComponent(Constants.dicName)
    }

    private func getDicImagePath(urlImage: String) -> URL {
        return cacheFolder().appendingPathComponent(urlImage)
    }
}

extension URL {
    
    var urlToHash : String {
        return self.path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
}

