//
//  SavedAddress+CoreDataProperties.swift
//  
//
//  Created by Swapnil Katkar on 10/11/18.
//
//

import Foundation
import CoreData


extension SavedAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedAddress> {
        return NSFetchRequest<SavedAddress>(entityName: "SavedAddress")
    }

    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var contactNumber: String?
    @NSManaged public var userID: String?

}
