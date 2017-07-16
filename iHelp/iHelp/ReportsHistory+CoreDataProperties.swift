//
//  ReportsHistory+CoreDataProperties.swift
//  iHelp
//
//  Created by Tortora Roberto on 16/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import Foundation
import CoreData


extension ReportsHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReportsHistory> {
        return NSFetchRequest<ReportsHistory>(entityName: "ReportsHistory")
    }

    @NSManaged public var audioMessage: NSData?
    @NSManaged public var birthday: String?
    @NSManaged public var bloodGroup: String?
    @NSManaged public var contactIdentifier: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var hearthrate: String?
    @NSManaged public var height: String?
    @NSManaged public var isMine: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var message: String?
    @NSManaged public var name: String?
    @NSManaged public var sesso: String?
    @NSManaged public var velocity: Double
    @NSManaged public var weight: String?
    @NSManaged public var wheelchair: String?
    @NSManaged public var fototipo: String?

}
