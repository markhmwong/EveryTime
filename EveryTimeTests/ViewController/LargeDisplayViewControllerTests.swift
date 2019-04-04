//
//  LargeDisplayViewController.swift
//  EveryTimeTests
//
//  Created by Mark Wong on 4/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import XCTest

@testable import EveryTime

class LargeDisplayViewControllerTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
    
    func testRecipeLabel() {
        let time = "input time"
        let step = "input step"
        let recipe = "input recipe"
        
        let viewController = LargeDisplayViewController(nibName: nil, bundle: nil)
        let mainView = LargeDisplayMainView(delegate: viewController)
        let viewModel = LargeDisplayViewModel(delegate: viewController, time: time, step: step, recipe: recipe)
        viewController.mainView = mainView
        viewController.viewModel = viewModel
        
        viewController.mainView.updateRecipeLabel(currRecipe: recipe) {
            XCTAssertEqual(recipe, viewController.mainView.recipeLabel.attributedText?.string)
        }
    }
    
    func testTimeLabel() {
        let time = "input time"
        let step = "input step"
        let recipe = "input recipe"
        
        let viewController = LargeDisplayViewController(nibName: nil, bundle: nil)
        let mainView = LargeDisplayMainView(delegate: viewController)
        let viewModel = LargeDisplayViewModel(delegate: viewController, time: time, step: step, recipe: recipe)
        viewController.mainView = mainView
        viewController.viewModel = viewModel
        
        viewController.mainView.updateTimeLabel(currTime: time) {
            XCTAssertEqual(time, viewController.mainView.timeLabel.attributedText?.string)
        }
    }
    
    func testStepLabel() {
        let time = "input time"
        let step = "input step"
        let recipe = "input recipe"
        
        let viewController = LargeDisplayViewController(nibName: nil, bundle: nil)
        let mainView = LargeDisplayMainView(delegate: viewController)
        let viewModel = LargeDisplayViewModel(delegate: viewController, time: time, step: step, recipe: recipe)
        viewController.mainView = mainView
        viewController.viewModel = viewModel
        
        viewController.mainView.updateStepLabel(currStep: step) {
            XCTAssertEqual(step, viewController.mainView.stepLabel.attributedText?.string)
        }
    }
}
