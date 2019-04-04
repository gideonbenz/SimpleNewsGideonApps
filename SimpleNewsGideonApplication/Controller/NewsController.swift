//
//  NewsController.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 26/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class NewsController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    var news: NewsResponse?
    var newsCoreDataArray = [NewsCore?]()
    var isConnected = Bool()
    var selectedIndexPath: Int?
    let dispatchGroup = DispatchGroup()
    var imageArrayData = [Data]()
    
    private struct Storyboard {
    static let frontNewscell = "FrontNewsCell"
    static let newsCellNonImage = "NewsCellNonImage"
    static let detailNewsSegueIdentifier = "DetailNews"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureSourceData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.detailNewsSegueIdentifier {
            let detailNewsController = segue.destination as! DetailNewsController
            
            detailNewsController.isConnected = isConnected
            
            if let news = news {
                detailNewsController.newsResponse = news
            } else { print("failed pass newsResponse") }
            
            detailNewsController.newsCore = newsCoreDataArray
            
            if let selectedIndexPath = selectedIndexPath {
                detailNewsController.selectedIndexPath = selectedIndexPath
            } else { print("failed pass selectedIndexPath") }
            
        } else { print("bukan segue detail") }
    }
}

extension NewsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isConnected {
            case true: if let newsDate = news?.date {
                return countOptionalArrayValue(optionalArray: newsDate)
            }
            default: return newsCoreDataArray.count
            }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isConnected == true {
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
        } else {
            if let newsImage = newsCoreDataArray[indexPath.row]?.image {
                if newsImage == Data() {
                    let nonImageCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.newsCellNonImage, for: indexPath) as! NewsCellNonImageTVCell

                    nonImageCell.newsCoreDataFeed = newsCoreDataArray[indexPath.row]
                    nonImageCell.selectionStyle = .none

                    return nonImageCell

                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.frontNewscell, for: indexPath) as! FrontNewsTVCell

                    cell.newsCoreDataFeed = newsCoreDataArray[indexPath.row]
                    cell.selectionStyle = .none

                    return cell
                }
            }

        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: Storyboard.detailNewsSegueIdentifier, sender: prepare)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.newsTableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}



