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
    }
    
    func startDownloadNews(checkUpdate: Bool) {
        if !checkUpdate {
            let moreThanAnHour = lastDownloadTimeDiff()
            if moreThanAnHour {
                start()
            }
        } else {
            start()
        }
    }
    
    func start() {
        DownloadDataService().downloadNews(url: Constants.macRumosUrl) { (isTrue, error) in
            if let error = error {
                print(error)
                return
            }
            UserDefaults.standard.set(DateFormat().currentDate, forKey: "lastUpdate")
        }
    }
    
    func lastDownloadTimeDiff() -> Bool {
        if let lastUpdate = UserDefaults.standard.object(forKey: "lastUpdate") as? Date {
            let lastUpdateInterval = lastUpdate.timeIntervalSince1970
            let currentInterval2 = DateFormat().currentDate.timeIntervalSince1970
            let diff = (currentInterval2 - lastUpdateInterval)/60
            if diff > 60 {
                return true
            }
        }
        return false
    }
}
