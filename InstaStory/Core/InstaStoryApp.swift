//
//  InstaStoryApp.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftUI
import SwiftData

@main
struct InstaStoryApp: App {
    let modelManager = ModelManager()
        
    var body: some Scene {
        WindowGroup {
            UsersStoryView(modelContext: modelManager.container.mainContext) /// Pass the mainContext in args for being use in ViewModels
                .preferredColorScheme(.dark)
        }
        .modelContainer(modelManager.container) /// Basic usage of container by SwiftData, to be use directly in Views (not our use case)
    }
}
 
