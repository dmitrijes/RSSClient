//
//  ViewController.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 04.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    let imageLoader = ImageLoaderService()
    
    var data : [Posts]! {
        didSet {
             delegate.reloadTable()
        }
    }
    
    var delegate : PostViewDataReload {
        return view as! PostViewDataReload
    }
    
    fileprivate struct Constants {
        static let macRumosUrl = "http://feeds.macrumors.com/MacRumors-All"
        static let segueId = "showDetail"
        static let cantGetData = "Can't get data"
        static let internetConnection = "No Internet Connection"
    }
    
    var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        
        _ = reachability?.startNotifier()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkReachability()
    }
    
    func checkReachability() {
        guard let r = reachability else { return }
        if r.isReachable  {
            if data == nil {
                startDownloadData()
            }
        } else {
            showAlert(text: Constants.internetConnection)
        }
    }
    
    func reachabilityDidChange(_ notification: Notification) {
        checkReachability()
    }
    
    func startDownloadData() {
        DownloadDataService().downloadData(url: Constants.macRumosUrl) { [weak self] (posts, error) in
            if let error = error {
                print(error)
                return
            }
            guard let result = posts else {
                self?.showAlert(text: Constants.cantGetData)
                return
            }
            DispatchQueue.main.async {
                self?.data = result
            }
        }
    }
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "Sorry", message: text, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueId {
            let showDetail = segue.destination as! DetailViewController
            showDetail.post = data?[sender as! Int]
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }
    
}

extension PostViewController: PostViewDataSource {
    
    var count: Int {
        return data?.count ?? 0
    }
    
    func getTitle(number: Int) -> String {
        return data?[number].postTitle ?? ""
    }
    
    func getImage(number: Int) -> UIImage? {
        if let urlString = data?[number].postImage, let imageUrl = URL(string: urlString) {
            if let image = imageLoader.tryGetImageFromCache(url: imageUrl) {
                return image
            }
            imageLoad(imageUrl: imageUrl, number: number)
            
        }
        return nil
    }
    
    func imageLoad(imageUrl: URL, number: Int) {
        imageLoader.loadImage(imageUrl: imageUrl, callback: { [weak self] (result, error) in
            guard let image = result else {
                return
            }
            DispatchQueue.main.async {
                self?.delegate.updateImageCell(number: number, image: image)
            }
        })
    }
    
    func getDate(number: Int) -> String {
        return RegularPostChange().getDatePost(date: data?[number].postDate ?? "")
    }
    
    func getDescrip(number: Int) -> String {
        return data?[number].postDescrip ?? ""
    }
    
    func passIndexSelectedCell(index: Int) {
        performSegue(withIdentifier: Constants.segueId, sender: index)
    }
    
    func checkUpdateData() {
        startDownloadData()
    }

}
