//
//  StoryModel.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftData
import SwiftUI

@Model
final class StoryModel {
    let url: URL
    let id: String
    var seen: Bool = false
    var liked: Bool = false
    
    init(from dto: StoryDTO) {
        self.url = dto.url
        self.id = dto.id
    }
}

