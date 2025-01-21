//
//  DataController.swift
//  Pomodoro
//
//  Created by Haris Alicic on 21. 1. 2025..
//

import Foundation
import CoreData

class DataController: ObservableObject {
    static let shared = DataController()
    let container = NSPersistentContainer(name: "Sessions")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load \(error.localizedDescription)")
            }
            
        }
    }
    
    var viewContext: NSManagedObjectContext {
            container.viewContext
        }
}
