//
//  NewsResponse.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 27/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

struct NewsResponse {
    let newsDocs: [NewsDocs?]
    let newsHeadlines: [NewsHeadline?]
    let newsSnippet: [NewsSnippet?]
    let newsDate: [NewsDate?]
//    let image: [NewsImage?]
    
    
    init?(json : JSON) {
        guard let response = json["response"] as? JSON else { return nil }
        guard let newsDocs = response["docs"] as? arrayJSON else { return nil }
//        guard let responseMultimedia = response["docs"] as? JSON else { return nil }
//         print(responseMultimedia)
//        guard let multimediaArray = responseMultimedia["multimedia"] as? arrayJSON else { return nil }
       
        let responseObjects = newsDocs.map {(NewsDocs(json: $0))}
        self.newsDocs = responseObjects
        
        let headlineObjects = newsDocs.map {(NewsHeadline(json: $0))}
        self.newsHeadlines = headlineObjects
        
        let snippetObjects = newsDocs.map {(NewsSnippet(json: $0))}
        self.newsSnippet = snippetObjects
        
        let dateObjects = newsDocs.map {(NewsDate(json: $0))}
        self.newsDate = dateObjects
        
//        let imageObjects = responseArray.map {(NewsImage(json: $0))}
//        self.image = imageObjects
    }
}
