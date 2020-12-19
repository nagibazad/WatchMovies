//
//  CategoryDataModel.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

class CategoryDataModel {
    var title: String
    var watchItems: [WatchItem]
    var sequence: Int
    
    init(title: String, watchItems: [WatchItem], sequence: Int) {
        self.title = title
        self.watchItems = watchItems
        self.sequence = sequence
    }
}
