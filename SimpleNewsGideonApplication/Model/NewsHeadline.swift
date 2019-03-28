//
//  NewsHeadline.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 27/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

struct NewsHeadline {
    let headline: String

    private struct HeadlineKeys {
        static let headlines = "headline"
        static let headline = "main"
    }
    
    init?(json : JSON) {
        guard let headlines = json[HeadlineKeys.headlines] as? JSON else { return nil }
        guard let headline = headlines[HeadlineKeys.headline] as? String else { return nil }
        self.headline = headline
    }
}
