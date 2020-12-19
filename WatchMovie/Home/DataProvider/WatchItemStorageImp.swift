//
//  WatchItemStorageImp.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

class WatchItemStorageImp: WatchItemStorage {
    
    func fetchWatchItem(identifier: String, completion: @escaping WatchItemStorageSingleFetchCompletion) {
        let fetchRequest = CoreDataStack.fetchRequest(entityName: "StoredWatchItem")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %@", identifier)
        CoreDataStack.sharedInstance.fetchObjectAsynchronusly(withFetchRequest: fetchRequest) { (managedObjects, error) in
            completion(managedObjects?.first,error)
        }
    }
    
    func fetchAll(with completion: @escaping WatchItemStorageFetchCompletion) {
        let fetchRequest = CoreDataStack.fetchRequest(entityName: "StoredWatchItem")
        CoreDataStack.sharedInstance.fetchObjectAsynchronusly(withFetchRequest: fetchRequest, withCompletionHandler: completion)
    }
    
    func fetchAllFavourite(with completion: @escaping WatchItemStorageFetchCompletion) {
        let fetchRequest = CoreDataStack.fetchRequest(entityName: "StoredWatchItem")
        fetchRequest.predicate = NSPredicate(format: "isFavourite = true")
        CoreDataStack.sharedInstance.fetchObjectAsynchronusly(withFetchRequest: fetchRequest, withCompletionHandler: completion)
    }
    
    func save(item: WatchItem, completion: @escaping WatchItemStorageSaveCompletion) {
        if let privateContext = CoreDataStack.sharedInstance.privateManagedObjectContext() {
            let fetchRequest = CoreDataStack.fetchRequest(entityName: "StoredWatchItem")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id = %d", item.id)
            CoreDataStack.sharedInstance.fetchObjectAsynchronusly(withFetchRequest: fetchRequest) { (managedObjects, error) in
                if let managedObject = managedObjects?.first as? StoredWatchItem{
                    managedObject.id = Int64(item.id)
                    managedObject.title = item.title
                    managedObject.posterImagePath = item.posterPath
                    managedObject.releaseDate = item.releaseDate
                    managedObject.voteCount = Int64(item.voteCount)
                    managedObject.backDropImagePath = item.backdropPath
                    managedObject.originalLanguage = item.originalLanguage
                    managedObject.originalTitle = item.originalTitle
                    managedObject.overview = item.overview
                    managedObject.popularity = item.popularity ?? 0.0
                    managedObject.voteAverage = Int64(item.voteAverage ?? 0)
                    managedObject.isFavourite = item.isFavourite
                    
                    CoreDataStack.sharedInstance.saveDataAsynchronusly(inManagedObjectContext: managedObject.managedObjectContext!) { (success, error) in
                        completion(success,error)
                    }
                }else {
                    if let watchItemMO = CoreDataStack.insertNewManagedObject(forEntityName: "StoredWatchItem", inManagedObjectContext: privateContext) as? StoredWatchItem {
                        watchItemMO.id = Int64(item.id)
                        watchItemMO.title = item.title
                        watchItemMO.posterImagePath = item.posterPath
                        watchItemMO.releaseDate = item.releaseDate
                        watchItemMO.voteCount = Int64(item.voteCount)
                        watchItemMO.backDropImagePath = item.backdropPath
                        watchItemMO.originalLanguage = item.originalLanguage
                        watchItemMO.originalTitle = item.originalTitle
                        watchItemMO.overview = item.overview
                        watchItemMO.popularity = item.popularity ?? 0.0
                        watchItemMO.voteAverage = Int64(item.voteAverage ?? 0)
                        watchItemMO.isFavourite = item.isFavourite
                    }
                    CoreDataStack.sharedInstance.saveDataAsynchronusly(inManagedObjectContext: privateContext) { (success, error) in
                        completion(success,error)
                    }
                }
            }
        }
    }
    
    func save(items: [WatchItem], completion: @escaping WatchItemStorageSaveCompletion) {
        
    }
    
    func delete(item: WatchItem, completion: @escaping WatchItemStorageDeleteCompletion) {
        self.delete(items: [item], completion: completion)
    }
    
    func delete(items: [WatchItem], completion: @escaping WatchItemStorageDeleteCompletion) {
        var itemIds = [String]()
        items.forEach { (item) in
            itemIds.append(String(item.id))
        }
        if let privateContext = CoreDataStack.sharedInstance.privateManagedObjectContext() {
            let fetchRequest = CoreDataStack.fetchRequest(entityName: "StoredWatchItem")
            fetchRequest.predicate = NSPredicate(format: "id IN %@",itemIds)
            let deleteBatch = CoreDataStack.batchDeleteRequest(fetchRequest: fetchRequest)
            CoreDataStack.sharedInstance.executeBatchDeleteAsynchronusly(request: deleteBatch, managedObjectContext: privateContext) { (success, error) in
                completion(success,error)
            }
        }else {
            completion(false, nil)
        }
    }
    
    
}
