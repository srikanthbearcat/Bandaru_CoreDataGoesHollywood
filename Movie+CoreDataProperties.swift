//
//  Movie+CoreDataProperties.swift
//  Bandaru_CoreDataGoesHollywood
//
//  Created by sreekanth b on 11/6/16.
//  Copyright © 2016 sreekanth bandaru. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie {

    @NSManaged var title: String?
    @NSManaged var cost: NSNumber?
    @NSManaged var releaseYear: NSNumber?
    @NSManaged var director: NSManagedObject?

}
