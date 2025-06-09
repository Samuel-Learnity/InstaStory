//
//  UserRepository.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftUI

protocol UserRepositoryProtocol {
    func fetchUsersData() -> [UserModel]
}

final class UserRepository: UserRepositoryProtocol {
    func fetchUsersData() -> [UserModel] {
        guard let url = Bundle.main.url(forResource: "users_stories_mock", withExtension: "json") else {
            print("No JSON file find in ./Ressource")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let responseDTO = try JSONDecoder().decode(FetchUsersDataResponse.self, from: data)
            
            let users: [UserModel] = responseDTO.users.map {
                UserModel(from: $0)
            }
            return users
        } catch {
            print("UserRepository - fetchUsersData failed with error \(error)")
            return []
        }
    }
}
