//
//  WatchItemStorage.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation
import CoreData

typealias WatchItemStorageFetchCompletion = ([NSManagedObject]?,Error?)->()
typealias WatchItemStorageSingleFetchCompletion = (NSManagedObject?,Error?)->()
typealias WatchItemStorageSaveCompletion = (Bool,Error?)->()
typealias WatchItemStorageDeleteCompletion = (Bool,Error?)->()

protocol WatchItemStorage {
    func fetchAll(with completion:@escaping WatchItemStorageFetchCompletion) -> Void
    func fetchWatchItem(identifier: String, completion:@escaping WatchItemStorageSingleFetchCompletion) -> Void
    func save(item: WatchItem, completion: @escaping WatchItemStorageSaveCompletion) -> Void
    func save(items: [WatchItem], completion: @escaping WatchItemStorageSaveCompletion) -> Void
    func delete(item: WatchItem, completion: @escaping WatchItemStorageDeleteCompletion) -> Void
    func delete(items: [WatchItem], completion: @escaping WatchItemStorageDeleteCompletion) -> Void
}
