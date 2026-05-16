//
//  AddPhotoToCollectionUseCase.swift
//  PhotoGallery
//
//  Created by Tin Pham on 16/5/26.
//

import Foundation
import Combine

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
