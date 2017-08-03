//
//  DetailViewController.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 17.07.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var delegate : DetailViewDataReload {
        return view as! DetailViewDataReload
    }
    
    var post : Posts! {
        didSet {
            delegate.reloadData()
        }
    }

}

extension DetailViewController: DetailViewDataSource {
    
    func getTitle() -> String {
        return post.postTitle ?? ""
    }
    
    func getDate() -> String {
        return DateFormat().getDatePost(date: post.postDate ?? "")
    }
    
    func getImage() -> UIImage? {
        let imageUrl = URL(string: post.postImage)
        return ImageLoaderService().tryGetImageFromCache(url: imageUrl!)
    }
    
    func getText() -> String {
        return post.postDescrip ?? ""
    }
    
}
