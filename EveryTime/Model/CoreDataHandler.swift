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


class CoreDataHandler {
    fileprivate static let debug: Bool = true
    fileprivate static var context: NSManagedObjectContext? = nil
    
    // watchkit
    class func sharedAppGroup() -> String {
        return "group.com.whizbang.EveryTime"
    }
    
    class func managedObjecModel() -> NSManagedObjectModel {
        let proxyBundle = Bundle(identifier: "com.whizbang.EveryTime")
        let modelURL = proxyBundle?.url(forResource: "SimpleRecipeTimer", withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }
    
    class func persistantStoreCoordinator() -> NSPersistentStoreCoordinator? {
        let sharedContainerURL: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: CoreDataHandler.sharedAppGroup())
        if let sharedContainerURL = sharedContainerURL {
            let storeURL = sharedContainerURL.appendingPathComponent("everytimedb.sqlite")
            let coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: CoreDataHandler.managedObjecModel())
            
            do {
                try coordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch let error {
                print("\(error.localizedDescription)")
            }
            
            return coordinator
        }
        return nil
    }
    
//    class func getContext() -> NSManagedObjectContext {
//        let coordinator = CoreDataHandler.persistantStoreCoordinator()
//        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)//check
//        moc.persistentStoreCoordinator = coordinator
//        return moc
//    }
    
    
    class func loadContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
//        self.context = CoreDataHandler.getContext()
    }
    
    class func getContext() -> NSManagedObjectContext {
        return self.context!
    }
    
    class func getPrivateContext() -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = getContext()
        return privateContext
    }
    
    /**
        Saves to settings entity
    */
    class func saveContext() {
        getContext().perform {
            do {
                try getContext().save()
            } catch let error as NSError {
                print("Error saving \(error)")
            }
        }
    }
    
    /**
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

    // date - createdDate
    class func fetchByDate<E: NSManagedObject>(in: E.Type, date: Date) -> E? {
        do {
            let fEntity = E.fetchRequest()
            fEntity.returnsObjectsAsFaults = false
            fEntity.predicate = NSPredicate(format: "createdDate == %@", date as NSDate)
            let fetchedResults = try getContext().fetch(fEntity)
            return fetchedResults.first as? E
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
//            for record in e {

                //                let rEntity = record as! RecipeEntity
//                for sEntity in rEntity.step as! Set<StepEntity> {
////                    print(sEntity.stepName!)
//                }
//            }
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
        Delete specific entity
    */
    class func deleteEntity<E: NSManagedObject>(entity: E.Type, createdDate: Date) -> Bool {
        let entity = self.fetchByDate(in: E.self, date: createdDate)
        guard let e = entity else {
            return false
        }
        do {
            self.getContext().delete(e)
            try self.getContext().save()
            return true
        } catch let error as NSError {
            print("Trouble deleting all records in entity: \(error)")
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
