//
//  ViewController.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 04.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let url = "http://feeds.macrumors.com/MacRumors-All"
    let downloadData = DownloadDataService()
    let parseData = DataParse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadData.downloadData(url: url) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            guard let neWdata = data else {
                print("Can't get data")
                return
            }
            self.parseData.parsingDataStart(neWdata, complition: { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let response = response {
                    print(response)
                    return
                }
                guard let resultData = data else {
                    print("Can't change data")
                    return
                }
            })
        }
    }



}

