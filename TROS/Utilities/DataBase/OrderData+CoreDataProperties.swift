//
//  OrderData+CoreDataProperties.swift
//  
//
//  Created by Swapnil Katkar on 31/10/18.
//
//

import Foundation
import CoreData


extension OrderData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderData> {
        return NSFetchRequest<OrderData>(entityName: "OrderData")
    }

    @NSManaged public var orderId: String?

}
