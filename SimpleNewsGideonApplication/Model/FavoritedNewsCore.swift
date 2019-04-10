//
//  favoritedNewsCoreData.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 08/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

struct FavoritedNewsCore {
    let id: Int16?
    let isFavorited: Bool?
    
    init?(favoritedNewsCoreData : Favorite) {
        let id = favoritedNewsCoreData.id
        let isFavorited = favoritedNewsCoreData.isFavorited
        
        self.id = id
        self.isFavorited = isFavorited
    }
}
