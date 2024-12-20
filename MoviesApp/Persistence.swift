//
//  Persistence.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import CoreData

// MARK: - Persistence Controller
class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MoviesApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
}
