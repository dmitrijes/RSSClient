//
//  File.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 10.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation


class DownloadDataService {
    
    let parseData = DataParse()
    
    func downloadData(url: String, complition: @escaping ([Posts]?, URLResponse?, Error?) -> Void) {
        
            let newUrl = URL(string: url)               
            let urlReq = URLRequest(url: newUrl!)
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlReq) { (data, response, error) in
                guard let newData = data else {
                    complition(nil, nil, error)
                    return
                    }
                    self.parseData.parsingDataStart(newData, complition: { (dataParse, _, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        guard let resultData = dataParse else {
                            print("Can't parse data")
                            return
                        }
                        complition(resultData, nil, nil)
                        return
                    })
            }
            task.resume()
            
        }
    }


