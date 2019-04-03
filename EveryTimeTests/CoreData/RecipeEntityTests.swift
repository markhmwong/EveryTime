//
//  RecipeEntityTests.swift
//  EveryTimeTests
//
//  Created by Mark Wong on 3/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import XCTest
@testable import EveryTime

class RecipeEntityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        CoreDataHandler.loadContext()
        
    }
    override func tearDown() { // Put teardown code here. This method is //called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCreateRecipe() {
        let recipeEntity = RecipeEntity(name: "Test Entity")
//        let stepEntity = StepEntity(name: "Test Step", hours: 1, minutes: 1, seconds: 1, priority: Int16(0))
//        recipeEntity.addToStep(stepEntity)
        
        XCTAssertNotNil(recipeEntity)
    }
    
    func testDoesRecipeExistInPersistantStore() {
        let recipeEntity = RecipeEntity(name: "Test Entity")
        let stepEntity = StepEntity(name: "Test Step", hours: 1, minutes: 1, seconds: 1, priority: Int16(0))
        recipeEntity.addToStep(stepEntity)
        CoreDataHandler.saveContext()
        let entity = CoreDataHandler.fetchByDate(in: RecipeEntity.self, date: recipeEntity.createdDate!)
        
        XCTAssertNotNil(entity)
    }
    
    func testDeleteRecipe() {
        let recipeEntity = RecipeEntity(name: "Test Entity")
        let stepEntity = StepEntity(name: "Test Step", hours: 1, minutes: 1, seconds: 1, priority: Int16(0))
        recipeEntity.addToStep(stepEntity)
        CoreDataHandler.saveContext()
        let createdDate = recipeEntity.createdDate!
        let entity = CoreDataHandler.fetchByDate(in: RecipeEntity.self, date: createdDate)
        
        if (entity != nil && entity?.createdDate == createdDate) {
            CoreDataHandler.deleteEntity(entity: RecipeEntity.self, createdDate: createdDate)
            let entity = CoreDataHandler.fetchByDate(in: RecipeEntity.self, date: createdDate)
            XCTAssertNil(entity)
        }
    }
}

