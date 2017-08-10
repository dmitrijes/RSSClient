//
//  ViewController.swift
//  RSSClient
//
//  Created by Dzmitry Fralou on 04.05.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import UIKit
import CoreData

class PostViewController: UIViewController {

    let imageLoader = ImageLoaderService()
    
    var data: [Posts]?
    
    var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        
        return fetchedResultsController
    }()
    
    var delegate : PostViewDataReload {
        return view as! PostViewDataReload
    }
    
    fileprivate struct Constants {
        static let segueId = "showDetail"        
        static let internetConnection = "No Internet Connection"
    }
    
    var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager().startDownloadData()
        let q = fetchedResultsController.fetchedObjects
        

//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
//        
//        _ = reachability?.startNotifier()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        checkReachability()
//    }
//    
//    func checkReachability() {
//        guard let r = reachability else { return }
//        if r.isReachable  {
//            if data == nil {
//                startDownloadData()
//            }
//        } else {
//            showAlert(text: Constants.internetConnection)
//        }
//    }
    
//    func reachabilityDidChange(_ notification: Notification) {
//        checkReachability()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueId {
            let showDetail = segue.destination as! DetailViewController
            showDetail.post = data?[sender as! Int]
        }
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//        reachability?.stopNotifier()
//    }
    
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
        return DateFormat().getDatePost(date: data?[number].postDate ?? "")
    }
    
    func getDescrip(number: Int) -> String {
        return data?[number].postDescrip ?? ""
    }
    
    func passIndexSelectedCell(index: Int) {
        performSegue(withIdentifier: Constants.segueId, sender: index)
    }
    
    func checkUpdateData() {
        DataManager().startDownloadData()
    }

}

extension PostViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("2")
    }
    
}
