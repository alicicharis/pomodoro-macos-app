//
//  DataController.swift
//  Pomodoro
//
//  Created by Haris Alicic on 21. 1. 2025..
//

import Foundation
import CoreData

//class DataController: ObservableObject {
//    static let shared = DataController()
//    let container = NSPersistentContainer(name: "Sessions")
//    
//    init() {
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                print("Core data failed to load \(error.localizedDescription)")
//            }
//            
//        }
//    }
//    
//    var viewContext: NSManagedObjectContext {
//            container.viewContext
//        }
//}

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "Sessions")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
        
    private init() { }
}
