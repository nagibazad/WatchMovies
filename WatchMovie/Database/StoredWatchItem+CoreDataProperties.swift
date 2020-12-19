//
//  StoredWatchItem+CoreDataProperties.swift
//  
//
//  Created by user on 19/12/20.
//
//

import Foundation
import CoreData


extension StoredWatchItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredWatchItem> {
        return NSFetchRequest<StoredWatchItem>(entityName: "StoredWatchItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var posterImagePath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var voteCount: Int64
    @NSManaged public var originalLanguage: String?
    @NSManaged public var backDropImagePath: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Float
    @NSManaged public var voteAverage: Int64
    @NSManaged public var isFavourite: Bool

}
