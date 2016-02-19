//
//  Game+CoreDataProperties.swift
//  GameMaxAreaPicker
//
//  Created by Nathan Haley on 2/17/16.
//  Copyright © 2016 Nathan Haley. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Game {

    @NSManaged var type: String?
    @NSManaged var score: NSNumber?
    @NSManaged var streak: NSNumber?

}
