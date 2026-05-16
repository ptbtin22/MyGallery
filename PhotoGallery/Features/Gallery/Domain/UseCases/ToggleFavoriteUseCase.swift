//
//  ToggleFavoriteUseCase.swift
//  PhotoGallery
//
//  Created by Tin Pham on 16/5/26.
//

import Foundation
import Combine

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
