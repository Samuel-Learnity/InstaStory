//
//  StoriesDetailView.swift
//  InstaStory
//
//  Created by Samuel Neveu on 09/06/2025.
//

import SwiftUI

struct StoriesDetailView: View {
    @EnvironmentObject var viewModel: StoriesViewModel
    let user: UserModel
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black
                    .opacity(0.2)
                
                VStack(spacing: 0) {
                    AsyncImage(url: viewModel.currentStory?.url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 80, height: 80)
                        case .success(let img):
                            img
                                .resizable()
                                .frame(maxWidth: proxy.size.width)
                        case .failure:
                            Color.red
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                viewModel.handleCloseStories()
            }
        }.onAppear(perform: {
            print("Story detail appear")
        })
    }
}
