//
//  CoreDataStack.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import UIKit
import Foundation
import CoreData

let kDbName = "WatchMovie.sqlite"
let kResourceName = "WatchMovie"
let kExtension = "momd"

typealias SaveCompletionHandler = (Bool, NSError?)->()
typealias DeleteCompletionHandler = (Bool, NSError?)->()
typealias BatchCompletionHandler = (Bool, NSError?)->()
typealias FetchCompletionHandler = ([NSManagedObject]?, Error?) -> ()

class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()
    
    private override init() {}
    
    func privateManagedObjectContext() -> NSManagedObjectContext? {
        guard let parentContext = self.mainManagedObjectContext else{
            return nil;
        }
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = parentContext;
        privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return privateContext
    }
    
    func batchRequestManagedObjectContext() -> NSManagedObjectContext? {
        guard let coordinator = self.persistentBatchStoreCoordinator else{
            return nil
        }
        let batchContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        batchContext.persistentStoreCoordinator = coordinator
        batchContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return batchContext
    }
    
    private lazy var applicationDocumentsDirectory:URL? = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    private lazy var managedObjectModel:NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: kResourceName, withExtension: kExtension)
        return NSManagedObjectModel(contentsOf: modelUrl!)!;
    }()
    
    private lazy var persistentStoreCoordinator:NSPersistentStoreCoordinator? = {
        let storeUrl = self.applicationDocumentsDirectory?.appendingPathComponent(kDbName);
        
        var storeCoordinator : NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try storeCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption: true])
            
        } catch {
            exit(1);
        }
        return storeCoordinator;
    }()
    
    private lazy var persistentBatchStoreCoordinator:NSPersistentStoreCoordinator? = {
        let storeUrl = self.applicationDocumentsDirectory?.appendingPathComponent(kDbName);
        
        var storeCoordinator : NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try storeCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption: true])
            
        } catch {
            exit(1);
        }
        return storeCoordinator;
    }()
    
    private lazy var mainManagedObjectContext:NSManagedObjectContext? = {
        
        guard let parentContext = self.masterManagedObjectContext else {
            return nil;
        }
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = parentContext;
        mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return mainContext
    }()
    
    fileprivate lazy var masterManagedObjectContext:NSManagedObjectContext? = {
        guard let coordinator = self.persistentStoreCoordinator else{
            return nil
        }
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = coordinator
        masterContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return masterContext
    }()
    
    class func fetchRequest(entityName: String) -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    }
    
    class func batchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> NSBatchDeleteRequest {
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
    
    class func batchUpdateRequest(entityName: String) -> NSBatchUpdateRequest {
        return NSBatchUpdateRequest(entityName: entityName)
    }
    
    @available(iOS 13.0, *)
    class func batchInsertRequest(entityName: String, objects dictionaries: [[String : Any]]) -> NSBatchInsertRequest {
        return NSBatchInsertRequest(entityName: entityName, objects: dictionaries)
    }
    
    class func insertNewManagedObject(forEntityName entityName:String, inManagedObjectContext managedObjectContext:NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
    }
    
    func saveDataAsynchronusly(inManagedObjectContext managedObjectContext:NSManagedObjectContext, withCompletionHandler completionHandler: @escaping SaveCompletionHandler) -> Void {
        
        managedObjectContext.saveAsyncRecusively(withCompletionBlock: { (success, error) in
            completionHandler(success,error)
        })
    }
    
    func saveDataSynchronusly(inManagedObjectContext managedObjectContext:NSManagedObjectContext, withCompletionHandler completionHandler:@escaping SaveCompletionHandler) -> Void{
        
        managedObjectContext.saveSyncRecusively(withCompletionBlock: { (success, error) in
            completionHandler(success,error)
        })
    }
    
    func deleteDataAsynchronusly(managedObject: NSManagedObject,inManagedObjectContext managedObjectContext:NSManagedObjectContext, withCompletionHandler completionHandler: @escaping DeleteCompletionHandler) -> Void {
        
        managedObjectContext.deleteAsyncRecusively(managedObject: managedObject, withCompletionBlock: { (success, error) in
            completionHandler(success,error)
        })
    }
    
    func deleteDataSynchronusly(managedObject: NSManagedObject,inManagedObjectContext managedObjectContext:NSManagedObjectContext, withCompletionHandler completionHandler: @escaping DeleteCompletionHandler) -> Void {
        
        managedObjectContext.deleteSyncRecusively(managedObject: managedObject, withCompletionBlock: { (success, error) in
            completionHandler(success,error)
        })
    }
    
    func fetchObjectAsynchronusly(withFetchRequest fetchRequest:NSFetchRequest<NSFetchRequestResult>, withCompletionHandler completionHandler: @escaping  FetchCompletionHandler) -> Void{
        
        self.mainManagedObjectContext?.perform({
            var fetchedObjects:[NSManagedObject]? = nil
            var error:NSError? = nil
            do{
                try fetchedObjects = self.mainManagedObjectContext?.fetch(fetchRequest) as? [NSManagedObject]
            }catch let fetchError as NSError{
                error = fetchError
            }
            completionHandler(fetchedObjects,error)
        })
    }
    
    func fetchObjectSynchronusly(withFetchRequest fetchRequest:NSFetchRequest<NSFetchRequestResult>, withCompletionHandler completionHandler: FetchCompletionHandler) -> Void{
        
        self.mainManagedObjectContext?.performAndWait({
            var fetchedObjects:[NSManagedObject]? = nil
            var error:NSError? = nil
            do{
                try fetchedObjects = self.mainManagedObjectContext?.fetch(fetchRequest) as? [NSManagedObject]
            }catch let fetchError as NSError{
                error = fetchError
            }
            completionHandler(fetchedObjects,error)
        })
    }
    
    func executeBatchUpdateSynchronusly(request: NSBatchUpdateRequest, managedObjectContext:NSManagedObjectContext, withCompletionHandler completionHandler: BatchCompletionHandler) -> Void {
        managedObjectContext.performAndWait {
            var error: NSError?
            var success: Bool = false
            do {
                let result = try managedObjectContext.execute(request) as? NSBatchUpdateResult
                if let objectIDArray = result?.result as? [NSManagedObjectID] {
                    let changes = [NSUpdatedObjectsKey:objectIDArray]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [managedObjectContext])
                    objectIDArray.forEach({ (objectID) in
                        let managedObject = managedObjectContext.object(with: objectID)
                        if managedObject.isFault == false {
                            managedObjectContext.refresh(managedObject, mergeChanges: true)
                        }
                    })
                }
                success = true
            } catch let batchError as NSError {
                error = batchError
            }
            completionHandler(success,error)
        }
    }
    
    func executeBatchUpdateAsynchronusly(request: NSBatchUpdateRequest, managedObjectContext:NSManagedObjectContext, withCompletionHandler completionHandler: @escaping BatchCompletionHandler) -> Void {
        managedObjectContext.perform {
            var error: NSError?
            var success: Bool = false
            do {
                let result = try managedObjectContext.execute(request) as? NSBatchUpdateResult
                if let objectIDArray = result?.result as? [NSManagedObjectID] {
                    let changes = [NSUpdatedObjectsKey:objectIDArray]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [managedObjectContext])
                    objectIDArray.forEach({ (objectID) in
                        let managedObject = managedObjectContext.object(with: objectID)
                        if managedObject.isFault == false {
                            managedObjectContext.refresh(managedObject, mergeChanges: true)
                        }
                    })
                }
                success = true
            } catch let batchError as NSError {
                error = batchError
            }
            completionHandler(success,error)
        }
    }
    
    func executeBatchDeleteSynchronusly(request: NSBatchDeleteRequest, managedObjectContext:NSManagedObjectContext, withCompletionHandler completionHandler: BatchCompletionHandler) -> Void {
        managedObjectContext.performAndWait {
            var error: NSError?
            var success: Bool = false
            do {
                let result = try managedObjectContext.execute(request) as? NSBatchDeleteResult
                if let objectIDArray = result?.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey:objectIDArray]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [managedObjectContext])
                }
                success = true
            } catch let batchError as NSError {
                error = batchError
            }
            completionHandler(success,error)
        }
    }
    
    func executeBatchDeleteAsynchronusly(request: NSBatchDeleteRequest, managedObjectContext:NSManagedObjectContext, withCompletionHandler completionHandler: @escaping BatchCompletionHandler) -> Void {
        managedObjectContext.perform {
            var error: NSError?
            var success: Bool = false
            do {
                let result = try managedObjectContext.execute(request) as? NSBatchDeleteResult
                if let objectIDArray = result?.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey:objectIDArray]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [managedObjectContext])
                }
                success = true
            } catch let batchError as NSError {
                error = batchError
            }
            completionHandler(success,error)
        }
    }
    
    class func convertToJSONArray(managedObjects: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in managedObjects {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
}
