//
//  File.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 10.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation


class DownloadDataService {
    
    func downloadData(url: String, complition: @escaping (Data?, Any?, Error?) -> Void) {
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async {
            guard let newUrl = URL(string: url) else {
                print("Can't URL")
                return
            }
            let urlReq = URLRequest(url: newUrl)
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlReq) { (data, response, error) in
                guard let newData = data else {
                    complition(nil, nil, error)
                    return
                }
                complition(newData, nil, nil)
                return
            }
            task.resume()
            
        }
    }
    
}
