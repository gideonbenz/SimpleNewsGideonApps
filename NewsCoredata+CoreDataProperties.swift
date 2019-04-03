//
//  NewsCoredata+CoreDataProperties.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 03/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsCoredata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCoredata> {
        return NSFetchRequest<NewsCoredata>(entityName: "NewsCoredata")
    }

    @NSManaged public var dateCore: NSDate?
    @NSManaged public var headlineCore: String?
    @NSManaged public var idCore: Int16
    @NSManaged public var imageCore: String?
    @NSManaged public var snippetCore: String?

}
