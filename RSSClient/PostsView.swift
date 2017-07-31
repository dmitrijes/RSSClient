//
//  PostView.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 06.06.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit



class PostsView: UIView, UITableViewDataSource, UITableViewDelegate, PostViewDataReload {

    @IBOutlet weak var tableForDisplayData: UITableView!
    

    @IBOutlet weak var dataSource : PostViewDataSource!
    
    private struct Constants {
        static let cellId = "postCell"
    }
    
    //MARK: -> Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! PostViewCell
        
        cell.postTitle.text = dataSource.getTitle(number: indexPath.row)
        cell.postDate.text = dataSource.getDate(number: indexPath.row)
        cell.postDescrip.text = dataSource.getDescrip(number: indexPath.row)
        cell.postImage.image = dataSource.getImage(number: indexPath.row) ?? #imageLiteral(resourceName: "imagePlaceHolder")
    
        return cell
    }
    
    func reloadTable() {
        tableForDisplayData.reloadData()
    }
    
    func updateImageCell(number: Int, image: UIImage) {
        let indexPath = IndexPath(row: number, section: 0)
        if let cell = tableForDisplayData.cellForRow(at: indexPath) as? PostViewCell {
            cell.postImage.image = image
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.passIndexSelectedCell(index: indexPath.row)
    }
    
}

@objc
protocol PostViewDataSource {
    
    var count: Int { get }
    func getTitle(number: Int) -> String
    func getImage(number: Int) -> UIImage?
    func getDate(number: Int) -> String
    func getDescrip(number: Int) -> String
    func passIndexSelectedCell(index: Int)
    
}

protocol PostViewDataReload: class {
    func reloadTable()
    func updateImageCell(number: Int, image: UIImage)
}
