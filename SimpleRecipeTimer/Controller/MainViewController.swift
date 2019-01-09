//
//  ViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 28/11/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import SwipeCellKit

enum RecipeCollection: Error {
    case invalidIndex
}

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TimerProtocol {
    
    var cellTag = ["1", "2", "3", "4"]
    let recipeCellId = "RecipeCellId"
    var recipeCollection: [Recipe] = []
    var indexPathNumber = 0
    var timer: Timer?

    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
//        view.dragDelegate = self
        view.dragInteractionEnabled = true
        view.backgroundColor = UIColor.StandardTheme.Recipe.Background
        return view
    }()
    
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = self.cellTag[indexPath.row]
//        let itemProvider = NSItemProvider(object: item as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.present(UINavigationController(rootViewController: RecipeViewController(recipe: recipeCollection[indexPath.item], delegate: self)), animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeCollection.count
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCellId, for: indexPath) as! RecipeCell
        cell.delegate = self //swipe view
        cell.mainViewController = self
        cell.recipe = recipeCollection[indexPath.row]
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 5.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    
    //MARK: - ViewController Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareCollectionView()
        self.startTimer()

        self.testCoreData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimer()
    }
    
    func prepareCollectionView() {
        self.view.addSubview(collView)
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddRecipe))
        
        //register cells
        self.collView.register(RecipeCell.self, forCellWithReuseIdentifier: recipeCellId)
    }
    
    //MARK: - UI
    @objc func handleAddRecipe() throws {
        self.navigationController?.present(UINavigationController(rootViewController: AddRecipeViewController(delegate: self)), animated: true, completion: nil)
        
//        indexPathNumber = 1 + indexPathNumber //just a test variable
        
        //multiple recipes
//        var stepArr: [Step] = []
//        for index in stride(from:0, to:3, by:1) {
//            stepArr.append(Step(hours: 0, minutes: 60, seconds: 5, name: "Step No. \(index)", index: index))
//        }
        

        
        //single recipe
//        let newRecipe = Recipe(withSampleStep: Step(hours: 1, minutes: 0, seconds: 10, name: "Test Step"), indexPathNumber: indexPathNumber)
//        let newRecipe = Recipe(withMultipleSteps: stepArr)
//        let start = Date()
//        newRecipe.updateElapsedTimeToShortestElapsedTime()
//        let (h,m,s) = newRecipe.totalElapsedTime.secondsToHoursMinutesSeconds()
//        let end = Date()
//        newRecipe.updateExpiryTime()
        
        //performbatchupdate
//        recipeCollection.append(newRecipe)
//        collView.insertItems(at: [IndexPath(item: recipeCollection.count - 1, section: 0)])
    }
    
    func willReloadTableData() {
//        self.collView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        self.collView.reloadData()
    }
    
    // must be paused at all layers
    func pauseEntireRecipe(recipe: Recipe) {
        recipe.pauseStepArr()
    }
    
    func unpauseEntireRecipe(recipe: Recipe) {
        recipe.unpauseStepArr()
        print("unpauseEntireRecipe")
    }
    
    //MARK: Timer Protocol
    func startTimer() {
        if (timer == nil) {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    func stopTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func update() {
        let cells = self.collView.visibleCells as! [RecipeCell]
        for cell in cells {
            if let r = cell.recipe {
                if (!r.isPaused) {
                    r.updateRecipeElapsedTime()
                    cell.updateTimeLabel()
                }
            }
        }
    }
    
    func addToRecipeCollection(r: Recipe) {
        recipeCollection.append(r)
    }
    
    func addToCollectionView() {
        collView.insertItems(at: [IndexPath(item: recipeCollection.count - 1, section: 0)])
    }
    
    func testCoreData() {
        CoreDataHandler.loadContext()
//        CoreDataHandler.save()
//        let r = RecipeEntity(context: CoreDataHandler.getContext())
//        r.date = Date() as NSDate
//        r.recipeName = "recipeNameThree"
//        CoreDataHandler.saveEntity()
//        CoreDataHandler.fetchEntity(in: RecipeEntity.self)
//        CoreDataHandler.printAllRecordsIn(entity: RecipeEntity.self)
//        let deleteStatus = CoreDataHandler.deleteAllRecordsIn(entity: RecipeEntity.self)
//        print("deleteStatus \(deleteStatus)")
        CoreDataHandler.printAllRecordsIn(entity: StepEntity.self)
    }
}

extension MainViewController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    
        if orientation == .right {
            let deleteAction = SwipeAction(style: .default, title: "Delete") { (action, indexPath) in
                //delete
            }
            // customize the action appearance
            deleteAction.title = "delete"
            deleteAction.backgroundColor = UIColor(red:0.96, green:0.52, blue:0.52, alpha:1.0)
            return [deleteAction]
        } else {
            let pauseAction = SwipeAction(style: .default, title: "Pause") { action, indexPath in
                // handle action by updating model with deletion
                self.pauseHandler(index: indexPath)
            }
            
            // customize the action appearance
            pauseAction.title = "pause"
            pauseAction.backgroundColor = UIColor(red:0.86, green:0.84, blue:0.40, alpha:1.0)
            return [pauseAction]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .drag
        return options
    }
    
    func pauseHandler(index: IndexPath) {
        let cell = collView.cellForItem(at: index) as! RecipeCell
        cell.updateTextWhenPaused()
    }
}
