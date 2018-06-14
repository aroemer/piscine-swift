//
//  Article+CoreDataProperties.swift
//  
//
//  Created by Audrey ROEMER on 4/5/18.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var language: String?
    @NSManaged public var image: NSData?
    @NSManaged public var creation_date: NSDate?
    @NSManaged public var modification_date: NSDate?
    
    override public var description: String {
        return "(\(title): \(content) created at \(creation_date)"
    }

}
