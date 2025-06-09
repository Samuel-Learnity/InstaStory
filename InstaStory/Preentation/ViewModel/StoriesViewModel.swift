//
//  StoriesViewModel.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftUI
import SwiftData

final class StoriesViewModel: ObservableObject {
    @Published var stories: [StoryModel] = []
    @Published var isShowingStories: Bool = false
    
    @Published var selectedUser: UserModel? = nil
    @Published var userIndex: Int? = nil
    
    @Published var currentStory: StoryModel? = nil
    @Published var storyIndex: Int? = nil
    
    private let repository: UserRepositoryProtocol
    private let modelContext: ModelContext
    
    init(context: ModelContext) {
        self.repository = UserRepository()
        self.modelContext = context
        
        loadStoredStories()
    }
}

extension StoriesViewModel {
    private func loadStoredStories() {
        let descriptor = FetchDescriptor<StoryModel>()
        
        do {
            let fetched = try modelContext.fetch(descriptor)
            self.stories = fetched
        } catch {
            self.stories = []
        }
    }
    
    func saveStorySeen(for story: StoryModel?) {
        guard let story else {
            print("no story seen to save")
            return
        }
        do {
            if let user = selectedUser, let targetStory = user.stories.first(where: { $0.id == story.id }) {
                targetStory.seen = true
                
                try modelContext.save()
                loadStoredStories()
            }
        } catch {
            print("no story found \(error)")
        }
    }
}

extension StoriesViewModel {
    func handleOpenUserStories(for user: UserModel, userIndex: Int) {
        self.isShowingStories = true
        
        self.selectedUser = user
        self.userIndex = userIndex
        self.storyIndex = user.stories.firstIndex(where: { !$0.seen }) ?? 0
        self.currentStory = user.stories.first(where: { !$0.seen }) ?? user.stories.first
        
        if let currentStory, !currentStory.seen {
            saveStorySeen(for: currentStory)
        }
    }
    
    func handleCloseStories() {
        isShowingStories = false
        selectedUser = nil
        userIndex = nil
        currentStory = nil
        storyIndex = nil
    }
    
    func handleUpdateCurrentStory() {
        guard let user = selectedUser, let uIndex = userIndex, let sIndex = storyIndex else {
            return
        }
        
        // if user have more other stories
        let userStories = user.stories
        if sIndex + 1 < userStories.count {
            let nextIndex = sIndex + 1
            currentStory = userStories[nextIndex]
            storyIndex = nextIndex
            
            if let currentStory, !currentStory.seen {
                saveStorySeen(for: currentStory)
            }
            return
        }
        
        // if user don't have other story -> go to next user
        let descriptor = FetchDescriptor<UserModel>(sortBy: [SortDescriptor(\.id)])
        var users: [UserModel] = []
        do {
            let fetched = try modelContext.fetch(descriptor)
            users = fetched.sorted { lhs, rhs in
                // first, users with unseen stories
                if lhs.allStoriesSeen != rhs.allStoriesSeen {
                    return !lhs.allStoriesSeen && rhs.allStoriesSeen
                }
                return lhs.name < rhs.name
            }
            let newtUserIndex = uIndex + 1
            
            if newtUserIndex < users.count {
                let nextUser = users[newtUserIndex]
                selectedUser = nextUser
                userIndex = newtUserIndex
                
                let nextStories = nextUser.stories
                if let firstUnseenIndex = nextStories.firstIndex(where: { !$0.seen }) {
                    storyIndex = firstUnseenIndex
                    currentStory = nextStories[firstUnseenIndex]
                } else {
                    storyIndex = 0
                    currentStory = nextStories.first
                }
                
                if let currentStory, !currentStory.seen {
                    saveStorySeen(for: currentStory)
                }
            } else {
                handleCloseStories()
            }
            
        } catch {
            print("\(error)")
        }
    }
}
