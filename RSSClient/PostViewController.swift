//
//  ViewController.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 04.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    let url = "http://feeds.macrumors.com/MacRumors-All"
    let downloadData = DownloadDataService()
    
    var data : [Posts]! {
        didSet {
             self.delegate.reloadTable()
        }
    }
    
    var delegate : PostViewDataReload {
        return view as! PostViewDataReload
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadData.downloadData(url: url) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            guard let result = data else {
                print("Can't get data")
                return
            }
            DispatchQueue.main.async {
                self.data = result
            }
        }
    }
}



extension PostViewController: PostViewDataSource {
    var count: Int {
        return data?.count ?? 0
    }
    func getTitle(number: Int) -> String {
        return data?[number].postTitle ?? ""
    }
    
    func getImage(number: Int, complition: @escaping (UIImage?, Error?) -> Void) {
        var image : UIImage?
        DispatchQueue.global().async {
            let url = URL(string: (self.data?[number].postImage)!)!
            if let imageURL = try? Data(contentsOf: url) {
            image = UIImage(data: imageURL)
            complition(image, nil)
            }
        }
        
    }
    
    func getDate(number: Int) -> String {
        return data?[number].postDate ?? ""
    }
    
    func getDescrip(number: Int) -> String {
        return data?[number].postDescrip ?? ""
    }

}

