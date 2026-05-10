//
//  ClassifyPhotoUseCase.swift
//  PhotoGallery
//

import Foundation
import Combine
import UIKit

protocol ClassifyPhotoUseCaseProtocol {
    func execute(photo: Photo, image: UIImage) -> AnyPublisher<String, Error>
}

class ClassifyPhotoUseCase: ClassifyPhotoUseCaseProtocol {
    private let repository: PhotoRepositoryProtocol
    private let classificationService: ImageClassificationServiceProtocol
    
    init(repository: PhotoRepositoryProtocol, classificationService: ImageClassificationServiceProtocol) {
        self.repository = repository
        self.classificationService = classificationService
    }
    
    func execute(photo: Photo, image: UIImage) -> AnyPublisher<String, Error> {
        return classificationService.classify(image: image)
            .flatMap { category -> AnyPublisher<String, Error> in
                return self.repository.updateCategory(photoId: photo.id, category: category)
                    .map { category }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
