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
        let userId = CommonUtlity.sharedInstance.getUserId()
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
            managerData.userID = userId
       
        do {
            try context?.save()
            completion(true)
        } catch let err {
            print(err)
            completion(false)
        }
    }
    func isProductAddedInCart(productId:String) -> Bool
    {
        let userId = CommonUtlity.sharedInstance.getUserId()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartData")
        let predicate = NSPredicate(format: "id == %@ && userID == %@",productId,userId)
        fetchRequest.predicate = predicate
        
        let result = try? context!.fetch(fetchRequest).count > 0
        return result!
    }
    func deleteProductFromCart(id:String,completion:@escaping(Bool)->Void)
    {
        let userId = CommonUtlity.sharedInstance.getUserId()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartData")
        let predicate = NSPredicate(format: "id == %@ && userID == %@",id,userId)
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
        let userId = CommonUtlity.sharedInstance.getUserId()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartData")
        let predicate = NSPredicate(format: "userID == %@",userId)
        fetchRequest.predicate = predicate
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            let _ = try context?.execute(request)
            completed(true)
        } catch (let error)
        {
            completed(true)
            print(error.localizedDescription)
        }
    }
    
    func saveOrderId(orderId:String,complation:@escaping(Bool)->Void)
    {
        let userId = CommonUtlity.sharedInstance.getUserId()
        let orderDataContext = NSEntityDescription.entity(forEntityName: "OrderData", in: context!)
        guard let managerData = NSManagedObject.init(entity: orderDataContext!, insertInto: context!) as? OrderData else {return}
        managerData.orderId = orderId
        managerData.userId = userId
        
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
        let userId = CommonUtlity.sharedInstance.getUserId()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderData")
        let predicate = NSPredicate(format: "userId == %@",userId)
        fetchRequest.predicate = predicate
        
        do {
            let orderIdData = (try context!.fetch(fetchRequest) as? [OrderData])
            return orderIdData
        } catch let err {
            print(err.localizedDescription)
        }
        return [OrderData]()
    }
    
    func fetch() -> [CartData]?
    {
        let userId = CommonUtlity.sharedInstance.getUserId()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartData")
        let predicate = NSPredicate(format: "userID == %@",userId)
        fetchRequest.predicate = predicate
        
        do {
            let cartData = (try context!.fetch(fetchRequest) as? [CartData])
            return cartData
        } catch let err {
            print(err.localizedDescription)
        }
        return [CartData]()
    }
    
    func deleteOrderId(id:String,completion:@escaping(Bool)->Void)
    {
        let userId = CommonUtlity.sharedInstance.getUserId()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderData")
        let predicate = NSPredicate(format: "orderId == %@ && userID == %@",id,userId)
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
    func deleteAllOrderIds(completed:@escaping(Bool)->Void)
    {
        let userId = CommonUtlity.sharedInstance.getUserId()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderData")
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            let _ = try context?.execute(request)
            completed(true)
        } catch (let error)
        {
            completed(true)
            print(error.localizedDescription)
        }
    }
    func saveAddressInfo(addressInfo:SavedAddresses,completed:@escaping(Bool)->Void)
    {
        let userId = CommonUtlity.sharedInstance.getUserId()
        let cartDataContext = NSEntityDescription.entity(forEntityName: "SavedAddress", in: context!)
        guard let managerData = NSManagedObject.init(entity: cartDataContext!, insertInto: context!) as? SavedAddress else {return}
        managerData.name = addressInfo.name
        managerData.address = addressInfo.address
        managerData.contactNumber = addressInfo.contactNo
        managerData.userID = userId
        
        do {
            try context?.save()
            completed(true)
        } catch let err {
            print(err)
            completed(false)
        }
    }
    func getSavedAddresses()-> [SavedAddress]
    {
        let userId = CommonUtlity.sharedInstance.getUserId()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedAddress")
        let predicate = NSPredicate(format: "userId == %@",userId)
        fetchRequest.predicate = predicate
        do {
            let savedAddData = (try context!.fetch(fetchRequest) as! [SavedAddress])
            return savedAddData
        } catch let err {
            print(err.localizedDescription)
        }
        return [SavedAddress]()
    }
    func deleteAddress(_ address : String,completed:@escaping (Bool)->Void)
    {
        let userId = CommonUtlity.sharedInstance.getUserId()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedAddress")
        let predicate = NSPredicate(format: "address == %@ && userID == %@",address,userId)
        fetchRequest.predicate = predicate
        let result = try? context!.fetch(fetchRequest)
        let resultData = result as! [SavedAddress]
        
        for object in resultData {
            context?.delete(object)
        }
        do {
            try context?.save()
            print("saved!")
            completed(true)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            completed(false)
        }
    }
}
