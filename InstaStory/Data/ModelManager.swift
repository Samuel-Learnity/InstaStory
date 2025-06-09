//
//  ModelManager.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftData
import SwiftUI

final class ModelManager {
    let schema = Schema([
        UserModel.self
    ])
    
    var configuration: ModelConfiguration {
        ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    }
    
    var container: ModelContainer {
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Creation of ModelContainer failed with error \(error)")
        }
    }
}
