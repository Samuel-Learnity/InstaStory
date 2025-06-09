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
                            
                            // MARK: - Header overlay
                                .overlay(alignment: .top) {
                                    HeaderOverlay()
                                }
                            // MARK: - Like overlay
                                .overlay(alignment: .bottomTrailing) {
                                    LikeOverlay()
                                }
                        case .failure:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                viewModel.handleUpdateCurrentStory()
            }
        }
    }
    
    @ViewBuilder
    private func HeaderOverlay() -> some View {
        HStack(spacing: 0) {
            AsyncImage(url: user.profilePictureURL) { img in
                img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .padding(.trailing, 8)
            
            Text(user.name)
                .font(.headline)
                .bold()
                .foregroundColor(.white)
            
            Spacer()
            
            Button { viewModel.handleCloseStories() }
            label : {
                ZStack {
                    Color.white.opacity(0.0001)
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                }
                .frame(width: 28, height: 28)
            }
        }.frame(alignment: .top)
            .safeAreaPadding(.all)
            .padding(.top, 16)
    }
    
    @ViewBuilder
    private func LikeOverlay() -> some View {
        let isLiked = (viewModel.currentStory?.liked ?? false)
        Button {
            if let currentStory = viewModel.currentStory {
                viewModel.toggleLike(for: currentStory)
            }
        } label: {
            ZStack {
                Color.white.opacity(0.0001)
                Image(systemName: isLiked
                      ? "heart.fill"
                      : "heart"
                )
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(
                    isLiked
                    ? .red
                    : .white
                )
            }.frame(width: 36, height: 36)
        }
        .safeAreaPadding(.all)
        .padding(.trailing, 16)
        .padding(.bottom, 54)
    }
}
