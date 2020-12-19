//
//  DetailsViewController.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import UIKit

class DetailsViewController: UIViewController {

    private var watchItem: WatchItem?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    private var favBarButtonItem: UIBarButtonItem!
    private var watchItemStorage: WatchItemStorageImp = WatchItemStorageImp()
    
    class func initializeDetailsViewController(with model: WatchItem) -> DetailsViewController {
        let viewController = DetailsViewController.instantiateViewController(from: .details()) as! DetailsViewController
        viewController.watchItem = model
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        if let watchItem = self.watchItem {
            self.updateUI(for: watchItem)
        }
    }
    
    private func setupUI() -> Void {
        self.navigationController?.navigationBar.tintColor = .black
        self.title = "Details"
        self.favBarButtonItem = UIBarButtonItem(image: UIImage(named: "fav_normal"), style: .plain, target: self, action: #selector(DetailsViewController.favouriteButtonPressed))
        self.navigationItem.rightBarButtonItem = favBarButtonItem
    }
    
    @objc func favouriteButtonPressed() -> Void {
        if let watchItem = self.watchItem {
            watchItem.isFavourite = !watchItem.isFavourite
            self.watchItemStorage.save(item: watchItem) { (success, error) in
                DispatchQueue.main.async {
                    self.updateUI(for: watchItem)
                }
            }
        }
    }
    
    private func updateUI(for watchItem: WatchItem) -> Void {
        self.favBarButtonItem.image = UIImage(named: watchItem.isFavourite == true ? "fav_active" : "fav_normal")
        self.titleLabel.text = watchItem.title
        self.releaseDateLabel.text = watchItem.releaseDate
        self.voteCountLabel.text = "\(watchItem.voteCount)"
        self.originalLanguageLabel.text = watchItem.originalLanguage
        self.overviewLabel.text = watchItem.overview
        self.popularityLabel.text = "\(watchItem.popularity ?? 0.0)"
        self.voteAverageLabel.text = "\(watchItem.voteAverage ?? 0)"
        self.posterImageView.sd_setImage(with: URL(string: Constants.API.posterImageBaseUrl + watchItem.posterPath), placeholderImage: UIImage(named: "placeholder"), options: .refreshCached) { (image, error, cacheType, url) in
            
        }

        if let backdropPath = watchItem.backdropPath {
            self.backdropImageView.sd_setImage(with: URL(string: Constants.API.backDropImageBaseUrl + backdropPath), placeholderImage: UIImage(named: "placeholder"), options: .refreshCached) { (image, error, cacheType, url) in
                
            }
        }
        
    }

}
