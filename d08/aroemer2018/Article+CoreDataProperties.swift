//
//  Toto+CoreDataProperties.swift
//  aroemer2018
//
//  Created by Audrey ROEMER on 4/5/18.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Toto>(entityName: "article")
    }

    @NSManaged public var article: String?
    
    override var description: String {
        return ""
    }

}
