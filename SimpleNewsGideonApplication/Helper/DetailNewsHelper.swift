//
//  DetailNewsHelper.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 04/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation
import UIKit

extension DetailNewsController {
    func configureNavigation() {
        self.navigationItem.title = "Detail News View"
        //swipe-able gesture mungkin nanti disini
    }
    
    func configureDataSource() {
        guard let isConnected = isConnected else { return }
        switch isConnected {
            case true: configureWithNews()
            default: configureWithCoreData()
        }
    }
    
    func configureWithNews() {
        guard let newsResponse = newsResponse else { return }
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
        
        
//        if let headlineSelected = headlineSelected {
//            self.headlineLabel.text = headlineSelected
//        }
//
//        if let snippetSelected = snippetSelected {
//            self.snippetLabel.text = snippetSelected
//        }
//
//        if let dateSelected = dateSelected {
//            let dateConverted = convertDateFormaterToNormal("\(dateSelected)")
//            self.dateLabel.text = dateConverted
//        }
//
//        if let snippetSelected = snippetSelected {
//            self.snippetLabel.text = snippetSelected
//        }
    }
    
    func configureWithCoreData() {
        //coreData
    }
}





extension DetailNewsController {
    
    //Attention!!!! beware with: minimal indexPath & maximal indexPath
    
    func swipeToLeft() {
        //kurangin indexnya terus convert ke current selected headline, snippet, date, imageData
    }
    
    func swipeToRight() {
        //tambahin indexnya terus convert ke current selected headline, snippet, date, imageData
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
