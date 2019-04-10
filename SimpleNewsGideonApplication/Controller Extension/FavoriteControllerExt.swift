//
//  FavoriteControllerExtension.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 06/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation
import CoreData

extension FavoriteController {
    
    func configureNavigation() {
        self.navigationItem.title = "Favorite View"
        self.favoriteTableView.delegate = self
        self.favoriteTableView.dataSource = self
    }
    
    func configureDataSource() {
        let favoritedNewsCore = fetchFavoritedNews { (favoritedNewsCore) in
             let filteredFavoritedNews = filterNewsCoreDataWithFavoritedNews(newsCore: self.newsCoreDataArray, favoritedNewsCore: favoritedNewsCore)
                DispatchQueue.main.async {
                    self.newsFavoritedArray = filteredFavoritedNews
//                    print(self.favoritedNewsIndexPath)
//                    print(self.newsFavoritedArray)
//                    print("favorited news counted: \(self.newsFavoritedArray.count)")
                    self.favoriteTableView.reloadData()
                }
            }
        }
    }



//MARK: Fetch Core Data
extension FavoriteController {
    
    func fetchFavoritedNews(completion: ([FavoritedNewsCore?]) -> Void) {
        var favoritedNewsCoreDataValue = [FavoritedNewsCore?]()
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let favoritedNewsCoreDatas = try PersistenceService.context.fetch(fetchRequest)
            
            for favoritedNewsCoreData in favoritedNewsCoreDatas {
                let favoriteNewsCore = FavoritedNewsCore(favoritedNewsCoreData: favoritedNewsCoreData)
                favoritedNewsCoreDataValue.append(favoriteNewsCore)
            }
            completion(favoritedNewsCoreDataValue)
        } catch { print("fetchFavoriteNews process failed")}
    }
    
    func filterNewsCoreDataWithFavoritedNews(newsCore: [NewsCore?] ,favoritedNewsCore: [FavoritedNewsCore?]) -> [NewsCore?] {
        var favoritedNewsFilteredValue = [NewsCore?]()
        let favoritedNewsCoreCountedValue = newsCore.count
        var favoritedNewsIndexPath = [Int]()
        var isFavoritedNewsCore = [Bool]()
        
        for favoritedNews in favoritedNewsCore {
            if let id = favoritedNews?.id {
                favoritedNewsIndexPath.append(Int(id))
            } else { print("error: filterNewsCoreDataWithFavoritedNews id nil") }
            
            if let isFavorited = favoritedNews?.isFavorited {
                isFavoritedNewsCore.append(isFavorited)
            } else { print("error: filterNewsCoreDataWithFavoritedNews isFavorited nil") }
        }
        
//        for i in 0..<favoritedNewsCoreCountedValue {
//            if isFavoritedNewsCore[i] == true {
//               favoritedNewsFilteredValue.append(newsCore[favoritedNewsIndexPath[i]])
//            } else { break }
//        }
        for i in 0..<isFavoritedNewsCore.count {
            if isFavoritedNewsCore[i] == true {
                favoritedNewsFilteredValue.append(newsCore[i])
            }
        }
        self.favoritedNewsIndexPath = favoritedNewsIndexPath
        
        return favoritedNewsFilteredValue
    }
}




