//
//  ViewController.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 26/03/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var News: [CurrentNews]?
    
    let newsService = NewsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsService.getNewsService { (currentNews) in
           
        }
        
    }


}

