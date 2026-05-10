//
//  PhotoGridView.swift
//  PhotoGallery
//

import SwiftUI
import Kingfisher

struct PhotoGridView<ViewModel: PhotosViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 8)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                if viewModel.photos.isEmpty && !viewModel.isLoading {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.photos) { photo in
                                NavigationLink(destination: detailView(for: photo)) {
                                    PhotoCell(photo: photo)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onAppear {
                                    if photo.id == viewModel.photos.last?.id {
                                        viewModel.loadMorePhotos()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        viewModel.loadPhotos()
                    }
                }
                
                if viewModel.isLoading && viewModel.photos.isEmpty {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            .navigationTitle("Gallery")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchQuery, prompt: "Search authors")
            .onAppear {
                if viewModel.photos.isEmpty {
                    viewModel.loadPhotos()
                }
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") { }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    private func detailView(for photo: Photo) -> some View {
        let detailViewModel = DependencyContainer.shared.resolve((any PhotoDetailViewModelProtocol).self, argument: photo)
        return PhotoDetailView(viewModel: detailViewModel as! PhotoDetailViewModel)
    }
}

struct PhotoCell: View {
    let photo: Photo
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(photo.thumbnailUrl)
                .resizable()
                .placeholder {
                    ZStack {
                        Color.gray.opacity(0.1)
                        ProgressView()
                    }
                }
                .fade(duration: 0.3)
                .aspectRatio(1, contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            Text(photo.author)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .padding(.horizontal, 4)
                .padding(.top, 2)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No photos found")
                .font(.headline)
            Text("Check your internet connection or try a different search.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
