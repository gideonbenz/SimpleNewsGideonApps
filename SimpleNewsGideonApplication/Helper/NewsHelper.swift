//
//  NewsHelper.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 01/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import Foundation
import CoreData

//MARK: ViewDidLoad Functions
extension NewsController {
    
    func configureNavigation() {
        self.navigationItem.title = "Simple News Apps"
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    func configureSourceData() {
        //1. check network
        let connectionStatus = Reachability().checkReachable()
        //2. jika on -> configureNewsService()
        switch connectionStatus {
        case true: configureNewsService()
            isConnected = true
            
        default: configureCoreDataService()
            isConnected = false
        }
        //3. jika off -> configureCoreDataService()
        //4. jika pertama kali diharuskan configureNewsService() tapi karna tdk bisa dimunculin try to reload / tanda offline network
        //5. ini di set untuk di viewDidLoad
    }
    
    func configureNewsService() {
        let newsService = NewsService()
        newsService.getNewsService { (newsResponse) in
            DispatchQueue.main.async {
                self.news = newsResponse
                self.newsTableView.reloadData()
                
                let newsArrayCount = newsResponse!.date.count
                let headlineWrapped = self.wrapHeadlineArrayOfString(arrayMax: newsArrayCount, newsInput: newsResponse)
                let snippetWrapped = self.wrapSnippetArrayOfString(arrayMax: newsArrayCount, newsInput: newsResponse)
                let dateWrapped = self.wrapDateArrayOfString(arrayMax: newsArrayCount, newsInput: newsResponse)
                let imageWrapped = self.wrapImageArrayOfString(arrayMax: newsArrayCount, newsInput: newsResponse)
                
                //convert imagenya jadi binary data baru dibawa ke setCacheCoreDataContainer
                self.getImageBinaryDataArray(imageStringArray: imageWrapped, completion: { (dataNilArray) in
                    self.dispatchGroup.notify(queue: .global(), execute: {
                        
                        self.setCacheCoreDataContainer(inputWrappedHeadlineArray: headlineWrapped, inputWrappedSnippetArray: snippetWrapped, inputWrappedDateArray: dateWrapped, inputWrappedImageArray: self.imageArrayData)
                    })
                })
            }
        }
    }
    
    func configureCoreDataService() {
        fetchCoreData { (newsCoreDatas) in
            self.newsCoreDataArray = newsCoreDatas
            self.newsTableView.reloadData()
        }
    }
    
    func fetchCoreData(completion: ([NewsCore?]) -> Void) {
        //disini fetch with Core Data
        var newsCoreDataValue = [NewsCore?]()
        let fetchRequest: NSFetchRequest<NewsCoredata> = NewsCoredata.fetchRequest()
        do {
            let newsCoreDatas = try PersistenceService.context.fetch(fetchRequest)
            
            for newsCoreData in newsCoreDatas {
                let newsCore = NewsCore(newsCoreData: newsCoreData)
                newsCoreDataValue.append(newsCore)
            }
            completion(newsCoreDataValue)
        } catch { }
    }
    
    func setCacheCoreDataContainer(inputWrappedHeadlineArray: [String?], inputWrappedSnippetArray: [String?], inputWrappedDateArray: [Date?], inputWrappedImageArray: [Data]) {
        
        let firstRun = UserDefaults.standard.bool(forKey: "firstRun") as Bool
        let context = PersistenceService.persistentContainer.viewContext
        if let cacheEntityDescription = NSEntityDescription.entity(forEntityName: "NewsCoredata", in: context) {
            
            //data array
            let countedEachCategoryArray = (inputWrappedHeadlineArray.count + inputWrappedSnippetArray.count + inputWrappedDateArray.count + inputWrappedImageArray.count) / 4
                print("News Network each array count: \(countedEachCategoryArray)")
            
            for i in 0..<countedEachCategoryArray {
                let cache = NSManagedObject(entity: cacheEntityDescription, insertInto: context)
                cache.setValue(inputWrappedHeadlineArray[i], forKey: "headlineCore")
                cache.setValue(inputWrappedSnippetArray[i], forKey: "snippetCore")
                cache.setValue(inputWrappedDateArray[i], forKey: "dateCore")
                cache.setValue(inputWrappedImageArray[i], forKey: "imageCore")
                cache.setValue(i, forKey: "idCore")
                //if firstRun eksekusi ini
                if !firstRun {
                    do {
                        try PersistenceService.saveContext()
                    } catch {}

                    UserDefaults.standard.set(true, forKey: "firstRun")
                }
                else {
                    /*update current Datanya saja*/
                }
            }
        } else {print("failed open cache Entity Description")}
    }
    
    
    
    //MARK: Router Functions
    func currentArrayisNill(wrappedOptionalArray: [Any?]?) -> Bool {
        let wrappedArray = wrappedArrayOpenOptional(wrappedArrayOptionalInput: wrappedOptionalArray)
        let countedArray = countOptionalArrayValue(optionalArray: wrappedArray)
        let currentArrayIsNill = countedValueIsNil(countedValue: countedArray)
        return currentArrayIsNill
    }
    
    func countOptionalArrayValue(optionalArray: [Any?]) -> Int {
        let unwrappedArray = arrayUnwrapped(arrayInput: optionalArray)
        let unwrappedArrayCounted = unwrappedArrayCounter(unwrappedArray: unwrappedArray)
        return unwrappedArrayCounted
    }
}



//MARK: Core Data Functions
extension NewsController {
    
