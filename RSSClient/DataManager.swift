//
//  DataManager.swift
//  RSSClient
//
//  Created by Дмитрий on 09.08.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation

class DataManager {
    
    fileprivate struct Constants {
        static let macRumosUrl = "http://feeds.macrumors.com/MacRumors-All"
        static let cantGetData = "Can't get data"
    }
    
    func startDownloadData() {
        DownloadDataService().downloadData(url: Constants.macRumosUrl) { (isTrue, error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
}
