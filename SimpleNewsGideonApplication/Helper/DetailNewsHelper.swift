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
    }
}





extension DetailNewsController {
    
    //Attention!!!! beware with: minimal indexPath & maximal indexPath
    
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
        //kurangin indexnya terus convert ke current selected headline, snippet, date, imageData
        print("swiped left")
        guard let newsCore = newsCore else { return }
        guard let selectedIndexPath = selectedIndexPath else { return }
        if selectedIndexPath > 0 {
            var navigateIndexPath = selectedIndexPath - 1
            
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
            var navigateIndexPath = selectedIndexPath + 1
            
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
