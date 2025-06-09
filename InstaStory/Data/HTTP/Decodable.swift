//
//  Response.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftUI

struct FetchUsersDataResponse: Decodable {
    let page: Int
    let users: [UserDTO]
}
