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
    
    lazy var fetchedResultsController: NSFetchedResultsController<News> = {
        let fetchRequest = NSFetchRequest<News>(entityName: "News")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectMainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    var delegate : PostViewDataReload {
        return view as! PostViewDataReload
    }
    
    fileprivate struct Constants {
        static let segueId = "showDetail"        
        static let internetConnection = "No Internet Connection"
        static let cantGetData = "Can't get data"
    }
    
    //var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager().startDownloadNews(checkUpdate: false)
        
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error")
        }

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
            showDetail.news = fetchedResultsController.object(at: sender as! IndexPath)
        }
    }
    
    
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//        reachability?.stopNotifier()
//    }
    
}

extension PostViewController: PostViewDataSource {
    
    var count: Int {
        if let result = fetchedResultsController.fetchedObjects {
            return result.count
        }
        return 0
    }
    
    func getTitle(indexAt: IndexPath) -> String {
        return fetchedResultsController.object(at: indexAt).title ?? ""
        
        //return " "
    }
    
    func getImage(indexAt: IndexPath) -> UIImage? {
        if let urlString = fetchedResultsController.object(at: indexAt).imageUrl, let imageUrl = URL(string: urlString) {
            if let image = imageLoader.tryGetImageFromCache(url: imageUrl) {
                return image
            }
            imageLoad(imageUrl: imageUrl, number: indexAt.row)
            
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

    func getDate(indexAt: IndexPath) -> String {
        return DateFormat().getDatePost(date: fetchedResultsController.object(at: indexAt).date!)
    }

    func getDescrip(indexAt: IndexPath) -> String {
        return fetchedResultsController.object(at: indexAt).descrip ?? ""
    }
    
    func passIndexSelectedCell(indexAt: IndexPath) {
        performSegue(withIdentifier: Constants.segueId, sender: indexAt)
    }
    
    func checkUpdateData() {
        DataManager().startDownloadNews(checkUpdate: true)
    }

}

extension PostViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate.reloadTable()
    }
}
