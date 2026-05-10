//
//  DependencyContainer.swift
//  PhotoGallery
//

import Foundation
import Swinject

class DependencyContainer {
    static let shared = DependencyContainer()
    let container = Container()
    
    private init() {
        registerServices()
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }
    
    private func registerServices() {
        container.register((any NetworkServiceProtocol).self) { _ in
            NetworkService()
        }.inObjectScope(.container)
        
        container.register((any PersistenceServiceProtocol).self) { _ in
            PersistenceController.shared
        }.inObjectScope(.container)
    }
    
    private func registerRepositories() {
        container.register((any PhotoRepositoryProtocol).self) { r in
            PhotoRepository(
                networkService: r.resolve((any NetworkServiceProtocol).self)!,
                persistenceService: r.resolve((any PersistenceServiceProtocol).self)!
            )
        }.inObjectScope(.container)
        
        container.register((any CollectionRepositoryProtocol).self) { r in
            CollectionRepository(persistenceService: r.resolve((any PersistenceServiceProtocol).self)!)
        }.inObjectScope(.container)
    }
    
    private func registerUseCases() {
        container.register((any GetPhotosUseCaseProtocol).self) { r in
            GetPhotosUseCase(repository: r.resolve((any PhotoRepositoryProtocol).self)!)
        }
        
        container.register((any ToggleFavoriteUseCaseProtocol).self) { r in
            ToggleFavoriteUseCase(repository: r.resolve((any PhotoRepositoryProtocol).self)!)
        }
        
        container.register((any GetFavoritePhotosUseCaseProtocol).self) { r in
            GetFavoritePhotosUseCase(repository: r.resolve((any PhotoRepositoryProtocol).self)!)
        }
        
        container.register((any GetCollectionsUseCaseProtocol).self) { r in
            GetCollectionsUseCase(repository: r.resolve((any CollectionRepositoryProtocol).self)!)
        }
        
        container.register((any CreateCollectionUseCaseProtocol).self) { r in
            CreateCollectionUseCase(repository: r.resolve((any CollectionRepositoryProtocol).self)!)
        }
        
        container.register((any AddPhotoToCollectionUseCaseProtocol).self) { r in
            AddPhotoToCollectionUseCase(repository: r.resolve((any CollectionRepositoryProtocol).self)!)
        }
    }
    
    private func registerViewModels() {
        container.register((any PhotosViewModelProtocol).self) { r in
            PhotosViewModel(getPhotosUseCase: r.resolve((any GetPhotosUseCaseProtocol).self)!)
        }
        
        // Factory for DetailViewModel since it needs a Photo
        container.register((any PhotoDetailViewModelProtocol).self) { (r, photo: Photo) in
            PhotoDetailViewModel(
                photo: photo,
                toggleFavoriteUseCase: r.resolve((any ToggleFavoriteUseCaseProtocol).self)!,
                getCollectionsUseCase: r.resolve((any GetCollectionsUseCaseProtocol).self)!,
                addPhotoToCollectionUseCase: r.resolve((any AddPhotoToCollectionUseCaseProtocol).self)!
            )
        }
        
        container.register((any FavoritePhotosViewModelProtocol).self) { r in
            FavoritePhotosViewModel(getFavoritePhotosUseCase: r.resolve((any GetFavoritePhotosUseCaseProtocol).self)!)
        }
        
        container.register((any CollectionsViewModelProtocol).self) { r in
            CollectionsViewModel(
                getCollectionsUseCase: r.resolve((any GetCollectionsUseCaseProtocol).self)!,
                createCollectionUseCase: r.resolve((any CreateCollectionUseCaseProtocol).self)!
            )
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(type)!
    }
    
    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        return container.resolve(type, argument: argument)!
    }
}
