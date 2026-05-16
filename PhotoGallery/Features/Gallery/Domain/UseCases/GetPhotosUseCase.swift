//
//  GetPhotosUseCase.swift
//  PhotoGallery
//

import Foundation
import Combine

protocol GetPhotosUseCaseProtocol {
    func execute(page: Int) -> AnyPublisher<[Photo], Error>
}

class GetPhotosUseCase: GetPhotosUseCaseProtocol {
    private let repository: PhotoRepositoryProtocol
    
    init(repository: PhotoRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int) -> AnyPublisher<[Photo], Error> {
        return repository.fetchPhotos(page: page)
    }
}
