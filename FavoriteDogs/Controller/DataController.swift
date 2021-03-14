//
//  DataController.swift
//  FavoriteDogs
//
//  Created by Leela Krishna Chaitanya Koravi on 3/9/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (()->Void)? = nil){
        persistentContainer.loadPersistentStores{
            storeDescription, error in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    
    func save() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    
    
    
//    func fetchLocation(_ predicate: NSPredicate, sorting: NSSortDescriptor? = nil) throws -> Pin? {
//        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
//        fr.predicate = predicate
//        if let sorting = sorting {
//            fr.sortDescriptors = [sorting]
//        }
//        guard let location = (try viewContext.fetch(fr) as! [Pin]).first else {
//            return nil
//        }
//        return location
//    }
//
//    func fetchAllLocation() throws -> [Pin]? {
//        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
//        guard let pin = try viewContext.fetch(fr) as? [Pin] else {
//            return nil
//        }
//        return pin
//    }
    
    func fetchFavoriteDogs() throws -> [FavoriteDog]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteDog")
        guard let favDogs = try viewContext.fetch(fr) as? [FavoriteDog] else {
            return nil
        }
        return favDogs
    }
}

