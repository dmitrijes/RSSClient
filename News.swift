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

    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "News", in: context)
        
        // Создание нового объекта
        self.init(entity: entity!, insertInto: context)
        
    }
    
    
    
}
