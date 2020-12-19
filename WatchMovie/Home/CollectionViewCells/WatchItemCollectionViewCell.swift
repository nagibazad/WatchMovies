//
//  WatchItemCollectionViewCell.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import UIKit

class WatchItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var watchItemTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with model: WatchItem) -> Void {
        self.watchItemTitleLabel.text = model.title
        self.releaseDateLabel.text = "Released on: \(model.releaseDate)"
        self.voteLabel.text = "Rating: \(model.voteCount)"
        self.posterImageView.sd_setImage(with: URL(string: Constants.API.posterImageBaseUrl + model.posterPath), placeholderImage: UIImage(named: "placeholder"), options: .refreshCached) { (image, error, cacheType, url) in
            
        }
    }
    
}
