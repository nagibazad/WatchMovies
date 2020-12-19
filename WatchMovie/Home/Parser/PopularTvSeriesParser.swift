//
//  PopularTvSeriesParser.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

class PopularTvSeriesParser: Parser {
    func parse(data: Any) -> Any? {
        guard let data = data as? [String : Any] else { return nil }
        let tvSeriesParser = TVSeriesParser()
        
        if let results = data[Constants.API.ResponseParams.results] as? [[String : Any]] {
            var items = [WatchItem]()
            for eachJson in results {
                if let watchItem = tvSeriesParser.parse(data: eachJson) as? TVSeries {
                    items.append(watchItem)
                }
            }
            return items
        }else {
            return nil
        }
    }
}
