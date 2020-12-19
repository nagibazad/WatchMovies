//
//  HorizontalContentView.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import UIKit

protocol HorizontalContentSelectionDelegate {
    func didSelect(item: WatchItem) -> Void
}

class HorizontalContentView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: CategoryDataModel?
    var delegate: HorizontalContentSelectionDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() -> Void {
        Bundle.main.loadNibNamed(String(describing: HorizontalContentView.self), owner: self, options: nil)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(containerView)
        self.collectionView.register(WatchItemCollectionViewCell.nib(), forCellWithReuseIdentifier: WatchItemCollectionViewCell.identifier())
    }
    
    func configure(with model: CategoryDataModel) -> Void {
        self.dataSource = model
        self.collectionView.reloadData()
    }

}

extension HorizontalContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = self.dataSource?.watchItems[indexPath.row] {
            self.delegate?.didSelect(item: item)
        }
    }
}

extension HorizontalContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.watchItems.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchItemCollectionViewCell.identifier(), for: indexPath) as! WatchItemCollectionViewCell
        if let watchItem = self.dataSource?.watchItems[indexPath.row] {
            cell.configure(with: watchItem)
        }
        return cell
    }
    
    
}

extension HorizontalContentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300.0, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
