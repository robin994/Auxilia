//
//  ReportsHistory+CoreDataProperties.swift
//  iHelp
//
//  Created by Tortora Roberto on 12/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import Foundation
import CoreData


extension ReportsHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReportsHistory> {
        return NSFetchRequest<ReportsHistory>(entityName: "ReportsHistory")
    }

    @NSManaged public var contactIdentifier: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var message: String?

}
