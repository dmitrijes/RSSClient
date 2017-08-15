//
//  PostView.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 06.06.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit



class PostsView: UIView, UITableViewDataSource, UITableViewDelegate, PostViewDataReload {

    @IBOutlet weak var tableForDisplayData: UITableView! {
        didSet {
            tableForDisplayData.addSubview(refreshControl)
        }
    }
    

    @IBOutlet weak var dataSource : PostViewDataSource!
    
    private struct Constants {
        static let cellId = "postCell"
    }
    
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    
    //MARK: -> Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! PostViewCell
        
        cell.postTitle.text = dataSource.getTitle(indexAt: indexPath)
//        cell.postDate.text = dataSource.getDate(indexAt: indexPath)
//        cell.postDescrip.text = dataSource.getDescrip(indexAt: indexPath)
//        cell.postImage.image = dataSource.getImage(indexAt: indexPath) ?? #imageLiteral(resourceName: "imagePlaceHolder")
    
        return cell
    }
    
    func reloadTable() {
        tableForDisplayData.reloadData()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
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
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        dataSource.checkUpdateData()
    }
    
}

@objc
protocol PostViewDataSource {
    
    var count: Int { get }
    func getTitle(indexAt: IndexPath) -> String
//    func getImage(indexAt: IndexPath) -> UIImage?
//    func getDate(indexAt: IndexPath) -> String
//    func getDescrip(indexAt: IndexPath) -> String
    func passIndexSelectedCell(index: Int)
    func checkUpdateData()
    
}

protocol PostViewDataReload: class {
    func reloadTable()
    func updateImageCell(number: Int, image: UIImage)
}
