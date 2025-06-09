//
//  UserDTO.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftUI

struct UserDTO: Decodable {
    let name: String
    let id: String
    let profilePictureURL: URL
    let stories: [StoryDTO]
    
    enum CodingKeys: String, CodingKey {
        case name, id, stories
        case profilePictureURL = "profile_picture_url"
    }
}
