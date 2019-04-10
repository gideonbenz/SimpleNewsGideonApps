//
//  NewsControllerExtension.swift
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
        newsSearchBar.delegate = self
    }
    
    func configureSourceData() {
        
        let connectionStatus = Reachability().checkReachable()
        
        switch connectionStatus {
        case true: configureNewsService()
            isConnected = true
            
        default: configureCoreDataService()
            isConnected = false
        }
    }
    
    func configureNewsService() {
        let newsService = NewsService()
        newsService.getNewsService { (newsResponse) in
            DispatchQueue.main.async {
                // ini edit berdasarkan fetch awal
//                self.news = newsResponse
//                self.newsTableView.reloadData()
                
                guard let newsArrayCount = newsResponse?.newsDate.count else { return }
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
            DispatchQueue.main.async {
                self.newsCoreDataArray = newsCoreDatas
                self.newsTableView.reloadData()
            }
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
        } catch {
            //kasi alert errornya apa terserah
            print("request failed")
        }
    }
    
    func updateCoreData(headlineArray: [String?], snippetArray: [String?], dateArray: [Date?], imageArray: [Data], countedArray: Int, completion: ([NewsCore?]) -> Void) {
        //disini fetch with Core Data
        let context = PersistenceService.persistentContainer.viewContext
        let request = NSBatchUpdateRequest(entityName: "NewsCoredata")
        
        for i in 0..<countedArray {
            request.propertiesToUpdate = ["headlineCore": headlineArray[i]]
            request.propertiesToUpdate = ["snippetCore": snippetArray[i]]
            request.propertiesToUpdate = ["dateCore": dateArray[i]]
            request.propertiesToUpdate = ["imageCore": imageArray[i]]
            request.propertiesToUpdate = ["idCore": i]
            request.resultType = .updatedObjectsCountResultType
            
            do {
                try context.execute(request) as! NSBatchUpdateResult
            } catch {}
            
            fetchCoreData { (fetchedCoreData) in
                completion(fetchedCoreData)
            }
        }
        
        /*
         let request = NSBatchUpdateRequest(entityName: "Student")
         request.propertiesToUpdate = ["studentName":"Rajan Maheshwari"]
         request.resultType = .updatedObjectsCountResultType
         
         do {
         let start = currentTimeMillis()
         let result = try context.execute(request) as! NSBatchUpdateResult
         //Will print the number of rows affected/updated
         print(result.result!)
         print("Success")
         print("Difference is \(currentTimeMillis() — start)")
         }catch {
         }
         */
    }
    
    func setCacheCoreDataContainer(inputWrappedHeadlineArray: [String?], inputWrappedSnippetArray: [String?], inputWrappedDateArray: [Date?], inputWrappedImageArray: [Data]) {
        
        let firstRun = UserDefaults.standard.bool(forKey: "firstRun") as Bool
        let context = PersistenceService.persistentContainer.viewContext
        if let cacheEntityDescription = NSEntityDescription.entity(forEntityName: "NewsCoredata", in: context) {
            
            //data array counted
            let countedEachCategoryArray = (inputWrappedHeadlineArray.count + inputWrappedSnippetArray.count + inputWrappedDateArray.count + inputWrappedImageArray.count) / 4
                print("News Network each array count: \(countedEachCategoryArray)")
            
            
                if !firstRun {
                    for i in 0..<countedEachCategoryArray {
                        let cache = NSManagedObject(entity: cacheEntityDescription, insertInto: context)
                        cache.setValue(inputWrappedHeadlineArray[i], forKey: "headlineCore")
                        cache.setValue(inputWrappedSnippetArray[i], forKey: "snippetCore")
                        cache.setValue(inputWrappedDateArray[i], forKey: "dateCore")
                        cache.setValue(inputWrappedImageArray[i], forKey: "imageCore")
                        cache.setValue(i, forKey: "idCore")
                    
                            do {
                                try PersistenceService.saveContext()
                            } catch let error as Error {print("failed SaveContext to Core Data",error)}
                        
                                    fetchCoreData { (newsCoreDatas) in
                                        DispatchQueue.main.async {
                                            self.newsCoreDataArray = newsCoreDatas
                                            self.newsTableView.reloadData()
                                        }
                                    }
                            UserDefaults.standard.set(true, forKey: "firstRun")
                            }
                }
                else {
                    updateCoreData(headlineArray: inputWrappedHeadlineArray, snippetArray: inputWrappedSnippetArray, dateArray: inputWrappedDateArray, imageArray: inputWrappedImageArray, countedArray: countedEachCategoryArray) { (updatedCoredata) in
                        DispatchQueue.main.async {
                            self.newsCoreDataArray = updatedCoredata
                            self.newsTableView.reloadData()
                        }
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
            let headline = newsInput?.newsHeadlines[i]?.headline
            wrappedHeadline.append(headline)
        }
        return wrappedHeadline
    }
    
    func wrapSnippetArrayOfString(arrayMax: Int, newsInput: NewsResponse?) -> [String?]{
        var wrappedSnippet = [String?]()
        for i in 0..<arrayMax {
            let snippet = newsInput?.newsSnippet[i]?.snippet
            wrappedSnippet.append(snippet)
        }
        return wrappedSnippet
    }
    
    func wrapDateArrayOfString(arrayMax: Int, newsInput: NewsResponse?) -> [Date?]{
        var wrappedDate = [Date?]()
        for i in 0..<arrayMax {
            let date = newsInput?.newsDate[i]?.date
            wrappedDate.append(date)
        }
        return wrappedDate
    }
    
    func wrapImageArrayOfString(arrayMax: Int, newsInput: NewsResponse?) -> [String?]{
        var wrappedImageString = [String?]()
        for i in 0..<arrayMax {
            let wrappedMultimediaOptionalArray = newsInput?.newsDocs[i]?.multimedia // ini state awal
            let currentImageStringIsNill = currentArrayisNill(wrappedOptionalArray: wrappedMultimediaOptionalArray)
            
            if currentImageStringIsNill == true {
                wrappedImageString.append("")
            } else {
                let imageString = newsInput?.newsDocs[i]?.multimedia[0]?.url
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




