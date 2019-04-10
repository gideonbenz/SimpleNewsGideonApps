//
//  NewsCoredata+CoreDataClass.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 02/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//
//

import Foundation
import CoreData


public class NewsCoredata: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCoredata> {
        return NSFetchRequest<NewsCoredata>(entityName: "NewsCoredata")
    }
    
    @NSManaged public var dateCore: NSDate?
    @NSManaged public var headlineCore: String?
    @NSManaged public var idCore: Int16
    @NSManaged public var imageCore: NSData?
    @NSManaged public var snippetCore: String?
}
