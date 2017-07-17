//
//  TopicsIscritto+CoreDataProperties.swift
//  iHelp
//
//  Created by Cirillo Stefano on 17/07/17.
//  Copyright © 2017 The Round Table. All rights reserved.
//
//

import Foundation
import CoreData


extension TopicsIscritto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopicsIscritto> {
        return NSFetchRequest<TopicsIscritto>(entityName: "TopicsIscritto")
    }

    @NSManaged public var topic: String?

}
