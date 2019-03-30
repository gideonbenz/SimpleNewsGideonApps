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
    
    var newsFeed: NewsResponse! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let indexCell = indexCell {
//  MARK: Headline
            newsHeadlineLabel.text = "\(newsFeed.headlines[indexCell]!.headline)"
            
//  MARK: Date
            date = newsFeed.date[indexCell]!.date!
            dateString = "\(date)"
            dateConverted = convertDateFormaterToNormal(dateString)
            
            newsDateLabel.text = "\(dateConverted)"
            
//  MARK: Image
            let newsMultimedia = newsFeed.responses[indexCell]!.multimedia
            
            let arrayWithNoOptionals = newsMultimedia.compactMap { $0 }
            
            if arrayWithNoOptionals.count != 0 {
                
                let newsImage = newsMultimedia[0]?.url
                if let newsImage = newsImage {
                    let urlString = "https://static01.nyt.com/\(newsImage)"
                    let url = URL(string: urlString)
                    if let url = url {
                        let request = URLRequest(url: url)
                        let networkProcessor = NetworkProcessor(url: url ,request: request)
                        
                        networkProcessor.downloadDataFromURL { (data, response, error) in
                            DispatchQueue.main.async {
                                if let imageData = data {
                                    self.newsImageView.image = UIImage(data: imageData)
                                }
                            }
                        }
                    }
                }
            } else { self.newsImageView.image = nil }
            
        }
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
