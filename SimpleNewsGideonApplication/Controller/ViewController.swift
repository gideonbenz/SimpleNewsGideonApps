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
    static let cell = "FrontNewsCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        
        newsService.getNewsService { (newsResponse) in
            DispatchQueue.main.async {
                //debuging data parsed
//                let title = newsResponse?.headlines
//                let snippet = newsResponse?.snippet
//                let date = newsResponse?.date
//                let image = newsResponse?.responses[0]?.multimedia[0]?.url
                self.news = newsResponse
                self.newsTableView.reloadData()
            }
        }
    }
    
    func configureNavigation() {
        self.navigationItem.title = "Simple News Apps"
        newsTableView.dataSource = self
        newsTableView.delegate = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cell, for: indexPath) as! FrontNewsTableViewCell
        
        cell.newsFeed = news
        cell.indexCell = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
