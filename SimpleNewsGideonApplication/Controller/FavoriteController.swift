//
//  FavoriteController.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 06/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class FavoriteController: UIViewController {
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var newsCoreDataArray = [NewsCore?]()
    var newsFavoritedArray = [NewsCore?]()
    var favoritedNewsIndexPath : [Int]?
    var selectedIndexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureDataSource()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.detailNewsSegueIdentifier {
            let detailNewsController = segue.destination as! DetailNewsController
            
            detailNewsController.newsCore = newsCoreDataArray
            
            if let selectedIndexPath = selectedIndexPath {
                detailNewsController.selectedIndexPath = selectedIndexPath
            } else { print("failed pass selectedIndexPath") }
        }
        else { print("bukan segue detail") }
    }
}

extension FavoriteController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsFavoritedArray.count != 0 {
            return newsFavoritedArray.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let favoritedNewsIndexPath = favoritedNewsIndexPath {
            let favoriteIndexPath = favoritedNewsIndexPath[indexPath.row]
            if let newsImage = newsFavoritedArray[indexPath.row]?.image {
                if newsImage == Data() {
                    let favoritedNonImageCell = tableView.dequeueReusableCell(withIdentifier: Constants.favoritedNewsCellNonImage, for: indexPath) as! FavoriteNewsCellNonImageTVCell
                    
                    favoritedNonImageCell.newsCoreDataFeed = newsCoreDataArray[favoriteIndexPath]
                    favoritedNonImageCell.selectionStyle = .none
                    
                    return favoritedNonImageCell
                    
                } else {
                    let favoritedCell = tableView.dequeueReusableCell(withIdentifier: Constants.favoritedFrontNewscell, for: indexPath) as! FrontFavoriteNewsTVCell
                    
                    favoritedCell.newsCoreDataFeed = newsCoreDataArray[favoriteIndexPath]
                    favoritedCell.selectionStyle = .none
                    
                    return favoritedCell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let favoriteNewsIndexPath = favoritedNewsIndexPath else { return }
        selectedIndexPath = favoriteNewsIndexPath[indexPath.row]
        performSegue(withIdentifier: Constants.detailNewsSegueIdentifier, sender: prepare)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.favoriteTableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
