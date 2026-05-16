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
