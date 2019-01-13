//
//  CoreDataHandler.swift
//  LastDrop
//
//  Created by Mark Wong on 10/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

//import Foundation
import CoreData
import UIKit
import Foundation

class CoreDataHandler {
    fileprivate static let debug: Bool = true
    fileprivate static var context: NSManagedObjectContext? = nil
    
    class func loadContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    class func getContext() -> NSManagedObjectContext {
        return self.context!
    }
    
    /*
        Save to settings entity
    */
    class func saveContext() {
        do {
            try getContext().save()
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    /*
        Fetch generic function
    */
    class func fetchEntity<E: NSManagedObject>(in: E.Type) -> [E]? {
        do {
            let fEntity = E.fetchRequest()
            fEntity.returnsObjectsAsFaults = false
            let fetchedResults = try getContext().fetch(fEntity)
            return fetchedResults as? [E]
        } catch let error as NSError {
            print("\(error) Could not be fetched")
            return nil
        }
    }
    
    /*
        Print records. Uses fetchEntity(in:)
     */
    class func printAllRecordsIn<E: NSManagedObject>(entity: E.Type) {
        guard let e: [E] = self.fetchEntity(in: E.self) else {
            return
        }
        
        if (e.isEmpty) {
            print("Nothing In Entity")
        } else {
            for record in e {
                print("Recipe")
                print(record)
                
                print("Step")
                let rEntity = record as! RecipeEntity
                for sEntity in rEntity.step as! Set<StepEntity> {
                    print(sEntity.stepName)
                }
            }
        }
    }
    
    /*
        Clear Entity
    */
    class func deleteAllRecordsIn<E: NSManagedObject>(entity: E.Type) -> Bool {
        
        if (self.doesEntityExist(in: E.self)) {
            do {
                let fr = E.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fr)
                try self.getContext().execute(deleteRequest)
                try self.getContext().save()
                return true
            } catch let error as NSError {
                print("Trouble deleting all records in entity: \(error)")
                return false
            }
        } else {
            print("Nothing to delete")
            return false
        }
    }
    
    /*
        Count records in entity
    */
    class func doesEntityExist<E: NSManagedObject>(in: E.Type) -> Bool {
        do {
            let fr = E.fetchRequest()
            fr.returnsObjectsAsFaults = false
            let fetchedResults = try getContext().fetch(fr)
            
            if (!fetchedResults.isEmpty) {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("\(error) Does not exists/Could not be fetched")
            return false
        }
    }
}
