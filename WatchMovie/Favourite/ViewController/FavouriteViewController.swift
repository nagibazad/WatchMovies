//
//  FavouriteViewController.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import UIKit

class FavouriteViewController: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
    private var serviceProvider: FavouriteServiceProvider = FavouriteServiceProvider()
    private var favItems: [WatchItem] = [WatchItem]()
    class func initializeFavouriteViewController() -> FavouriteViewController {
        let viewController = FavouriteViewController.instantiateViewController(from: .favourite()) as! FavouriteViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.title = "Favourites"
        self.favoriteTableView.register(WatchItemTableViewCell.nib(), forCellReuseIdentifier: WatchItemTableViewCell.identifier())
        self.serviceProvider.fetchAllFavouriteWatchItems {[weak self] (items, error) in
            DispatchQueue.main.async {
                if let strongSelf = self {
                    strongSelf.favItems.append(contentsOf: items)
                    strongSelf.favoriteTableView.reloadData()
                }
            }
        }
    }
}

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavouriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let item = self.favItems[indexPath.row]
            item.isFavourite = !item.isFavourite
            self.serviceProvider.updateFavouriteWatchItem(for: item) {[weak self] (success, error) in
                if let strongSelf = self {
                    DispatchQueue.main.async {
                        strongSelf.favItems.remove(at: indexPath.row)
                        strongSelf.favoriteTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.favItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WatchItemTableViewCell.identifier(), for: indexPath) as! WatchItemTableViewCell
        cell.configure(with: self.favItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
