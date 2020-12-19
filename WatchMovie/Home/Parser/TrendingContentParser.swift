//
//  TrendingContentParser.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

class TrendingContentParser: Parser {
    func parse(data: Any) -> Any? {
        guard let data = data as? [String : Any] else { return nil }
        let movieParser = MovieParser()
        let tvSeriesParser = TVSeriesParser()
        
        if let results = data[Constants.API.ResponseParams.results] as? [[String : Any]] {
            var items = [WatchItem]()
            for eachJson in results {
                var watchItem: WatchItem?
                
                if let type = eachJson[Constants.API.ResponseParams.media_type] as? String, type == Constants.WatchItemType.Movie.rawValue {
                    watchItem = movieParser.parse(data: eachJson) as? Movie
                }else {
                    watchItem = tvSeriesParser.parse(data: eachJson) as? TVSeries
                }
                
                if let watchItem = watchItem {
                    items.append(watchItem)
                }
            }
            return items
        }else {
            return nil
        }
    }
}
