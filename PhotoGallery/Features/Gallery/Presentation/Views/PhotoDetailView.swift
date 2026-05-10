//
//  PhotoDetailView.swift
//  PhotoGallery
//

import SwiftUI
import Kingfisher

struct PhotoDetailView<ViewModel: PhotoDetailViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingCollectionSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                KFImage(viewModel.photo.imageUrl)
                    .resizable()
                    .onSuccess { result in
                        // Trigger AI classification once image is loaded
                        viewModel.classifyImage(result.image)
                    }
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .overlay(ProgressView())
                    }
                    .fade(duration: 0.3)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Author")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(viewModel.photo.author)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.toggleFavorite()
                        }) {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(viewModel.isFavorite ? .red : .gray)
                                .font(.title)
                        }
                    }
                    
                    if let category = viewModel.detectedCategory {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.purple)
                            Text(category.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.purple)
                            Text("• AI Detected")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 12)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(20)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    Text("Photo Info")
                        .font(.headline)
                    
                    InfoRow(label: "ID", value: viewModel.photo.id)
                    InfoRow(label: "Source", value: "Unsplash (via Lorem Picsum)")
                    
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.loadCollections()
                            showingCollectionSheet = true
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "folder.badge.plus")
                                Text("Add to Collection")
                                Spacer()
                            }
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            // Share action
                        }) {
                            HStack {Spacer()
                                Image(systemName: "square.and.arrow.up")
                                Text("Share Image")
                                Spacer()
                            }
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemBackground))
        .sheet(isPresented: $showingCollectionSheet) {
            AddToCollectionView(viewModel: viewModel)
        }
    }
}

struct AddToCollectionView<ViewModel: PhotoDetailViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.collections.isEmpty {
                    VStack(spacing: 12) {
                        Text("No collections found.")
                            .font(.headline)
                        Text("Create one in the Collections tab first!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    ForEach(viewModel.collections) { collection in
                        Button {
                            viewModel.addToCollection(collection)
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "folder")
                                    .foregroundColor(.accentColor)
                                Text(collection.name)
                                Spacer()
                                if viewModel.isAddingToCollection {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add to Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.body)
    }
}
