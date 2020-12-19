//
//  PopulerWatchItemsTableViewCell.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import UIKit

class PopulerWatchItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var horizontalContentView: HorizontalContentView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model:CategoryDataModel, delegate:HorizontalContentSelectionDelegate?) -> Void {
        self.horizontalContentView.delegate = delegate
        self.horizontalContentView.configure(with: model)
    }
    
}
