//
//  ViewController.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 04.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    let url = "http://feeds.macrumors.com/MacRumors-All"
    let downloadData = DownloadDataService()
    let imageLoader = ImageLoaderService()
    
    var data : [Posts]! {
        didSet {
             self.delegate.reloadTable()
        }
    }
    
    var delegate : PostViewDataReload {
        return view as! PostViewDataReload
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDownloadData()
        
    }
    
    func startDownloadData() {
        downloadData.downloadData(url: url) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            guard let result = data else {
                print("Can't get data")
                return
            }
            DispatchQueue.main.async {
                self.data = result
            }
        }
    }
}

extension PostViewController: PostViewDataSource {
    var count: Int {
        return data?.count ?? 0
    }
    func getTitle(number: Int) -> String {
        return data?[number].postTitle ?? ""
    }
    
    func getImage(number: Int) -> UIImage? {
        if let imageUrl = URL(string: (data?[number].postImage)!) {
            let image = imageLoader.tryGetImageFromCache(url: imageUrl)
            if image == nil {
                imageLoader.loadImage(imageUrl: imageUrl, callback: { (result, response, error) in
                    guard let image = result else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.delegate.updateImageCell(number: number, image: image)
                    }
                })
            } else {
                return image
            }
        }
        return nil
        
    }
    
    func getDate(number: Int) -> String {
        return data?[number].postDate ?? ""
    }
    
    func getDescrip(number: Int) -> String {
        return data?[number].postDescrip ?? ""
    }

}

