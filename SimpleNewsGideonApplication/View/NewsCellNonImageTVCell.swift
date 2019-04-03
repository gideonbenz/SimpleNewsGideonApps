//
//  NewsCellNonImageTVCell.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 30/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class NewsCellNonImageTVCell: UITableViewCell {
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //didSet mirip cell yang frontNewsCell
    var indexCell: Int?
    var date = Date()
    var dateString = String()
    var dateConverted = String()
    
    var newsFeed: NewsResponse! {
        didSet {
            self.updateUI()
        }
    }
    
    var newsCoreDataFeed: NewsCore! {
        didSet {
            self.updateCoreDataUI()
        }
    }
    
    func updateCoreDataUI() {
        if let headline = newsCoreDataFeed.headline {
            headlineLabel.text = headline
        }

        if let date = newsCoreDataFeed.date {
            dateString = "\(date)"
            dateConverted = convertDateFormaterToNormal(dateString)

            dateLabel.text = "\(dateConverted)"
        }
    }
    
    
    
    
    func updateUI() {
        if let indexCell = indexCell {
            //  MARK: Headline
            headlineLabel.text = "\(newsFeed.headlines[indexCell]!.headline)"
            
            //  MARK: Date
            date = newsFeed.date[indexCell]!.date!
            dateString = "\(date)"
            dateConverted = convertDateFormaterToNormal(dateString)
            
            dateLabel.text = "\(dateConverted)"
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension NewsCellNonImageTVCell {
    private func convertDateFormaterToNormal(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date!)
    }
}
