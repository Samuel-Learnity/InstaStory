//
//  UsersStoryViewModel.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftUI
import SwiftData

extension UsersStoryView {
    final class ViewModel: ObservableObject {
        @Published var displayUsers: [UserModel] = []
        @Published var users: [UserModel] = []
        @Published var isLoading: Bool = false
        
        private let repository: UserRepositoryProtocol
        private let modelContext: ModelContext
        
        init(context: ModelContext) {
            self.repository = UserRepository() /// The Repository can be shared, but not in our useCase
            self.modelContext = context
            
            isLoading = true
            fetchAndStoreUsers()
        }
    }
}

extension UsersStoryView.ViewModel {
    func getUserList() {
        let stored = loadStoredUsers()
        self.users = stored
        self.displayUsers = stored
        
        /// Simulate a loading for presentation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    }
    
    func appendBatch() {
        displayUsers.append(contentsOf: users)
    }
    
    func sortUsersByName(for users: [UserModel]) -> [UserModel] {
        return users.sorted { lhs, rhs in
            if lhs.allStoriesSeen != rhs.allStoriesSeen {
                return !lhs.allStoriesSeen && rhs.allStoriesSeen
            }
            return lhs.id < rhs.id
        }
    }
    
    func loadStoredUsers() -> [UserModel] {
        let descriptor = FetchDescriptor<UserModel>(sortBy: [SortDescriptor(\.id)])
        
        do {
            let fetched = try modelContext.fetch(descriptor)
            return sortUsersByName(for: fetched)
        } catch {
            return []
        }
    }
    
    func fetchAndStoreUsers() {
        let fetchedUsers = repository.fetchUsersData()
        
        let storedUsers = loadStoredUsers()
        
        let existingUsersIDs: Set<String> = Set(storedUsers.map { $0.id })
        
        for newUser in fetchedUsers {
            if !existingUsersIDs.contains(newUser.id) {
                modelContext.insert(newUser)
            } else {
                // TODO: Samuel - Update existing user with his new data
            }
        }
        
        do {
            if modelContext.hasChanges {
                try modelContext.save()
            }
        } catch {
            print("Cannot save context \(error)")
        }
        getUserList()
    }
}
