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
    
    
    //function ini hanya digunakan jikalau ada network!!!!
    func configureNewsService() {
        newsService.getNewsService { (newsResponse) in
            DispatchQueue.main.async {
                self.news = newsResponse
                self.newsTableView.reloadData()
                
                let newsArrayCount = newsResponse!.date.count
                let headlineWrapped = self.wrapHeadlineArrayOfString(arrayMax: newsArrayCount, newsInput: newsResponse)
                let snippetWrapped = self.wrapSnippetArrayOfString(arrayMax: newsArrayCount, newsInput: newsResponse)
                let dateWrapped = self.wrapDateArrayOfString(arrayMax: newsArrayCount, newsInput: newsResponse)
                let imageWrapped = self.wrapImageArrayOfString(arrayMax: newsArrayCount, newsInput: newsResponse)
                
                self.setCacheCoreDataContainer(inputWrappedHeadlineArray: headlineWrapped, inputWrappedSnippetArray: snippetWrapped, inputWrappedDateArray: dateWrapped, inputWrappedImageArray: imageWrapped)
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
    
    func setCacheCoreDataContainer(inputWrappedHeadlineArray: [String?], inputWrappedSnippetArray: [String?], inputWrappedDateArray: [Date?], inputWrappedImageArray: [String?]) {
        
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
//                do {
//                    try PersistenceService.saveContext()
//                } catch {}
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
}



//MARK: TableView Functions
extension NewsController {
    
    //MARK: Table View Router Functions
    func structuringTableViewCellWithImage(multimediaArray: [NewsMultimedia?]) -> Bool{
        let unwrappedArray = arrayUnwrapped(arrayInput: multimediaArray)
        let unwrappedArrayCounted = unwrappedArrayCounter(unwrappedArray: unwrappedArray)
        let cellStructureWithoutImage = countedValueIsNil(countedValue: unwrappedArrayCounted)
        return cellStructureWithoutImage
    }
    
    //MARK: Execution Functions
    func wrappedArrayOpenOptional(wrappedArrayOptionalInput: [Any?]?) -> [Any?] {
        guard let arrayWrapped = wrappedArrayOptionalInput else { return [""] }
        return arrayWrapped
    }
    
    func arrayUnwrapped(arrayInput: [Any?]) -> [Any] {
        let arrayUnwrapped = arrayInput.compactMap { $0 }
        return arrayUnwrapped
    }
    
    func unwrappedArrayCounter(unwrappedArray: [Any]) -> Int {
        let arrayCountedValue = unwrappedArray.count
        return arrayCountedValue
    }
    
    func countedValueIsNil (countedValue: Int) -> Bool {
        switch countedValue {
        case 0: return true
        default: return false
        }
    }
}
