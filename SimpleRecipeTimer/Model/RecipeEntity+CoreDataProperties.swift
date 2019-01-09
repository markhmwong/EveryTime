//
//  RecipeEntity+CoreDataProperties.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 9/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var recipeName: String?
    @NSManaged public var isPaused: Bool
    @NSManaged public var totalElapsedTime: Double
    @NSManaged public var expiryDate: NSDate?
    @NSManaged public var step: NSSet?

}

// MARK: Generated accessors for step
extension RecipeEntity {

    @objc(addStepObject:)
    @NSManaged public func addToStep(_ value: StepEntity)

    @objc(removeStepObject:)
    @NSManaged public func removeFromStep(_ value: StepEntity)

    @objc(addStep:)
    @NSManaged public func addToStep(_ values: NSSet)

    @objc(removeStep:)
    @NSManaged public func removeFromStep(_ values: NSSet)

}
