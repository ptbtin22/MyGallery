//
//  CreateCollectionUseCase.swift
//  PhotoGallery
//
//  Created by Tin Pham on 16/5/26.
//

import Foundation
import Combine

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
