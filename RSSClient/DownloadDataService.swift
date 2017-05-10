//
//  File.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 10.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation


class DownloadDataService {
    
    let url = "http://feeds.macrumors.com/MacRumors-All"
    let dataParse = DataParse()
    
    
    func downloadData() {
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async {
            guard let newUrl = URL(string: self.url) else {
                print("Can't URL")
                return
            }
            let urlReq = URLRequest(url: newUrl)
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlReq) { (data, response, error) in
                guard let newData = data else {
                    print("DATA DOES EXIST")
                    return
                }
                self.dataParse.parsingDataStart(newData)
                
            }
            task.resume()
        }
    }
    
}
