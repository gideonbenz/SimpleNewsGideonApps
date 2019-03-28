//
//  NewsImage.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 28/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation


struct NewsImage {
//    let rank: Int
//    let subtype: String
//    let type: String
//    let url: String
//    let height: Int
//    let width: Int
    
//    let multimedias: [NewsImage?]
    
    private struct MultimediaKeys {
        static let rank = "rank"
        static let subType = "subtype"
        static let type = "type"
        static let url = "url"
        static let height = "height"
        static let width = "width"
        
        static let multimedia = "multimedia"
    }
    
    init?(json : JSON) {
        
        
        guard let multimedia = json[MultimediaKeys.multimedia] as? arrayJSON else { return nil }
        print(multimedia)
//        let multimediaObjects = multimedia.map {( NewsImage(json: $0))}
//        self.multimedias = multimediaObjects
        
//        guard let rank = json[MultimediaKeys.rank] as? Int,
//            let subtype = json[MultimediaKeys.subType] as? String,
//            let type = json[MultimediaKeys.type] as? String,
//            let urlString = json[MultimediaKeys.url] as? String,
//            let height = json[MultimediaKeys.height] as? Int,
//            let width = json[MultimediaKeys.width] as? Int
//            else { return nil }
//
//        self.rank = rank
//        self.subtype = subtype
//        self.type = type
//        self.url = urlString
//        self.height = height
//        self.width = width
    }
}
