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
    
    var cell : PostViewCell! {
        didSet {
            delegate.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
    }

}

extension DetailViewController: DetailViewDataSource {
    
    func getTitle() -> String {
        return cell.postTitle.text ?? ""
    }
    
    func getDate() -> String {
        return cell.postDate.text ?? ""
    }
    
    func getImage() -> UIImage? {
        return cell.postImage.image ?? #imageLiteral(resourceName: "imagePlaceHolder")
    }
    
    func getText() -> String {
        return cell.postDescrip.text ?? ""
    }
    
}
