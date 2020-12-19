//
//  PopularMovieParser.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

class PopularMovieParser: Parser {
    func parse(data: Any) -> Any? {
        guard let data = data as? [String : Any] else { return nil }
        let movieParser = MovieParser()
        
        if let results = data[Constants.API.ResponseParams.results] as? [[String : Any]] {
            var items = [WatchItem]()
            for eachJson in results {
                if let watchItem = movieParser.parse(data: eachJson) as? Movie {
                    items.append(watchItem)
                }
            }
            return items
        }else {
            return nil
        }
    }
}
