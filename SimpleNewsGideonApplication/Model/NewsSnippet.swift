//
//  NewsSnippet.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 28/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

struct NewsSnippet {
    let snippet: String
    
    private struct NewsSnippet {
        static let snippet = "snippet"
    }
    
    init?(json : JSON) {
        guard let snippet = json[NewsSnippet.snippet] as? String else { return nil }
        self.snippet = snippet
    }
}
