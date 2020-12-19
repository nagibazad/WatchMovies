//
//  NSManagedObjectContext+RecursiveSave.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import CoreData

extension NSManagedObjectContext{
    func saveAsyncRecusively(withCompletionBlock completionBlock: @escaping SaveCompletionHandler) -> Void {
        
        perform {
            if self.hasChanges == true {
                do{
                    try self.save()
                    if let parent = self.parent {
                        parent.saveAsyncRecusively(withCompletionBlock: {(success, error) in
                            completionBlock(success,error)
                        })
                    }else {
                        completionBlock(true, nil)
                    }
                    
                }catch let saveError as NSError{
                    completionBlock(false, saveError)
                }
            }else {
                completionBlock(true, nil)
            }
        }
    }
    
    func deleteAsyncRecusively(managedObject: NSManagedObject, withCompletionBlock completionBlock: @escaping DeleteCompletionHandler) -> Void {
        perform {
            if self.hasChanges == true {
                    self.delete(managedObject)
                    if let parent = self.parent {
                        parent.deleteAsyncRecusively(managedObject: managedObject, withCompletionBlock: {(success, error) in
                            completionBlock(success,error)
                        })
                    }else {
                        completionBlock(true, nil)
                    }
            }else {
                completionBlock(true, nil)
            }
        }
    }
    
    func saveSyncRecusively(withCompletionBlock completionBlock:SaveCompletionHandler) -> Void {
        
        performAndWait {
            if self.hasChanges == true {
                do{
                    try self.save()
                    if let parent = self.parent {
                        parent.saveSyncRecusively(withCompletionBlock: {(success: Bool, error: NSError?) in
                            completionBlock(success,error)
                        })
                    }else {
                        completionBlock(true, nil)
                    }
                    
                }catch let saveError as NSError{
                    completionBlock(false, saveError)
                }
            }else {
                completionBlock(true, nil)
            }
        }
    }
    
    func deleteSyncRecusively(managedObject: NSManagedObject, withCompletionBlock completionBlock:DeleteCompletionHandler) -> Void {
        performAndWait {
            if self.hasChanges == true {
                    self.delete(managedObject)
                    if let parent = self.parent {
                        parent.deleteSyncRecusively(managedObject: managedObject, withCompletionBlock: {(success, error) in
                            completionBlock(success,error)
                        })
                    }else {
                        completionBlock(true, nil)
                    }
            }else {
                completionBlock(true, nil)
            }
        }
    }
}
