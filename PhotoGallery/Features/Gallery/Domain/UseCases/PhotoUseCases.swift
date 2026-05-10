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

// ToggleFavoriteUseCase
protocol ToggleFavoriteUseCaseProtocol {
    func execute(photo: Photo) -> AnyPublisher<Void, Error>
}

class ToggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol {
    private let repository: PhotoRepositoryProtocol
    
    init(repository: PhotoRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(photo: Photo) -> AnyPublisher<Void, Error> {
        return repository.toggleFavorite(photo: photo)
    }
}

// GetFavoritePhotosUseCase
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
