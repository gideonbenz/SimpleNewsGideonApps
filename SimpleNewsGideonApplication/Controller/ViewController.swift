//
//  ViewController.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 26/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    var news: NewsResponse?
    let newsService = NewsService()
    
    private struct Storyboard {
    static let frontNewscell = "FrontNewsCell"
    static let newsCellNonImage = "NewsCellNonImage"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureNewsService()
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = news {
            let newsCount = (news.date).count
            return newsCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let multimediaArray = news!.responses[indexPath.row]!.multimedia
       
        let cellStructureWithoutImage = structuringTableViewCellWithImage(multimediaArray: multimediaArray)
        
        if cellStructureWithoutImage == true {
            let nonImagecell = tableView.dequeueReusableCell(withIdentifier: Storyboard.newsCellNonImage, for: indexPath) as! NewsCellNonImageTVCell
            
            nonImagecell.newsFeed = news
            nonImagecell.indexCell = indexPath.row
            nonImagecell.selectionStyle = .none
            return nonImagecell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.frontNewscell, for: indexPath) as! FrontNewsTVCell
            
            cell.newsFeed = news
            cell.indexCell = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.newsTableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


//MARK: ViewDidLoad Functions
extension ViewController {
    
    private func configureNavigation() {
        self.navigationItem.title = "Simple News Apps"
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    private func configureNewsService() {
        newsService.getNewsService { (newsResponse) in
            DispatchQueue.main.async {
                //debuging newsResponse
//                let title = newsResponse?.headlines
//                let snippet = newsResponse?.snippet
//                let date = newsResponse?.date
//                let image = newsResponse?.responses[1]?.multimedia[0]?.url
//        ------------------------------------------------------------------
                self.news = newsResponse
                self.newsTableView.reloadData()
            }
        }
    }
}


//MARK: TableView Functions
extension ViewController {
    
    //MARK: Table View Router Functions
    private func structuringTableViewCellWithImage(multimediaArray: [NewsMultimedia?]) -> Bool{
        //unwrap array
        let unwrappedArray = arrayUnwrapped(arrayInput: multimediaArray)
        //count array
        let unwrappedArrayCounted = unwrappedArrayCounter(unwrappedArray: unwrappedArray)
        //count DataIsNil
        let cellStructureWithoutImage = countedValueIsNil(countedValue: unwrappedArrayCounted)
        //return Bool
        return cellStructureWithoutImage
    }
    
    //MARK: Table View Execution Functions
    private func arrayUnwrapped(arrayInput: [Any?]) -> [Any] {
        let arrayUnwrapped = arrayInput.compactMap { $0 }
        return arrayUnwrapped
    }
   
    private func unwrappedArrayCounter(unwrappedArray: [Any]) -> Int {
        let arrayCountedValue = unwrappedArray.count
        return arrayCountedValue
    }
    
    private func countedValueIsNil (countedValue: Int) -> Bool {
        switch countedValue {
        case 0: return true
        default: return false
        }
    }
    
    /*
     //2. buka news Multimedia array-nya -- ini bisa di parsing ke function - berarti ini akan melakukan function 3 lalu melakukan function 4 (datanya yang dibutuhkan NewsMultimedia array?)
     //3. count news Multimedia array-nya ini bisa di parsing ke function
     //4. masukkin hasilnya ke function countData
     */
}
