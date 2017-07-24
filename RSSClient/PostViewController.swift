//
//  ViewController.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 04.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    let downloadData = DownloadDataService()
    let imageLoader = ImageLoaderService()
    
    var data : [Posts]! {
        didSet {
             delegate.reloadTable()
        }
    }
    
    unowned var delegate : PostViewDataReload {
        return view as! PostViewDataReload
    }
    
    private struct Constants {
        static let macRumosUrl = "http://feeds.macrumors.com/MacRumors-All"
        static let segueId = "showDetail"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDownloadData()
        
    }
    
    func startDownloadData() {
        downloadData.downloadData(url: Constants.macRumosUrl) { [unowned self] (dataV, _, error) in
            if let error = error {
                print(error)
                return
            }
            guard let result = dataV else {
                print("Can't get data")
                return
            }
            DispatchQueue.main.async {
                self.data = result
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueId {
            let cell = sender as! PostViewCell
            let showDetail = segue.destination as! DetailViewController
            showDetail.cell = cell
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
        if let urlString = data?[number].postImage, let imageUrl = URL(string: urlString) {
            if let image = imageLoader.tryGetImageFromCache(url: imageUrl) {
                return image
            }
            imageLoad(imageUrl: imageUrl, number: number)
            
        }
        return nil
    }
    
    func imageLoad(imageUrl: URL, number: Int) {
        imageLoader.loadImage(imageUrl: imageUrl, callback: { [unowned delegate] (result, response, error) in
            guard let image = result else {
                return
            }
            DispatchQueue.main.async {
                delegate.updateImageCell(number: number, image: image)
            }
        })
    }
    
    func getDate(number: Int) -> String {
        return data?[number].postDate ?? ""
    }
    
    func getDescrip(number: Int) -> String {
        return data?[number].postDescrip ?? ""
    }

}
