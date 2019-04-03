//
//  StepEntityTests.swift
//  EveryTimeTests
//
//  Created by Mark Wong on 3/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import XCTest
@testable import EveryTime

class StepEntityTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        CoreDataHandler.loadContext()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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

    func testAddStepToRecipe() {
        let recipeEntity = RecipeEntity(name: "Test Entity")
        let stepEntity = StepEntity(name: "Test Step", hours: 1, minutes: 1, seconds: 1, priority: Int16(0))
        recipeEntity.addToStep(stepEntity)
        
        let arr = recipeEntity.sortStepsByDate()
        
        XCTAssertEqual(1, arr.count)
    }
    
    func testAddMultipleStepToRecipe() {
        let recipeEntity = RecipeEntity(name: "Test Entity")
        let stepEntity = StepEntity(name: "Test Step", hours: 1, minutes: 1, seconds: 1, priority: Int16(0))
        recipeEntity.addToStep(stepEntity)
        let stepEntity2 = StepEntity(name: "Test Step2", hours: 1, minutes: 1, seconds: 1, priority: Int16(0))
        recipeEntity.addToStep(stepEntity2)
        let arr = recipeEntity.sortStepsByDate()
        
        XCTAssertGreaterThan(arr.count, 1)
    }
    
    func testRemoveSteps() {
        let stepName2 = "Test Step2"
        let recipeEntity = RecipeEntity(name: "Test Entity")
        let stepEntity = StepEntity(name: "Test Step", hours: 1, minutes: 1, seconds: 1, priority: Int16(0))
        recipeEntity.addToStep(stepEntity)
        let stepEntity2 = StepEntity(name: stepName2, hours: 1, minutes: 1, seconds: 1, priority: Int16(0))
        recipeEntity.addToStep(stepEntity2)
        
        recipeEntity.removeFromStep(stepEntity2)
        
        let arr = recipeEntity.sortStepsByDate()
        var doesExist = false
        for entity in arr {
            if (entity.stepName == stepName2) {
                doesExist = true
            }
        }
        
        XCTAssertFalse(doesExist)
    }
}
