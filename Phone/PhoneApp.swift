//
//  PhoneApp.swift
//  Phone
//
//  Created by Louis Chang on 2024/12/11.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct PhoneApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Contact.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
