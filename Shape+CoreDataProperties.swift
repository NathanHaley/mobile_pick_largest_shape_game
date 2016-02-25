//
//  Shape+CoreDataProperties.swift
//  GameMaxAreaPicker
//
//  Created by Nathan Haley on 2/23/16.
//  Copyright © 2016 Nathan Haley. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Shape {

    @NSManaged var currentSize: NSNumber?
    @NSManaged var fillColor: String?
    @NSManaged var gameType: String?
    @NSManaged var halfLineWidth: NSNumber?
    @NSManaged var originalSize: NSNumber?
    @NSManaged var outlineColor: String?
    @NSManaged var shapeType: String?
    @NSManaged var sortOrder: NSNumber?

}
