//
//  PostView.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 06.06.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit



class PostsView: UIView, UITableViewDataSource, TableViewDataReload {

    @IBOutlet weak var tableForDisplayData: UITableView!
    
    @IBOutlet weak var dataSource : PostViewController!
    
    
    //MARK -> Data
    
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
        let url = dataSource.getImage(number: indexPath.row)
        if let imageURL = try? Data(contentsOf: url) {
            cell.postImage.image = UIImage(data: imageURL)
        }
        
        
        return cell
    }
    
    func reloadTable() {
        tableForDisplayData.reloadData()
    }
    
}

protocol PostViewDataSource {
    var count: Int { get }
    func getTitle(number: Int) -> String
    func getImage(number: Int) -> URL
    func getDate(number: Int) -> String
    func getDescrip(number: Int) -> String
    
}

protocol TableViewDataReload {
    func reloadTable()
}
