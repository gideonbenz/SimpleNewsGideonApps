//
//  NewsDocs.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 27/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

struct NewsDocs {
    
    let multimedia: [NewsMultimedia?]
    
    private struct DocsKeys {
        static let multimedia = "multimedia"
    }
    
    init?(json : JSON) {
        guard let multimedia = json[DocsKeys.multimedia] as? arrayJSON else { return nil }
        let multimediaObjects = multimedia.map {( NewsMultimedia(json: $0))}
        self.multimedia = multimediaObjects
    }
}
