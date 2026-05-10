//
//  PhotoRepository.swift
//  PhotoGallery
//

import Foundation
import Combine
import CoreData

class PhotoRepository: PhotoRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let persistenceService: PersistenceServiceProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol, persistenceService: PersistenceServiceProtocol) {
        self.networkService = networkService
        self.persistenceService = persistenceService
    }
    
    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error> {
        return networkService.fetchPhotos(page: page)
            .handleEvents(receiveOutput: { [weak self] photos in
                self?.cachePhotos(photos)
            })
            .catch { [weak self] _ -> AnyPublisher<[Photo], Error> in
                guard let self = self else { return Fail(error: NetworkError.badURL).eraseToAnyPublisher() }
                return self.fetchCachedPhotos()
            }
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(photo: Photo) -> AnyPublisher<Void, Error> {
        let request: NSFetchRequest<PhotoEntity> = NSFetchRequest(entityName: "PhotoEntity")
        request.predicate = NSPredicate(format: "id == %@", photo.id)
        
        return persistenceService.fetch(request)
            .flatMap { entities -> AnyPublisher<Void, Error> in
                if let entity = entities.first {
                    entity.isFavorite.toggle()
                    return self.persistenceService.save()
                } else {
                    let context = self.persistenceService.viewContext
                    let entity = PhotoEntity(context: context)
                    entity.id = photo.id
                    entity.author = photo.author
                    entity.imageUrl = photo.imageUrl.absoluteString
                    entity.thumbnailUrl = photo.thumbnailUrl.absoluteString
                    entity.isFavorite = !photo.isFavorite
                    entity.category = photo.category
                    entity.createdAt = Date()
                    return self.persistenceService.save()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getFavoritePhotos() -> AnyPublisher<[Photo], Error> {
        let request: NSFetchRequest<PhotoEntity> = NSFetchRequest(entityName: "PhotoEntity")
        request.predicate = NSPredicate(format: "isFavorite == YES")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        return persistenceService.fetch(request)
            .map { entities in
                entities.map { self.mapToDomain($0) }
            }
            .eraseToAnyPublisher()
    }
    
    func searchPhotos(query: String) -> AnyPublisher<[Photo], Error> {
        let request: NSFetchRequest<PhotoEntity> = NSFetchRequest(entityName: "PhotoEntity")
        request.predicate = NSPredicate(format: "author CONTAINS[cd] %@ OR category CONTAINS[cd] %@", query, query)
        
        return persistenceService.fetch(request)
            .map { entities in
                entities.map { self.mapToDomain($0) }
            }
            .eraseToAnyPublisher()
    }
    
    func updateCategory(photoId: String, category: String) -> AnyPublisher<Void, Error> {
        let request: NSFetchRequest<PhotoEntity> = NSFetchRequest(entityName: "PhotoEntity")
        request.predicate = NSPredicate(format: "id == %@", photoId)
        
        return persistenceService.fetch(request)
            .flatMap { entities -> AnyPublisher<Void, Error> in
                if let entity = entities.first {
                    entity.category = category
                    return self.persistenceService.save()
                }
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    
    private func cachePhotos(_ photos: [Photo]) {
        let context = persistenceService.viewContext
        photos.forEach { photo in
            let request: NSFetchRequest<PhotoEntity> = NSFetchRequest(entityName: "PhotoEntity")
            request.predicate = NSPredicate(format: "id == %@", photo.id)
            
            do {
                let results = try context.fetch(request)
                let entity = results.first ?? PhotoEntity(context: context)
                entity.id = photo.id
                entity.author = photo.author
                entity.imageUrl = photo.imageUrl.absoluteString
                entity.thumbnailUrl = photo.thumbnailUrl.absoluteString
                entity.createdAt = Date()
                // Do not overwrite category if it exists
            } catch {
                print("Error caching photo: \(error)")
            }
        }
        
        persistenceService.save().sink(receiveCompletion: { _ in }, receiveValue: { _ in }).store(in: &subscriptions)
    }
    
    private func fetchCachedPhotos() -> AnyPublisher<[Photo], Error> {
        let request: NSFetchRequest<PhotoEntity> = NSFetchRequest(entityName: "PhotoEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        return persistenceService.fetch(request)
            .map { entities in
                entities.map { self.mapToDomain($0) }
            }
            .eraseToAnyPublisher()
    }
    
    private func mapToDomain(_ entity: PhotoEntity) -> Photo {
        Photo(
            id: entity.id ?? "",
            author: entity.author ?? "",
            imageUrl: URL(string: entity.imageUrl ?? "") ?? URL(string: "https://")!,
            thumbnailUrl: URL(string: entity.thumbnailUrl ?? "") ?? URL(string: "https://")!,
            isFavorite: entity.isFavorite,
            category: entity.category
        )
    }
}
