//
//  CollectionRepository.swift
//  PhotoGallery
//

import Foundation
import Combine
import CoreData

class CollectionRepository: CollectionRepositoryProtocol {
    private let persistenceService: PersistenceServiceProtocol
    
    init(persistenceService: PersistenceServiceProtocol) {
        self.persistenceService = persistenceService
    }
    
    func fetchCollections() -> AnyPublisher<[PhotoCollection], Error> {
        let request: NSFetchRequest<CollectionEntity> = NSFetchRequest(entityName: "CollectionEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        return persistenceService.fetch(request)
            .map { entities in
                entities.map { self.mapToDomain($0) }
            }
            .eraseToAnyPublisher()
    }
    
    func createCollection(name: String) -> AnyPublisher<PhotoCollection, Error> {
        let context = persistenceService.viewContext
        let entity = CollectionEntity(context: context)
        entity.id = UUID().uuidString
        entity.name = name
        entity.createdAt = Date()
        
        return persistenceService.save()
            .map { self.mapToDomain(entity) }
            .eraseToAnyPublisher()
    }
    
    func deleteCollection(id: String) -> AnyPublisher<Void, Error> {
        let request: NSFetchRequest<CollectionEntity> = NSFetchRequest(entityName: "CollectionEntity")
        request.predicate = NSPredicate(format: "id == %@", id)
        
        return persistenceService.fetch(request)
            .flatMap { entities -> AnyPublisher<Void, Error> in
                if let entity = entities.first {
                    self.persistenceService.viewContext.delete(entity)
                    return self.persistenceService.save()
                }
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func addPhotoToCollection(photoId: String, collectionId: String) -> AnyPublisher<Void, Error> {
        let photoRequest: NSFetchRequest<PhotoEntity> = NSFetchRequest(entityName: "PhotoEntity")
        photoRequest.predicate = NSPredicate(format: "id == %@", photoId)
        
        let collectionRequest: NSFetchRequest<CollectionEntity> = NSFetchRequest(entityName: "CollectionEntity")
        collectionRequest.predicate = NSPredicate(format: "id == %@", collectionId)
        
        return Publishers.Zip(
            persistenceService.fetch(photoRequest),
            persistenceService.fetch(collectionRequest)
        )
        .flatMap { photoEntities, collectionEntities -> AnyPublisher<Void, Error> in
            guard let photo = photoEntities.first, let collection = collectionEntities.first else {
                return Fail(error: NSError(domain: "CollectionRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Photo or Collection not found"])).eraseToAnyPublisher()
            }
            
            collection.addToPhotos(photo)
            return self.persistenceService.save()
        }
        .eraseToAnyPublisher()
    }
    
    func removePhotoFromCollection(photoId: String, collectionId: String) -> AnyPublisher<Void, Error> {
        let photoRequest: NSFetchRequest<PhotoEntity> = NSFetchRequest(entityName: "PhotoEntity")
        photoRequest.predicate = NSPredicate(format: "id == %@", photoId)
        
        let collectionRequest: NSFetchRequest<CollectionEntity> = NSFetchRequest(entityName: "CollectionEntity")
        collectionRequest.predicate = NSPredicate(format: "id == %@", collectionId)
        
        return Publishers.Zip(
            persistenceService.fetch(photoRequest),
            persistenceService.fetch(collectionRequest)
        )
        .flatMap { photoEntities, collectionEntities -> AnyPublisher<Void, Error> in
            guard let photo = photoEntities.first, let collection = collectionEntities.first else {
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            
            collection.removeFromPhotos(photo)
            return self.persistenceService.save()
        }
        .eraseToAnyPublisher()
    }
    
    private func mapToDomain(_ entity: CollectionEntity) -> PhotoCollection {
        let photos = (entity.photos?.allObjects as? [PhotoEntity])?
            .compactMap { photoEntity -> Photo? in
                guard let id = photoEntity.id else { return nil }
                return Photo(
                    id: id,
                    author: photoEntity.author ?? "",
                    imageUrl: URL(string: photoEntity.imageUrl ?? "") ?? URL(string: "https://")!,
                    thumbnailUrl: URL(string: photoEntity.thumbnailUrl ?? "") ?? URL(string: "https://")!,
                    isFavorite: photoEntity.isFavorite
                )
            } ?? []
            
        return PhotoCollection(
            id: entity.id ?? "",
            name: entity.name ?? "Untitled",
            createdAt: entity.createdAt ?? Date(),
            photos: photos
        )
    }
}
