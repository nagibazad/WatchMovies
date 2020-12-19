//
//  HomeServiceProvider.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import Foundation

typealias HomeContentFetchCompletion = (Bool,Error?)->()

class HomeServiceProvider {
    
    private var contents: [CategoryDataModel]
    
    init() {
        self.contents = [CategoryDataModel]()
    }
    func fetchHomeContents(with completion: @escaping HomeContentFetchCompletion) -> Void {
        let group = DispatchGroup()
        
        group.enter()
        HomeAPIService.fetchTrendingContents(for: 1, parser: TrendingContentParser()) { (items, error) in
            if let items = items, items.isEmpty == false {
                self.contents.append(TrendingContent(title: "Trending Content", watchItems: items, sequence: 3))
            }
            group.leave()
        }
        
        group.enter()
        HomeAPIService.fetchPopularMovies(for: 1, parser: PopularMovieParser()) { (items, error) in
            if let items = items, items.isEmpty == false {
                self.contents.append(PopularMovies(title: "Popular Movies", watchItems: items, sequence: 1))
            }
            group.leave()
        }
        
        group.enter()
        HomeAPIService.fetchPopularTvSeries(for: 1, parser: PopularTvSeriesParser()) { (items, error) in
            if let items = items, items.isEmpty == false {
                self.contents.append(PopularTVSeries(title: "Popular TV Series", watchItems: items, sequence: 2))
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.global()) {
            self.contents.sort { (first, second) -> Bool in
                return first.sequence < second.sequence
            }
            completion(true,nil)
        }
    }
    
}

extension HomeServiceProvider {
    
    func homeContent(at index: Int) -> CategoryDataModel {
        return self.contents[index]
    }
    
    func numberOfContents() -> Int {
        return self.contents.count
    }
    
    func removeAll() -> Void {
        self.contents.removeAll()
    }

}
