//
//  NetworkProcessor.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 26/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation

//MARK: Link Sample
//example from LinkAja
//https://api.nytimes.com/svc/search/v2/articlesearch.json?api-key=9b693ffaa5fe451090146e5c90fbed78&q=indonesia&page=0

//API method
//https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=yourkey

//my URL
//https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=Azx9wpoQ8xou8ViWLZQjn6vnYOJIARPg

//API key Azx9wpoQ8xou8ViWLZQjn6vnYOJIARPg
//Secret key n17ZSueq74uwL501

public let NetworkingErrorDomain = "\(Bundle.main.bundleIdentifier!).NetworkingError"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20

class NetworkProcessor {
    let url : URL
    let request: URLRequest
    
    lazy var configuration : URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session : URLSession = URLSession(configuration: self.configuration)
    
    init(url : URL, request : URLRequest) {
        self.url = url
        self.request = request
    }
    
    typealias JSON = (([String : Any]?) -> Void)
    typealias JSONHandler = (JSON?, HTTPURLResponse?, Error?) -> Void
    typealias DataHandler = (Data?, HTTPURLResponse?, Error?) -> Void
    
    func downloadJSONFromURL (_ completion: @escaping JSON) {
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse{
                    switch httpResponse.statusCode {
                        
                    case 200: if let data = data {
                        do {
                            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                            completion(jsonDictionary)
                            
                        } catch let error as NSError {
                            print("Error processing json data: \(error.localizedDescription)")}
                    }
                        
                    default: print("HTTP Response Code: \(httpResponse.statusCode)")
                    }
                }
            } else {print("Error processing dataTask: \(String(describing: error?.localizedDescription))")}
        }
        dataTask.resume()
    }
    
    func downloadDataFromURL (_ completion: @escaping DataHandler) {
        let dataTask = session.dataTask(with: self.request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("Missing HTTP Response", comment: "")]
                let error = NSError(domain: NetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error as Error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, httpResponse, error)
                }
            } else {
                switch httpResponse.statusCode {
                case 200:
                    completion(data, httpResponse, nil)
                default:
                    print("Received HTTP response code: \(httpResponse.statusCode) - was not handled in NetworkingProcessor.swift")
                }
            }
        }
        dataTask.resume()
    }
}

