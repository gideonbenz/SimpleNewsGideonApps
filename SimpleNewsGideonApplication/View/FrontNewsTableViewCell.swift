//
//  FrontNewsTableViewCell.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 29/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class FrontNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsHeadlineLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    
    var indexCell: Int?
    
    var newsFeed: NewsResponse! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let indexCell = indexCell {
            newsHeadlineLabel.text = "\(newsFeed.headlines[indexCell]!.headline)"
            newsDateLabel.text = "\(newsFeed.date[indexCell]!.date!)"
            
            let newsMultimedia = newsFeed.responses[indexCell]!.multimedia
            
//            let newsMultimedia7 = newsFeed.responses[7]?.multimedia /*nil*/
//            let newsMultimedia8 = newsFeed.responses[8]?.multimedia /*nil*/
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
                                    print(imageData)
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
