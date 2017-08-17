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
    
    var news : News! {
        didSet {
            delegate.reloadData()
        }
    }

}

extension DetailViewController: DetailViewDataSource {
    
    func getTitle() -> String {
        return news.title ?? ""
    }
    
    func getDate() -> String {
        return DateFormat().getDatePost(date: news.date!)
    }
    
    func getImage() -> UIImage? {
        let imageUrl = URL(string: news.imageUrl ?? "")
        return ImageLoaderService().tryGetImageFromCache(url: imageUrl!)
    }
    
    func getText() -> String {
        return news.descrip ?? ""
    }
    
}
