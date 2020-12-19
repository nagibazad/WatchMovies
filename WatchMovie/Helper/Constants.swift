//
//  Constants.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

struct Constants {
    
    enum WatchItemType: String {
        case Movie = "movie"
        case tv = "tv"
    }
    
    struct API {
        static let baseUrl = "https://api.themoviedb.org/"
        static let posterImageBaseUrl = "https://image.tmdb.org/t/p/w342"
        static let backDropImageBaseUrl = "https://image.tmdb.org/t/p/w780"
        static let logoImageImageBaseUrl = "https://image.tmdb.org/t/p/w300"
        static let castImageBaseUrl = "https://image.tmdb.org/t/p/h632"

        static let version = "3"
        static let apiKey = "1a97f3b8d5deee1d649c0025f3acf75c"
        
        struct EndPoint {
            static let popularMoviesEndPoint = "/discover/movie"
            static let popularTVSeriesEndPoint = "/discover/tv"
            static let trendingContentEndPoint = "/trending/all/week"
        }
        
        struct CommonParams {
            static let api_key = "api_key"
            static let primary_release_year = "primary_release_year"
            static let sort_by = "sort_by"
        }
        
        struct RequestParams {
            
        }
        
        struct ResponseParams {
            static let results = "results"
            static let media_type = "media_type"

            static let adult = "adult"
            static let backdrop_path = "backdrop_path"
            static let genre_ids = "genre_ids"
            static let id = "id"
            static let original_language = "original_language"
            static let original_title = "original_title"
            static let overview = "overview"
            static let popularity = "popularity"
            static let poster_path = "poster_path"
            static let release_date = "release_date"
            static let title = "title"
            static let video = "video"
            static let vote_average = "vote_average"
            static let vote_count = "vote_count"
            
            
            static let first_air_date = "first_air_date"
            static let origin_country = "origin_country"
            static let original_name = "original_name"
            static let name = "name"
            
        }
    }
}
//            "backdrop_path": "/oPYfRr5iTLjlwshADxr50SRuFP2.jpg",
//            "genre_ids": [
//                53,
//                18
//            ],
//            "id": 777394,
//            "original_language": "en",
//            "original_title": "The Whisperer",
//            "overview": "The isolation of the corona virus lockdown brings back a suppressed second personality within a mentally ill girl.",
//            "popularity": 1.4,
//            "poster_path": "/3AomFe7JSbwahkHh9ovWecqtfTH.jpg",
//            "release_date": "2020-12-16",
//            "title": "The Whisperer",
//            "video": false,
//            "vote_average": 10,
//            "vote_count": 1
//
//
//            "adult": false,
//
//
//            "name": "Baby Shark's Big Show!",
//            "origin_country": [],
            
