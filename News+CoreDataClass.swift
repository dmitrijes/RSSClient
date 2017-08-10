//
//  News+CoreDataClass.swift
//  RSSClient
//
//  Created by Дмитрий on 10.08.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation
import CoreData

@objc(News)
public class News: NSManagedObject {

    convenience init() {
        let entity = NSEntityDescription.entity(forEntityName: "News", in: CoreDataManager.instance.managedObjectPrivateContext)
        
        // Создание нового объекта
        self.init(entity: entity!, insertInto: CoreDataManager.instance.managedObjectPrivateContext)
    }
    
    
}
