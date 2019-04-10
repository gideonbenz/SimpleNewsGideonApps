//
//  Favorite+CoreDataProperties.swift
//  SimpleNewsGideonApplication
//
//  Created by Gideon Benz on 06/04/19.
//  Copyright © 2019 Gideon Benz. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var isFavorited: Bool
    @NSManaged public var id: Int16

}
