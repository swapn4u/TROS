//
//  CoreDataManager.swift
//  CoreDataDemo
//
//  Created by webwerks on 19/12/17.
//  Copyright © 2017 webwerks. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
     static let manager = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let fetchCartRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "CartData")
    let orderDataRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "OrderData")
    
    func saveData(recordDict:ProductList,completion:(Bool)->Void)
    {
        let cartDataContext = NSEntityDescription.entity(forEntityName: "CartData", in: context!)
        guard let managerData = NSManagedObject.init(entity: cartDataContext!, insertInto: context!) as? CartData else {return}
            managerData.name = recordDict.name
            managerData.id = recordDict.id
            managerData.unit = recordDict.unit
            managerData.quantity = "\(recordDict.quantity)"
            managerData.imageUrl = recordDict.imageUrl
            managerData.brand = recordDict.brand
            managerData.cost = "\(recordDict.cost)"
            managerData.imageWidth = "\(recordDict.imageWidth)"
            managerData.imageHeight = "\(recordDict.imageHeight)"
            managerData.discriptions = recordDict.description
       
        do {
            try context?.save()
            completion(true)
        } catch let err {
            print(err)
            completion(false)
        }
    }
    func saveOrderId(orderId:String,complation:@escaping(Bool)->Void)
    {
        let orderDataContext = NSEntityDescription.entity(forEntityName: "OrderData", in: context!)
        guard let managerData = NSManagedObject.init(entity: orderDataContext!, insertInto: context!) as? OrderData else {return}
        managerData.orderId = orderId
        
        do {
            try context?.save()
            complation(true)
        } catch let err {
            print(err)
            complation(false)
        }
    }
    func fetchOrderId()->[OrderData]?
    {
        do {
            let orderIdData = (try context!.fetch(orderDataRequest) as? [OrderData])
            return orderIdData
        } catch let err {
            print(err.localizedDescription)
        }
        return [OrderData]()
    }
    
    func fetch() -> [CartData]? {
         do {
            let cartData = (try context!.fetch(fetchCartRequest) as? [CartData])
            return cartData
         } catch let err {
            print(err.localizedDescription)
        }
       return [CartData]()
    }
    
    func deleteOrderId(id:String,completion:@escaping(Bool)->Void)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderData")
        let predicate = NSPredicate(format: "orderId == %@",id)
        fetchRequest.predicate = predicate
        
        let result = try? context!.fetch(fetchRequest)
        let resultData = result as! [OrderData]
        
        for object in resultData {
            context?.delete(object)
        }
        
        do {
            try context?.save()
            print("saved!")
            completion(true)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            completion(false)
        }
    }
    func deleteProductFromCart(id:String,completion:@escaping(Bool)->Void)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartData")
        let predicate = NSPredicate(format: "id == %@",id)
        fetchRequest.predicate = predicate
        
        let result = try? context!.fetch(fetchRequest)
        let resultData = result as! [CartData]
        
        for object in resultData {
            context?.delete(object)
        }
        
        do {
            try context?.save()
            print("saved!")
            completion(true)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            completion(false)
        }
    }
    func deleteAllProductFromCart(completed:@escaping(Bool)->Void)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartData")
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            let result = try context?.execute(request)
            completed(true)
        } catch (let error)
        {
            completed(true)
            print(error.localizedDescription)
        }
    }

    
}
