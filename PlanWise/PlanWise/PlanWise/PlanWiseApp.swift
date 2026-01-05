//
//  PlanWiseApp.swift
//  PlanWise
//
//  Created by user278444 on 11/23/25.
//


//
//  PlanWiseApp.swift
//  PlanWise
//
//  Created by user278444 on 11/8/25.
//

import SwiftUI
import SwiftData

@main
struct PlanWiseApp: App {
    @StateObject private var userManager = UserManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            NoteItem.self,
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
            if userManager.hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(userManager)
                    .modelContainer(sharedModelContainer)
            } else {
                OnboardingView()
                    .environmentObject(userManager)
            }
        }
    }
}