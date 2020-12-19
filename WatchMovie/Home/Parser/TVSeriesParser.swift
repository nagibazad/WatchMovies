//
//  TVSeriesParser.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation


class TVSeriesParser: Parser {
    func parse(data: Any) -> Any? {
        guard let data = data as? [String : Any] else { return nil }

        if let id = data[Constants.API.ResponseParams.id] as? Int,
           let title = data[Constants.API.ResponseParams.name] as? String,
           let posterPath = data[Constants.API.ResponseParams.poster_path] as? String,
           let releaseDate = data[Constants.API.ResponseParams.first_air_date] as? String {
            let tvSeriesItem = TVSeries(id: id, title: title, posterPath: posterPath, releaseDate: releaseDate, voteCount: data[Constants.API.ResponseParams.vote_count] as? Int ?? 0)
            tvSeriesItem.originCountry = data[Constants.API.ResponseParams.origin_country] as? [String]
            tvSeriesItem.backdropPath = data[Constants.API.ResponseParams.backdrop_path] as? String
            tvSeriesItem.genreIDs = data[Constants.API.ResponseParams.genre_ids] as? [Int]
            tvSeriesItem.originalLanguage = data[Constants.API.ResponseParams.original_language] as? String
            tvSeriesItem.originalTitle = data[Constants.API.ResponseParams.original_name] as? String
            tvSeriesItem.overview = data[Constants.API.ResponseParams.overview] as? String

            tvSeriesItem.popularity = data[Constants.API.ResponseParams.popularity] as? Float
            tvSeriesItem.voteAverage = data[Constants.API.ResponseParams.vote_average] as? Int

            return tvSeriesItem
        }else {
            return nil
        }
    }

}
