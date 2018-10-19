//
//  CartData+CoreDataProperties.swift
//  
//
//  Created by Swapnil Katkar on 18/10/18.
//
//

import Foundation
import CoreData


extension CartData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartData> {
        return NSFetchRequest<CartData>(entityName: "CartData")
    }

    @NSManaged public var id: String?
    @NSManaged public var brand: String?
    @NSManaged public var cost: String?
    @NSManaged public var discriptions: String?
    @NSManaged public var imageHeight: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var imageWidth: String?
    @NSManaged public var name: String?
    @NSManaged public var quantity: String?
    @NSManaged public var unit: String?

}
