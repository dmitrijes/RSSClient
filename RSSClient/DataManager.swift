//
//  DataManager.swift
//  RSSClient
//
//  Created by Дмитрий on 09.08.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    fileprivate struct Constants {
        static let macRumosUrl = "http://feeds.macrumors.com/MacRumors-All"
        static let cantGetData = "Can't get data"
    }
    
    func startDownloadData() {
        DownloadDataService().downloadData(url: Constants.macRumosUrl) { (posts, error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                if let result = posts {
                    for post in result {
                        let news = News()
                        news.title = post.postTitle
                        news.date = post.postDate
                        news.descrip = post.postDescrip
                        news.imageUrl = post.postImage
                        
                        CoreDataManager.instance.saveContext()
                       
                    }
                }
                print("1")
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
                
                do {
                    let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
                    for result in results as! [News] {
                        print("name - \(result.title!)")
                    }
                    
                } catch {
                    let fetchError = error as NSError
                    print(fetchError)
                }
            }
        }
    }
    
//    func showAlert(text: String) {
//        let alert = UIAlertController(title: "Sorry", message: text, preferredStyle: UIAlertControllerStyle.alert)
//        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }

}
