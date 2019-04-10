//
//  NewsController.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 26/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class NewsController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var newsSearchBar: UISearchBar!
    
    var news: NewsResponse?
    var newsCoreDataArray = [NewsCore?]()
    var newsCoreSearching = [NewsCore]()
    var isConnected = false
    var isSearching = false
    var selectedIndexPath: Int?
    let dispatchGroup = DispatchGroup()
    var imageArrayData = [Data]()
    
    //dipisah di folder constants
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureSourceData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.detailNewsSegueIdentifier {
            let detailNewsController = segue.destination as! DetailNewsController
            detailNewsController.isConnected = isConnected
            detailNewsController.newsCore = newsCoreDataArray
            
            if let selectedIndexPath = selectedIndexPath {
                detailNewsController.selectedIndexPath = selectedIndexPath
            } else { print("failed pass selectedIndexPath") }
            
        } else if segue.identifier == Constants.favoriteNewsSegueIdentifier {
            let favoriteNewsController = segue.destination as! FavoriteController
            favoriteNewsController.newsCoreDataArray = newsCoreDataArray
            
        }
        else { print("bukan segue detail") }
    }
}

extension NewsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return newsCoreSearching.count
        } else { return (newsCoreDataArray.count) }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            if let newsImage = newsCoreSearching[indexPath.row].image {
                if newsImage == Data() {
                    let nonImageCell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCellNonImage, for: indexPath) as! NewsCellNonImageTVCell
                    nonImageCell.newsCoreDataFeed = newsCoreSearching[indexPath.row]
                    nonImageCell.selectionStyle = .none
                    
                    return nonImageCell
                    
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.frontNewscell, for: indexPath) as! FrontNewsTVCell
                    cell.newsCoreDataFeed = newsCoreSearching[indexPath.row]
                    cell.selectionStyle = .none
                    
                    return cell
                }
            }
        } else {
            if let newsImage = newsCoreDataArray[indexPath.row]?.image {
                if newsImage == Data() {
                    let nonImageCell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCellNonImage, for: indexPath) as! NewsCellNonImageTVCell
                    nonImageCell.newsCoreDataFeed = newsCoreDataArray[indexPath.row]
                    nonImageCell.selectionStyle = .none
                    
                    return nonImageCell
                    
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.frontNewscell, for: indexPath) as! FrontNewsTVCell
                    cell.newsCoreDataFeed = newsCoreDataArray[indexPath.row]
                    cell.selectionStyle = .none
                    
                    return cell
                }
            }
        }
        return UITableViewCell()
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: Constants.detailNewsSegueIdentifier, sender: prepare)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.newsTableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NewsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText == "" {
                isSearching = false
                newsTableView.reloadData()
            } else {
                newsCoreSearching = newsCoreDataArray.filter({($0!.headline!.lowercased().prefix(searchText.count)) == searchText.lowercased()}) as! [NewsCore]
                isSearching = true
                print(newsCoreSearching)
                newsTableView.reloadData()
            }
        }
}


