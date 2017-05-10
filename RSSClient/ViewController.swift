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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadData.downloadData()
    }



}

