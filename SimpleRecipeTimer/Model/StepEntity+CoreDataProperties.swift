//
//  StepEntity+CoreDataProperties.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 9/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension StepEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepEntity> {
        return NSFetchRequest<StepEntity>(entityName: "StepEntity")
    }

    @NSManaged public var stepName: String?
    @NSManaged public var isPrimaryPaused: Bool
    @NSManaged public var isPausedPrimary: Bool
    @NSManaged public var isRepeated: Bool
    @NSManaged public var isComplete: Bool
    @NSManaged public var starteDate: NSDate?
    @NSManaged public var expiryDate: NSDate?
    @NSManaged public var totalElapsedTime: Double
    @NSManaged public var recipe: RecipeEntity?

}
