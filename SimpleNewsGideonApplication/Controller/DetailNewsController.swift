//
//  DetailNewsController.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 04/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//

import UIKit

class DetailNewsController: UIViewController {
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    
    var newsResponse: NewsResponse?
    var newsCore: [NewsCore?]?
    var isConnected: Bool?
    var imageArrayData = [Data]()
    
    var headlineSelected: String?
    var snippetSelected: String?
    var dateSelected: Date?
    var imageSelected: Data?
    
    var selectedIndexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureDataSource()
    }
}
