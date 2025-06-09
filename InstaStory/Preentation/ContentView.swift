//
//  ContentView.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftUI
import SwiftData

struct UsersStoryView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: UsersStoryView.ViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: .init(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    StoriesScrollView()
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
        }
        .navigationTitle("Insta Story")
        .toolbar(.hidden)
        
    }
    
    @ViewBuilder
    private func StoriesScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 16) {
                ForEach(viewModel.users, id: \.id) { user in
                    UserStoryView(for: user)
                }
            }.padding(8)
        }
    }
    
    @ViewBuilder
    private func UserStoryView(for user: UserModel) -> some View {
        Button(action: {}) {
            ZStack {
                AsyncImage(url: user.profilePictureURL) { img in
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                
                Circle().stroke(Color.red, lineWidth: 4)
            }
            .frame(width: 64, height: 64)
        }
    }
}
