//
//  MoviesAppApp.swift
//  MoviesApp
//
//  Created by Mohammad Shabaan on 19/12/2024.
//

import SwiftUI

@main
struct MoviesAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MoviesListView(vm: MoviesViewModel(context: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
