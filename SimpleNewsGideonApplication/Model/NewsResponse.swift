//
//  NewsResponse.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 27/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

struct NewsResponse {
    let responses: [NewsDocs?]
    let headlines: [NewsHeadline?]
    let snippet: [NewsSnippet?]
    let date: [NewsDate?]
//    let image: [NewsImage?]
    
    
    init?(json : JSON) {
        guard let response = json["response"] as? JSON else { return nil }
        guard let responseArray = response["docs"] as? arrayJSON else { return nil }
//        guard let responseMultimedia = response["docs"] as? JSON else { return nil }
//         print(responseMultimedia)
//        guard let multimediaArray = responseMultimedia["multimedia"] as? arrayJSON else { return nil }
       
        let responseObjects = responseArray.map {(NewsDocs(json: $0))}
        self.responses = responseObjects
        
        let headlineObjects = responseArray.map {(NewsHeadline(json: $0))}
        self.headlines = headlineObjects
        
        let snippetObjects = responseArray.map {(NewsSnippet(json: $0))}
        self.snippet = snippetObjects
        
        let dateObjects = responseArray.map {(NewsDate(json: $0))}
        self.date = dateObjects
        
//        let imageObjects = responseArray.map {(NewsImage(json: $0))}
//        self.image = imageObjects
    }
}
