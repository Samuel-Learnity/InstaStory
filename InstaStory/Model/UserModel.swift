//
//  UserModel.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftData
import SwiftUI

@Model
final class UserModel {
    let name: String
    let id: String
    let profilePictureURL: URL
    var stories: [StoryModel] = []
    var allStoriesSeen: Bool {
        !stories.contains(where: { !$0.seen })
    }
    
    init(from dto: UserDTO) {
        self.name = dto.name
        self.id = dto.id
        self.profilePictureURL = dto.profilePictureURL
        self.stories = dto.stories.map { StoryModel(from: $0) }
    }
}
