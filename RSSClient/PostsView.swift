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
        dataSource.getImage(number: indexPath.row)
    
        return cell
    }
    
    func reloadTable() {
        tableForDisplayData.reloadData()
    }
    
    func updateImageCell(number: Int, image: UIImage) {
        let indexPath = IndexPath(row: number, section: 0)
        let cell = tableForDisplayData.cellForRow(at: indexPath) as! PostViewCell
        cell.postImage.image = image
    }
    
    
}

@objc
protocol PostViewDataSource {
    
    var count: Int { get }
    func getTitle(number: Int) -> String
    func getImage(number: Int)
    func getDate(number: Int) -> String
    func getDescrip(number: Int) -> String
    
}

protocol PostViewDataReload {
    func reloadTable()
    func updateImageCell(number: Int, image: UIImage)
}
