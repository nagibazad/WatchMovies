//
//  MovieParser.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

class MovieParser: Parser {
    func parse(data: Any) -> Any? {
        guard let data = data as? [String : Any] else { return nil }

        if let id = data[Constants.API.ResponseParams.id] as? Int,
           let title = data[Constants.API.ResponseParams.original_title] as? String,
           let posterPath = data[Constants.API.ResponseParams.poster_path] as? String,
           let releaseDate = data[Constants.API.ResponseParams.release_date] as? String {
            let movieItem = Movie(id: id, title: title, posterPath: posterPath, releaseDate: releaseDate, voteCount: data[Constants.API.ResponseParams.vote_count] as? Int ?? 0)
            movieItem.adult = data[Constants.API.ResponseParams.adult] as? Bool
            movieItem.backdropPath = data[Constants.API.ResponseParams.backdrop_path] as? String
            movieItem.genreIDs = data[Constants.API.ResponseParams.genre_ids] as? [Int]
            movieItem.originalLanguage = data[Constants.API.ResponseParams.original_language] as? String
            movieItem.originalTitle = data[Constants.API.ResponseParams.original_title] as? String
            movieItem.overview = data[Constants.API.ResponseParams.overview] as? String

            movieItem.popularity = data[Constants.API.ResponseParams.popularity] as? Float
            movieItem.video = data[Constants.API.ResponseParams.video] as? Bool
            movieItem.voteAverage = data[Constants.API.ResponseParams.vote_average] as? Int

            return movieItem
        }else {
            return nil
        }
    }
}
