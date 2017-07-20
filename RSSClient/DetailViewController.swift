//
//  DetailViewController.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 17.07.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UILabel!
    
    
    var cell : PostViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = cell.postTitle.text
        date.text = cell.postDate.text
        image.image = cell.postImage.image
        text.text = cell.postDescrip.text

    }

}
