//
//  FavoritePhotosView.swift
//  PhotoGallery
//

import SwiftUI
import Kingfisher

struct FavoritePhotosView<ViewModel: FavoritePhotosViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 8)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                if viewModel.photos.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No favorites yet")
                            .font(.headline)
                        Text("Photos you like will appear here.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.photos) { photo in
                                NavigationLink(destination: detailView(for: photo)) {
                                    PhotoCell(photo: photo)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadFavorites()
            }
        }
    }
    
    private func detailView(for photo: Photo) -> some View {
        let detailViewModel = DependencyContainer.shared.resolve((any PhotoDetailViewModelProtocol).self, argument: photo)
        return PhotoDetailView(viewModel: detailViewModel as! PhotoDetailViewModel)
    }
}
