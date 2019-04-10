//
//  FrontFavoriteNewsTVCell.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 08/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class FrontFavoriteNewsTVCell: UITableViewCell {

    @IBOutlet weak var favoriteHeadlineNewsLabel: UILabel!
    @IBOutlet weak var favoriteDateNewsLabel: UILabel!
    @IBOutlet weak var favoriteNewsImageView: UIImageView!
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
            favoriteHeadlineNewsLabel.text = headline
        }
        
        if let date = newsCoreDataFeed.date {
            dateString = "\(date)"
            dateConverted = convertDateFormaterToNormal(dateString)
            
            favoriteDateNewsLabel.text = "\(dateConverted)"
        }
        
        if newsCoreDataFeed.image != Data() {
            if let imageCore = newsCoreDataFeed.image {
                self.favoriteNewsImageView.image = UIImage(data: imageCore)
            }
        } else { self.favoriteNewsImageView.image = nil }
    }
}

extension FrontFavoriteNewsTVCell {
    private func convertDateFormaterToNormal(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
