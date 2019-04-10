//
//  NewsViewModel.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 10/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

class NewsViewModel {
    var news: NewsResponse?
    var newsCoreDataArray = [NewsCore?]()
    var newsCoreSearching = [NewsCore]()
    var isConnected = false
    var isSearching = false
    var selectedIndexPath: Int?
    let dispatchGroup = DispatchGroup()
    var imageArrayData = [Data]()
    
    
}



