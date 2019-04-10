//
//  FavoriteNewsCellNonImageTVCell.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 08/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class FavoriteNewsCellNonImageTVCell: UITableViewCell {
    @IBOutlet weak var favoriteHeadlineLabel: UILabel!
    @IBOutlet weak var favoriteDateLabel: UILabel!
    
    var indexCell: Int?
    var date = Date()
    var dateString = String()
    var dateConverted = String()
    
    var newsCoreDataFeed: NewsCore! {
        didSet {
            self.updateCoreDataUI()
        }
    }
    
    func updateCoreDataUI() {
        if let headline = newsCoreDataFeed.headline {
            favoriteHeadlineLabel.text = headline
        }
        
        if let date = newsCoreDataFeed.date {
            dateString = "\(date)"
            dateConverted = convertDateFormaterToNormal(dateString)
            
            favoriteDateLabel.text = "\(dateConverted)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension FavoriteNewsCellNonImageTVCell {
    private func convertDateFormaterToNormal(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date!)
    }
}


