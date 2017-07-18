//
//  ClinicalFolderData+CoreDataProperties.swift
//  iHelp
//
//  Created by Tortora Roberto on 18/07/2017.
//  Copyright © 2017 The Round Table. All rights reserved.
//

import Foundation
import CoreData


extension ClinicalFolderData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClinicalFolderData> {
        return NSFetchRequest<ClinicalFolderData>(entityName: "ClinicalFolderData")
    }

    @NSManaged public var bloodType: String?
    @NSManaged public var dateB: String?
    @NSManaged public var heartRate: String?
    @NSManaged public var height: String?
    @NSManaged public var sex: String?
    @NSManaged public var skin: String?
    @NSManaged public var weight: String?
    @NSManaged public var wheelchair: String?

}
