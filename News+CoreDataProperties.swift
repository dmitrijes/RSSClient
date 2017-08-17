//
//  News+CoreDataProperties.swift
//  RSSClient
//
//  Created by Дмитрий on 10.08.17.
//  Copyright © 2017 Dzmitry Fralou. All rights reserved.
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var date: Date?
    @NSManaged public var descrip: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?

}
