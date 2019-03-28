//
//  NewsDate.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 28/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

struct NewsDate {
    
    let date: Date?
    let dateFormatter = DateFormatter()
    
    private struct DateKeys {
        static let date = "pub_date"
    }
    
    init?(json : JSON) {
        guard let dateString = json[DateKeys.date] as? String else { return nil }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        self.date = dateFormatter.date(from: dateString)
    }
}
