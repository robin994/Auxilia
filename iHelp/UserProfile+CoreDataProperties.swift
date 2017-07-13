//
//  UserProfile+CoreDataProperties.swift
//  iHelp
//
//  Created by Tortora Roberto on 13/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var isSet: Bool
    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var address: String?
    @NSManaged public var userPhoto: NSData?

}
