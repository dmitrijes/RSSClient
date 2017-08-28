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
//        if !checkUpdate {
//            let moreThanAnHour = lastDownloadMoreThanAnHour()
//            if moreThanAnHour {
//                start()
//            }
//        } else {
            start()
       // }
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
    
//    func lastDownloadMoreThanAnHour() -> Bool {
//        if let lastUpdate = UserDefaults.standard.object(forKey: "lastUpdate") as? Date {
//            let diff = Calendar.current.dateComponents([.year, .month, .day, .hour], from: lastUpdate, to:currentDate)
//            if diff.hour! > 1 || diff.day! > 1 || diff.month! > 1 || diff.year! > 1 {
//                return true
//            }
//        }
//        return false
//    }
}
