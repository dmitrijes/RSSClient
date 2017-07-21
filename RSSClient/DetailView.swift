//
//  DetailView.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 21.07.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit

class DetailView: UIView, DetailViewDataReload {
    
    @IBOutlet var dataSource : DetailViewDataSource!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UILabel!
    
    func reloadData() {
        name.text = dataSource.getTitle()
        date.text = dataSource.getDate()
        let imageIsExist = dataSource.getImage()
        if imageIsExist == #imageLiteral(resourceName: "imagePlaceHolder") {
            image.removeFromSuperview()
        } else {
            image.image = imageIsExist
        }
        text.text = dataSource.getText()
    }

}


@objc
protocol DetailViewDataSource {
    
    func getTitle() -> String
    func getDate() -> String
    func getImage() -> UIImage?
    func getText() -> String
    
}

protocol DetailViewDataReload {
    
    func reloadData()
    
}
