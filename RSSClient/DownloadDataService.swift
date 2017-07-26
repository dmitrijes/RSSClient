//
//  File.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 10.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation


class DownloadDataService {
    
    func downloadData(url: String, complition: @escaping ([Posts]?, Error?) -> Void) {
        
        let newUrl = URL(string: url)
        let urlReq = URLRequest(url: newUrl!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlReq) { (data, _, error) in
            guard let newData = data else {
                complition(nil, error)
                return
                }
                let posts = DataParse().parsingDataStart(newData)
            complition(posts, nil)
        }
        task.resume()
    }
}


