//
//  CollectionUseCases.swift
//  PhotoGallery
//

import Foundation
import Combine

protocol GetCollectionsUseCaseProtocol {
    func execute() -> AnyPublisher<[PhotoCollection], Error>
}

class GetCollectionsUseCase: GetCollectionsUseCaseProtocol {
    private let repository: CollectionRepositoryProtocol
    
    init(repository: CollectionRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[PhotoCollection], Error> {
        return repository.fetchCollections()
    }
}

protocol CreateCollectionUseCaseProtocol {
    func execute(name: String) -> AnyPublisher<PhotoCollection, Error>
}

class CreateCollectionUseCase: CreateCollectionUseCaseProtocol {
    private let repository: CollectionRepositoryProtocol
    
    init(repository: CollectionRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(name: String) -> AnyPublisher<PhotoCollection, Error> {
        return repository.createCollection(name: name)
    }
}

protocol AddPhotoToCollectionUseCaseProtocol {
    func execute(photoId: String, collectionId: String) -> AnyPublisher<Void, Error>
}

class AddPhotoToCollectionUseCase: AddPhotoToCollectionUseCaseProtocol {
    private let repository: CollectionRepositoryProtocol
    
    init(repository: CollectionRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(photoId: String, collectionId: String) -> AnyPublisher<Void, Error> {
        return repository.addPhotoToCollection(photoId: photoId, collectionId: collectionId)
    }
}
