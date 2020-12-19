//
//  HomeViewController.swift
//  WatchMovie
//
//  Created by user on 19/12/20.
//

import UIKit
import MBProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet weak var watchContentTableView: UITableView!
    private var refreshControl = UIRefreshControl()

    private var serviceProvider: HomeServiceProvider = HomeServiceProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.loadData {
            //Update UI If Needed
        }
    }
    
    func loadData(with completion: @escaping ()->()) -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.serviceProvider.fetchHomeContents { [weak self](success, error) in
            DispatchQueue.main.async {
                if let strongSelf = self {
                    MBProgressHUD.hide(for: strongSelf.view, animated: true)
                    strongSelf.watchContentTableView.reloadData()
                    completion()
                }
            }
        }
    }
    
    private func setupUI() -> Void {
        self.title = "Home"
        self.navigationController?.navigationBar.tintColor = .black
        self.watchContentTableView.register(WatchItemTableViewCell.nib(), forCellReuseIdentifier: WatchItemTableViewCell.identifier())
        self.watchContentTableView.register(PopulerWatchItemsTableViewCell.nib(), forCellReuseIdentifier: PopulerWatchItemsTableViewCell.identifier())
        let favouriteBarButtonItem = UIBarButtonItem(title: "Favourites", style: .plain, target: self, action: #selector(HomeViewController.favouriteListButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = favouriteBarButtonItem
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.watchContentTableView.addSubview(refreshControl)
    }
    @objc private func favouriteListButtonPressed(_ sender: AnyObject) {
        let favouritesViewController = FavouriteViewController.initializeFavouriteViewController()
        self.navigationController?.pushViewController(favouritesViewController, animated: true)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        self.serviceProvider.removeAll()
        self.watchContentTableView.reloadData()
        self.loadData {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func showDetails(for item: WatchItem) -> Void {
        let detailsViewController = DetailsViewController.initializeDetailsViewController(with: item)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetails(for: self.serviceProvider.homeContent(at: indexPath.section).watchItems[indexPath.row])
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.serviceProvider.numberOfContents()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.serviceProvider.homeContent(at: section) is TrendingContent {
            return self.serviceProvider.homeContent(at: section).watchItems.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.serviceProvider.homeContent(at: section).title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.serviceProvider.homeContent(at: indexPath.section) is TrendingContent {
            return 80.0
        }else {
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.serviceProvider.homeContent(at: indexPath.section) is TrendingContent {
            let cell = tableView.dequeueReusableCell(withIdentifier: WatchItemTableViewCell.identifier(), for: indexPath) as! WatchItemTableViewCell
            cell.configure(with: self.serviceProvider.homeContent(at: indexPath.section).watchItems[indexPath.row])
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: PopulerWatchItemsTableViewCell.identifier(), for: indexPath) as! PopulerWatchItemsTableViewCell
            cell.configure(with: self.serviceProvider.homeContent(at: indexPath.section), delegate: self)
            return cell
        }
    }
}

extension HomeViewController: HorizontalContentSelectionDelegate {
    func didSelect(item: WatchItem) {
        self.showDetails(for: item)
    }
}
