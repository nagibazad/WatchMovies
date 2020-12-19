//
//  FavouriteServiceProvider.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

class FavouriteServiceProvider {
    
    private var watchItemStorage: WatchItemStorageImp
    
    init() {
        self.watchItemStorage = WatchItemStorageImp()
    }

    func updateFavouriteWatchItem(for item: WatchItem, with completion: @escaping(Bool,Error?)->()) -> Void {
        self.watchItemStorage.save(item: item) { (success, error) in
            completion(success,error)
        }
    }
    
    func fetchAllFavouriteWatchItems(with completion:@escaping ([WatchItem],Error?)->()) -> Void {
        self.watchItemStorage.fetchAllFavourite { (managedObjects, error) in
            var items = [WatchItem]()
            if let managedObjects = managedObjects, managedObjects.isEmpty == false {
                managedObjects.forEach { (managedObject) in
                    if let managedObject = managedObject as? StoredWatchItem, let title = managedObject.title, let posterImagePath = managedObject.posterImagePath, let releaseDate = managedObject.releaseDate {
                        let item = WatchItem(id: Int(managedObject.id), title: title, posterPath: posterImagePath, releaseDate: releaseDate, voteCount: Int(managedObject.voteCount));
                        item.isFavourite = managedObject.isFavourite
                        items.append(item)
                    }
                    completion(items, nil)
                }
            }else {
                completion(items, NSError(domain: "com.watchitem.error", code: 404, userInfo: [NSLocalizedDescriptionKey:"No favourite found."]))
            }
        }
    }
}
