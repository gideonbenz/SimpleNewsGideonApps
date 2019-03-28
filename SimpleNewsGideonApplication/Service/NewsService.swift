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
    
    func getNewsService(completion: @escaping (CurrentNews?) -> Void) {
        if let newsURL = URL(string: "\(newsBaseURL!)") {
            
            let networkProcessor = NetworkProcessor(url: newsURL)
            networkProcessor.downloadJSONFromURL { (jsonResponse) in
                if let json = jsonResponse {
                    
                    //this is my first attempt on try to parse json with model
                    let newsResponse = NewsResponse(json: json)
                    
                    //parsing from model to CurrentNews here
                    
                    let headlineNews = newsResponse?.headlines
                    let snippetNews = newsResponse?.snippet
                    let dateNews = newsResponse?.date
                    
//                    let image0 = newsResponse?.responses[0]?.multimedia[0]?.url
//                    let image1 = newsResponse?.responses[1]?.multimedia[0]?.url
//                    let image2 = newsResponse?.responses[2]?.multimedia[0]?.url
//                    let image3 = newsResponse?.responses[3]?.multimedia[0]?.url
//                    let image4 = newsResponse?.responses[4]?.multimedia[0]?.url
//                    let image5 = newsResponse?.responses[5]?.multimedia[0]?.url
//                    let image6 = newsResponse?.responses[6]?.multimedia[0]?.url
//                    -----------------------------------------------------------
//                    let image7 = newsResponse?.responses[7]?.multimedia[0]?.url
//                    let image8 = newsResponse?.responses[8]?.multimedia[0]?.url
//                    let image9 = newsResponse?.responses[9]?.multimedia[0]?.url
                    
//                    let imageNews = [image0, image1, image2, image3, image4, image5, image6]
                    
//                    print(imageNews)
                    
//                    let currentNews = CurrentNews(title: headlineNews, snippet: snippetNews, image: [""], date: dateNews)
                    
                    
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
