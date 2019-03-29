//
//  NewsService.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 26/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

typealias arrayJSON = [[String : Any]]
typealias JSON = [String : Any]

class NewsService {
    //Sample url https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=Azx9wpoQ8xou8ViWLZQjn6vnYOJIARPg
    
    let newsAPIKey: String
    let newsBaseURL: URL?
    
    init() {
        newsAPIKey = "Azx9wpoQ8xou8ViWLZQjn6vnYOJIARPg"
        newsBaseURL = URL(string: "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=\(newsAPIKey)")
    }
    
    func getNewsService(completion: @escaping (NewsResponse?) -> Void) {
        if let newsURL = URL(string: "\(newsBaseURL!)") {
            let request = URLRequest(url: newsURL)
            let networkProcessor = NetworkProcessor(url: newsURL, request: request)
            
            networkProcessor.downloadJSONFromURL { (jsonResponse) in
                if let json = jsonResponse {
                    
                    //this is my first attempt on try to parse json with model
                    let newsResponse = NewsResponse(json: json)
                    
                    //parsing from model to CurrentNews here
                    
                    let headlineNews = newsResponse?.headlines
                    let snippetNews = newsResponse?.snippet
                    let dateNews = newsResponse?.date
                    completion(newsResponse)
                    
//                    let image = newsResponse?.responses[0]?.multimedia[0]
//                    let image = newsResponse?.responses
                   
//          ------------------------------------------------------------------------------------
                    
                    //after this is the real one
//                    let currentNews = CurrentNews(json: json)
                    
                } else {completion(nil)
                    print("response dictionary casting problem")
                }
            }
        }
    }
}
