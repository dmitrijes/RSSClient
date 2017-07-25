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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    func reloadData() {
        nameLabel.text = dataSource.getTitle()
        dateLabel.text = dataSource.getDate()
        let imageIsExist = dataSource.getImage()
        if imageIsExist == #imageLiteral(resourceName: "imagePlaceHolder") {
            imageLabel.removeFromSuperview()
        } else {
            imageLabel.image = imageIsExist
        }
        descriptionTextView.text = dataSource.getText()
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
