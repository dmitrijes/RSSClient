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
    
    @IBOutlet weak var dataSource : PostViewDataSource
    
    
    //MARK -> Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        //let post = dataSource.getPost(indexPath.row)
        
        //cell.textLabel?.text = post.postTitle
        
        return cell
    }
    
    func reloadTable() {
        tableForDisplayData.reloadData()
    }
    
}

protocol PostViewDataSource {
    var count: Int { get }
    
}

protocol TableViewDataReload {
    func reloadTable()
}