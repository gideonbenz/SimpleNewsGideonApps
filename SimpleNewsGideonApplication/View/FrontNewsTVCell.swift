//
//  FrontNewsTVCell.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 29/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class FrontNewsTVCell: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsHeadlineLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    
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
            newsHeadlineLabel.text = headline
        }

        if let date = newsCoreDataFeed.date {
            dateString = "\(date)"
            dateConverted = convertDateFormaterToNormal(dateString)

            newsDateLabel.text = "\(dateConverted)"
        }
        
        if newsCoreDataFeed.image != Data() {
            if let imageCore = newsCoreDataFeed.image {
                self.newsImageView.image = UIImage(data: imageCore)
            }
        } else { self.newsImageView.image = nil }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension FrontNewsTVCell {
    private func convertDateFormaterToNormal(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    
}
