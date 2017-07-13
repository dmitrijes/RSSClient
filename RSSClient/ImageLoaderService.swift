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
    
    let fileSystem = FileManager.default
    
    let dicName = "ImagesForTable"
    
    func tryGetImageFromCache(url: URL) -> UIImage? {
        if let image = images[url] {
            return image
        }
        
        if let image = getImageFromFileSystem(url: url) {
            images[url] = image
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
            
            if let image = UIImage(data: data) {
                self.writeImageToFileSystem(image: image, imageUrl: imageUrl)
                self.images[imageUrl] = image
                callback(image, nil, nil)
            }
        }
        task.resume()
    }
    
    private func writeImageToFileSystem(image: UIImage?, imageUrl: URL) {
        
        if let imageExist = image {
            let docsDir = getDocumentDir()
            let newDir = docsDir.appendingPathComponent(dicName).path
        
            if !fileSystem.fileExists(atPath: newDir) {
                createNewDir(path: newDir)
            }
            
            let imageData = UIImagePNGRepresentation(imageExist)
            let hashImageName = urlToHash(url: imageUrl)
            let imageSavePath = getDicImagePath(urlDic: docsDir, urlImage: hashImageName).path
            
            fileSystem.createFile(atPath: imageSavePath, contents: imageData, attributes: nil)
        }
    }
    
    private func getImageFromFileSystem(url: URL) -> UIImage? {
        
        let docsDir = getDocumentDir()
        
        let hashImageName = urlToHash(url: url)
        
        if let data = fileSystem.contents(atPath: getDicImagePath(urlDic: docsDir, urlImage: hashImageName).path) {
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
    
    private func getDicImagePath(urlDic: URL, urlImage: String) -> URL {
        return urlDic.appendingPathComponent(dicName).appendingPathComponent(urlImage)
    }
    
    
}
