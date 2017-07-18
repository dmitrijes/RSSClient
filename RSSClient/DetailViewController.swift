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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let title = cell.postTitle.text {
            name.text = title
        }
        if let posted = cell.postDate.text {
            date.text = posted
        }
        if let pic = cell.postImage.image {
            image.image = pic
        }
        if let disc = cell.postDescrip.text {
            text.text = disc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
