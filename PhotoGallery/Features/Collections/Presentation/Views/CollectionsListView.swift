//
//  CollectionsListView.swift
//  PhotoGallery
//

import SwiftUI

struct CollectionsListView<ViewModel: CollectionsViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @State private var showingCreateAlert = false
    @State private var newCollectionName = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading && viewModel.collections.isEmpty {
                    ProgressView()
                        .padding(.top, 50)
                } else if viewModel.collections.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No Collections Yet")
                            .font(.headline)
                        Button("Create Your First Album") {
                            showingCreateAlert = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, 100)
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.collections) { collection in
                            NavigationLink(destination: CollectionDetailView(collection: collection)) {
                                CollectionCard(collection: collection)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Collections")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Collection", isPresented: $showingCreateAlert) {
                TextField("Collection Name", text: $newCollectionName)
                Button("Cancel", role: .cancel) { newCollectionName = "" }
                Button("Create") {
                    if !newCollectionName.isEmpty {
                        viewModel.createCollection(name: newCollectionName)
                        newCollectionName = ""
                    }
                }
            }
            .onAppear {
                viewModel.loadCollections()
            }
        }
    }
}

struct CollectionCard: View {
    let collection: PhotoCollection
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .aspectRatio(1, contentMode: .fill)
                
                if let firstPhoto = collection.photos.first {
                    AsyncImage(url: firstPhoto.thumbnailUrl) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "photo.on.rectangle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
            
            Text(collection.name)
                .font(.headline)
                .lineLimit(1)
            
            Text("\(collection.photos.count) photos")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct CollectionDetailView: View {
    let collection: PhotoCollection
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(collection.photos) { photo in
                    AsyncImage(url: photo.thumbnailUrl) { image in
                        image.resizable()
                             .aspectRatio(1, contentMode: .fill)
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.2))
                    }
                }
            }
        }
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
