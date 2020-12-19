//
//  WatchItem.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

class WatchItem {
    
    var id: Int
    var title: String
    var posterPath: String
    var releaseDate: String
    var voteCount: Int
    
    var backdropPath: String?
    var genreIDs: [Int]?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Float?
    var voteAverage: Int?
    var isFavourite: Bool = false
    
    init(id: Int, title: String, posterPath: String, releaseDate: String, voteCount: Int) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteCount = voteCount
    }
    
}
