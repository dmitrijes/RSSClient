//
//  File.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 10.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation
import CoreData


class DownloadDataService {
    
    func downloadNews(url: String, complition: @escaping (Bool, Error?) -> Void) {
        
        let newUrl = URL(string: url)
        let urlReq = URLRequest(url: newUrl!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlReq) { (data, _, error) in
            guard let newData = data else {
                complition(false, error)
                return
                }
            CoreDataManager.instance.deleteAllObects()
            _ = DataParse().parsingDataStart(newData)
            CoreDataManager.instance.saveContext(context: CoreDataManager.instance.managedObjectPrivateContext)
            complition(true, nil)
            
        }
        task.resume()
    }
}
