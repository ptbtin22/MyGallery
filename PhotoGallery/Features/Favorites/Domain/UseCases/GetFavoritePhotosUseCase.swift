//
//  GetFavoritePhotosUseCase.swift
//  PhotoGallery
//
//  Created by Tin Pham on 16/5/26.
//

import Foundation
import Combine

protocol GetFavoritePhotosUseCaseProtocol {
    func execute() -> AnyPublisher<[Photo], Error>
}

class GetFavoritePhotosUseCase: GetFavoritePhotosUseCaseProtocol {
    private let repository: PhotoRepositoryProtocol
    
    init(repository: PhotoRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Photo], Error> {
        return repository.getFavoritePhotos()
    }
}
