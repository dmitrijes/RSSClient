//
//  ViewController.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 04.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let downloadData = DownloadDataService()
    let url = "http://feeds.macrumors.com/MacRumors-All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadData.downloadData(url: url) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            guard let newdata = data else {
                print("Can't get data")
                return
            }
            print(newdata)
        }
    }



}

