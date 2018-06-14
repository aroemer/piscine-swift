//
//  Article+CoreDataProperties.swift
//  aroemer2018
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
    @NSManaged public var creation_date: NSDate?
    @NSManaged public var modification_date: NSDate?
    @NSManaged public var language: String?
    @NSManaged public var image: NSData?
    
    public override var description: String {
        return("\(String(describing: title)): \n \(String(describing: content)) \n \(String(describing: language)) \n \(String(describing: creation_date)) \n")
    }

}