    //MARK: Core Data Delegate Function
    func wrapHeadlineArrayOfString(arrayMax: Int, newsInput: NewsResponse?) -> [String?]{
        var wrappedHeadline = [String?]()
        for i in 0..<arrayMax {
            let headline = newsInput?.headlines[i]?.headline
            wrappedHeadline.append(headline)
        }
        return wrappedHeadline
    }
    
    func wrapSnippetArrayOfString(arrayMax: Int, newsInput: NewsResponse?) -> [String?]{
        var wrappedSnippet = [String?]()
        for i in 0..<arrayMax {
            let snippet = newsInput?.snippet[i]?.snippet
            wrappedSnippet.append(snippet)
        }
        return wrappedSnippet
    }
    
    func wrapDateArrayOfString(arrayMax: Int, newsInput: NewsResponse?) -> [Date?]{
        var wrappedDate = [Date?]()
        for i in 0..<arrayMax {
            let date = newsInput?.date[i]?.date
            wrappedDate.append(date)
        }
        return wrappedDate
    }
    
    func wrapImageArrayOfString(arrayMax: Int, newsInput: NewsResponse?) -> [String?]{
        var wrappedImageString = [String?]()
        for i in 0..<arrayMax {
            let wrappedMultimediaOptionalArray = newsInput?.responses[i]?.multimedia // ini state awal
            let currentImageStringIsNill = currentArrayisNill(wrappedOptionalArray: wrappedMultimediaOptionalArray)
            
            if currentImageStringIsNill == true {
                wrappedImageString.append("")
            } else {
                let imageString = newsInput?.responses[i]?.multimedia[0]?.url
                wrappedImageString.append(imageString)
            }
        }
        return wrappedImageString
    }
    
    func getImageBinaryDataArray(imageStringArray: [String?], completion: @escaping ( ([Int]) -> Void)) {
        let imageStringArrayCounted = imageStringArray.count
        var imageDataNilArray = [Int]()
        for i in 0..<imageStringArrayCounted {
            self.imageArrayData.append(Data())
            if let imageString = imageStringArray[i] {
                if imageString != "" {
                    let urlString = "https://static01.nyt.com/\(imageString)"
                    let url = URL(string: urlString)
                    if let url = url {
                        let request = URLRequest(url: url)
                        let networkProcessor = NetworkProcessor(url: url ,request: request)
                        dispatchGroup.enter()
                        networkProcessor.downloadDataFromURL { (data, response, error) in
                            
                                if let imageData = data {
                                    print(imageData)
                                    self.imageArrayData[i] = imageData
                                    self.dispatchGroup.leave()
                                }
                        }
                    }
                }
                else {
                    imageDataNilArray.append(i)
                    self.imageArrayData[i] = Data()
                }
            }
        }
        dispatchGroup.notify(queue: .global()) {
                completion(imageDataNilArray)
        }
    }
}




