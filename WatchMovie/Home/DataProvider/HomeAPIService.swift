//
//  HomeAPIService.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

class HomeAPIService {
    
    class func fetchTrendingContents(for page: Int, parser: Parser, with completion:@escaping ([WatchItem]?, Error?)->()) -> Void {
        fetchFromServer(endPoint: Constants.API.EndPoint.trendingContentEndPoint, for: page, parser: parser, with: completion)
    }
    
    class func fetchPopularMovies(for page: Int, parser: Parser, with completion:@escaping ([WatchItem]?, Error?)->()) -> Void {
        fetchFromServer(endPoint: Constants.API.EndPoint.popularMoviesEndPoint, for: page, parser: parser, with: completion)
    }
    
    class func fetchPopularTvSeries(for page: Int, parser: Parser, with completion:@escaping ([WatchItem]?, Error?)->()) -> Void {
        fetchFromServer(endPoint: Constants.API.EndPoint.popularTVSeriesEndPoint, for: page, parser: parser, with: completion)
    }
    
    private class func fetchFromServer(endPoint: String, for page: Int, parser: Parser, with completion:@escaping ([WatchItem]?, Error?)->()) -> Void {
        var items: [WatchItem]?
        var urlComponent = URLComponents(string: Constants.API.baseUrl + Constants.API.version + endPoint)
        urlComponent?.queryItems = [
            URLQueryItem(name: Constants.API.CommonParams.api_key, value: Constants.API.apiKey),
            URLQueryItem(name: Constants.API.CommonParams.primary_release_year, value: "2020"),
            URLQueryItem(name: Constants.API.CommonParams.sort_by, value: "vote_average.desc")]
          
        if let url = urlComponent?.url {
            URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
                if error != nil {
                    completion(items, error)
                }else {
                    if let data = data {
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                                items = parser.parse(data: jsonResponse) as? [WatchItem];
                                completion(items,nil)
                            }else {
                                completion(items, NSError(domain: "com.watch.error.feed", code: 404, userInfo: [NSLocalizedDescriptionKey : "Unknown exception occured"]))
                            }
                        } catch let parsingError {
                            completion(items, parsingError)
                        }
                    }
                }
            }.resume()
        }else {
            completion(items, NSError(domain: "com.watch.error.feed", code: 404, userInfo: [NSLocalizedDescriptionKey : "Invalid Url."]))
        }
    }
}
