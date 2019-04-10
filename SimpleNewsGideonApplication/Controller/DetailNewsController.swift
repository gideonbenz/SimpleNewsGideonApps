//
//  DetailNewsController.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 04/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class DetailNewsController: UIViewController {
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet var detailView: UIView!
    
    var newsCore: [NewsCore?]?
    var favoritedNewsCore = [NewsCore?]()
    var isConnected: Bool?
    var imageArrayData = [Data]()
    var selectedIndexPath: Int?
    var isFavorited = false
    
    var headlineSelected: String?
    var snippetSelected: String?
    var dateSelected: Date?
    var imageSelected: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureDataSource()
    }
    
@IBAction func addToFavorite(_ sender: UIButton) {
        switch isFavorited {
        case true: removeFromFavorite()
        default: addToFavorite()
        }
    }
}

extension DetailNewsController {
    
    func addToFavorite() {
        favoriteButton.setTitle("Favorited", for: .normal)
        isFavorited = true
        saveFavoriteCellToCoreData()
    }
    
    func removeFromFavorite() {
        favoriteButton.setTitle("+Favorite", for: .normal)
        isFavorited = false
//        deleteFavoriteCellFromCoreData()
    }
}



