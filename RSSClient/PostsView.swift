//
//  PostView.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 06.06.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit



class PostsView: UIView, UITableViewDataSource, PostViewDataReload {

    @IBOutlet weak var tableForDisplayData: UITableView!
    

    @IBOutlet var dataSource : PostViewDataSource!
    
    
    //MARK: -> Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostViewCell
        
        cell.postTitle.text = dataSource.getTitle(number: indexPath.row)
        cell.postDate.text = dataSource.getDate(number: indexPath.row)
        cell.postDescrip.text = dataSource.getDescrip(number: indexPath.row)
        loadImageCell(numberAt: indexPath.row) { (data, error) in
            if let error = error {
                print(error)
            }
            guard let data = data else {
                print("qwe")
                return
            }
            DispatchQueue.main.async {
                cell.postImage.image = data
            }
            
        }

        
        return cell
    }
    
    func reloadTable() {
        tableForDisplayData.reloadData()
    }
    
    func loadImageCell(numberAt: Int, complition: @escaping (UIImage?, Error?) -> Void)  {
        dataSource.getImage(number: numberAt) { (data, error) in
            if let error = error {
                print(error)
            }
            guard let image = data else {
                print("qwe")
                return
            }
            complition(image, nil)
        }
    }
    
}

@objc
protocol PostViewDataSource {
    
    var count: Int { get }
    func getTitle(number: Int) -> String
    func getImage(number: Int, complition: @escaping (UIImage?, Error?) -> Void)
    func getDate(number: Int) -> String
    func getDescrip(number: Int) -> String
    
}

protocol PostViewDataReload {
    func reloadTable()
    func loadImageCell(numberAt: Int, complition: @escaping (UIImage?, Error?) -> Void)
}
