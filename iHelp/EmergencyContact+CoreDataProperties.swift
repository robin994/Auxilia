//
//  EmergencyContact+CoreDataProperties.swift
//  iHelp
//
//  Created by Tortora Roberto on 11/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import Foundation
import CoreData


extension EmergencyContact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmergencyContact> {
        return NSFetchRequest<EmergencyContact>(entityName: "EmergencyContact")
    }

    @NSManaged public var contactIdentifier: String?
    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var number: String?

}
