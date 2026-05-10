//
//  PhotoGalleryApp.swift
//  PhotoGallery
//

import SwiftUI
import CoreData

@main
struct PhotoGalleryApp: App {
    private let container = DependencyContainer.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            photoGridView
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }
            
            favoritePhotosView
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            collectionsView
                .tabItem {
                    Label("Collections", systemImage: "folder.fill")
                }
        }
    }
    
    private var collectionsView: some View {
        let viewModel = DependencyContainer.shared.resolve((any CollectionsViewModelProtocol).self)
        return CollectionsListView(viewModel: viewModel as! CollectionsViewModel)
    }
    
    private var photoGridView: some View {
        let viewModel = DependencyContainer.shared.resolve((any PhotosViewModelProtocol).self)
        return PhotoGridView(viewModel: viewModel as! PhotosViewModel)
    }
    
    private var favoritePhotosView: some View {
        let viewModel = DependencyContainer.shared.resolve((any FavoritePhotosViewModelProtocol).self)
        return FavoritePhotosView(viewModel: viewModel as! FavoritePhotosViewModel)
    }
}
