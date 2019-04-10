//
//  DetailNewsControllerExtension.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 04/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension DetailNewsController {
    func configureNavigation() {
        self.navigationItem.title = "Detail News View"
        //swipe-able gesture mungkin nanti disini
        swipeViewIsEnabled()
    }
    
    func configureDataSource() {
        configureWithCoreData()
    }
    
    func configureWithCoreData() {
        guard let newsCore = newsCore else { return }
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        if let headline = newsCore[selectedIndexPath]?.headline {
            self.headlineLabel.text = headline
        }
        
        if let snippet = newsCore[selectedIndexPath]?.snippet {
            self.snippetLabel.text = snippet
            self.snippetLabel.sizeToFit()
        }
        
        if let date = newsCore[selectedIndexPath]?.date {
            let dateConverted = convertDateFormaterToNormal("\(date)")
            self.dateLabel.text = dateConverted
        }
        
        if let imageBinary = newsCore[selectedIndexPath]?.image {
            if imageBinary != Data() {
                self.newsImageView.image = UIImage(data: imageBinary)
            } else { self.newsImageView.image = nil }
        }
        configureFavoritedCoreData()
    }
    
    func configureFavoritedCoreData() {
        fetchFavoritedNews { (favoritedNewsCore) in
            guard let newsCore = self.newsCore else { return }
//            let filteredFavoriteNews = filterNewsCoreDataWithFavoritedNews(newsCore: newsCore, favoritedNewsCore: favoritedNewsCore)
//            DispatchQueue.main.async {
//                self.favoritedNewsCore = filteredFavoriteNews
//            }
        }
    }
}




extension DetailNewsController {
    
    func swipeViewIsEnabled() {
        let swipeLeftViewGestureRecognizer = UISwipeGestureRecognizer(target: self , action: #selector(swipeAction(swipe:)))
        swipeLeftViewGestureRecognizer.direction = .left
        
        let swipeRightViewGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeRightViewGestureRecognizer.direction = .right
        
        self.detailView.addGestureRecognizer(swipeLeftViewGestureRecognizer)
        self.detailView.addGestureRecognizer(swipeRightViewGestureRecognizer)
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction.rawValue {
            case 1: swipeToLeft()
            case 2: swipeToRight()
        default:
            break
        }
        
    }
    
    func swipeToLeft() {
        guard let newsCore = newsCore else { return }
        guard let selectedIndexPath = selectedIndexPath else { return }
        if selectedIndexPath > 0 {
            let navigateIndexPath = selectedIndexPath - 1
            
            if let headline = newsCore[navigateIndexPath]?.headline {
                self.headlineLabel.text = headline
            }
            
            if let snippet = newsCore[navigateIndexPath]?.snippet {
                self.snippetLabel.text = snippet
                self.snippetLabel.sizeToFit()
            }
            
            if let date = newsCore[navigateIndexPath]?.date {
                let dateConverted = convertDateFormaterToNormal("\(date)")
                self.dateLabel.text = dateConverted
            }
            
            if let imageBinary = newsCore[navigateIndexPath]?.image {
                if imageBinary != Data() {
                    self.newsImageView.image = UIImage(data: imageBinary)
                } else { self.newsImageView.image = nil }
            }
            self.selectedIndexPath = navigateIndexPath
        } else { print("maxed Page") }
    }
    
    func swipeToRight() {
        guard let newsCore = newsCore else { return }
        guard let selectedIndexPath = selectedIndexPath else { return }
        if selectedIndexPath < newsCore.count - 1 {
            let navigateIndexPath = selectedIndexPath + 1
            
            if let headline = newsCore[navigateIndexPath]?.headline {
                self.headlineLabel.text = headline
            }
            
            if let snippet = newsCore[navigateIndexPath]?.snippet {
                self.snippetLabel.text = snippet
                self.snippetLabel.sizeToFit()
            }
            
            if let date = newsCore[navigateIndexPath]?.date {
                let dateConverted = convertDateFormaterToNormal("\(date)")
                self.dateLabel.text = dateConverted
            }
            
            if let imageBinary = newsCore[navigateIndexPath]?.image {
                if imageBinary != Data() {
                    self.newsImageView.image = UIImage(data: imageBinary)
                } else { self.newsImageView.image = nil }
            }
            self.selectedIndexPath = navigateIndexPath
        } else { print("maxed Page") }
    }
}
extension DetailNewsController {
    private func convertDateFormaterToNormal(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date!)
    }
}

//MARK: Fetch Core Data
extension DetailNewsController {
    
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
        
        for i in 0..<favoritedNewsCoreCountedValue {
            if isFavoritedNewsCore[i] == true {
                favoritedNewsFilteredValue.append(newsCore[favoritedNewsIndexPath[i]])
            }
        }
        
        return favoritedNewsFilteredValue
    }
}

//MARK: Save Core Data
extension DetailNewsController {
    
    func saveFavoriteCellToCoreData() {
        let context = PersistenceService.persistentContainer.viewContext
        if let favoriteEntityDescription = NSEntityDescription.entity(forEntityName: "Favorite", in: context) {
            let favorite = NSManagedObject(entity: favoriteEntityDescription, insertInto: context)
            favorite.setValue(self.selectedIndexPath, forKey: "id")
            favorite.setValue(self.isFavorited, forKey: "isFavorited")
            
            do {
                try PersistenceService.saveContext()
            } catch { print("Error: saveFavoriteCellToCoreData") }
        }
    }
    
//    func deleteFavoriteCellFromCoreData() {
//        let context = PersistenceService.persistentContainer.viewContext
//        if let favoriteEntityDescription = NSEntityDescription.entity(forEntityName: "Favorite", in: context) {
//            guard let index = self.selectedIndexPath else { return }
//
//            context.delete(Favorite[index] as NSManagedObject)
//
//            do {
//                try PersistenceService.saveContext()
//            } catch { print("Error: saveFavoriteCellToCoreData") }
//    }
    
        
        func deleteFavoriteCellFromCoreData() {
            let managedContext = PersistenceService.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Favorite>(entityName:"Favorite")
            guard let selectedIndexPath = self.selectedIndexPath else { return }
            fetchRequest.predicate = NSPredicate(format: "id = %@", selectedIndexPath)
            do
            {
                let fetchedResults =  try managedContext.execute(fetchRequest) as? [NSManagedObject]
                for entity in fetchedResults! {
                    
                    managedContext.delete(entity)
                }
            }
            catch _ {
                print("Could not delete")
                
            }
            
            do {
                try PersistenceService.saveContext()
            } catch  {print("Error: Save delete favorite")}
        }
}


