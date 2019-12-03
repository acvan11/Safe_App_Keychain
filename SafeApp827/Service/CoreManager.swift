//
//  CoreManager.swift
//  SafeApp827
//
//  Created by mac on 9/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import CoreData

protocol CoreProtocol {
    func load() -> [Media]
}

class FakeCoreManager: CoreProtocol {
    
    func load() -> [Media] {
        return []
    }
}

final class CoreManager: CoreProtocol {
    
    static let shared = CoreManager()
    private init() {}
    
    // MARK: - Core Data stack
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "SafeApp827")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    //MARK: Load
    func load() -> [Media] {
        
        let request = NSFetchRequest<Media>(entityName: "Media")
        var coreMedia = [Media]()
        
        do {
           coreMedia = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        print("Media Count: \(coreMedia.count)")
        return coreMedia
    }
    
    //MARK: Save
    func save(path: String, isVideo: Bool) {
        //creating entity
        let entity = NSEntityDescription.entity(forEntityName: "Media", in: context)!
        let media = Media(entity: entity, insertInto: context)
        
        //set values
        media.path = path
        media.isVideo = isVideo
        
        //save context
        saveContext()
        print("Saved Media To Core: \(path)")
        
    }
    
    
    // MARK: - Core Helper
    
    func saveContext () {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    
}
