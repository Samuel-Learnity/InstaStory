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
    @StateObject private var storiesViewModel: StoriesViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: .init(context: modelContext))
        _storiesViewModel = StateObject(wrappedValue: .init(context: modelContext))
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
        .overlay() {
            if storiesViewModel.isShowingStories, let selectedUser = storiesViewModel.selectedUser {
                StoriesDetailView(user: selectedUser)
                    .environmentObject(storiesViewModel)
                    .background {
                        Color.clear
                    }
            }
        }
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
        let userIndex = viewModel.users.firstIndex(where: { $0.name == user.name }) ?? 0
        
        Button(action: { storiesViewModel.handleOpenUserStories(for: user, userIndex: userIndex) }) {
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
                
                Circle().stroke(
                    user.allStoriesSeen || viewModel.isLoading
                    ? AnyShapeStyle(Color.gray)
                    : AnyShapeStyle(
                        AngularGradient(
                            gradient: Gradient(
                                colors: [
                                    .yellow,
                                    .orange,
                                    .pink,
                                    .purple
                                ]),
                            center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
                        )
                    ),
                    lineWidth: 4
                )
            }
            .frame(width: 64, height: 64)
        }
    }
}
