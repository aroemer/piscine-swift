//
//  Test+CoreDataProperties.swift
//  aroemer2018
//
//  Created by Audrey ROEMER on 4/5/18.
//
//

import Foundation
import CoreData


extension Test {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Test> {
        return NSFetchRequest<Test>(entityName: "Test")
    }

    @NSManaged public var name: String?

}
