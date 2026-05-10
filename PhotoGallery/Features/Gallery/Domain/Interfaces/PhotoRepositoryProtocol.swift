//
//  PhotoRepositoryProtocol.swift
//  PhotoGallery
//

import Foundation
import Combine

protocol PhotoRepositoryProtocol {
    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error>
    func toggleFavorite(photo: Photo) -> AnyPublisher<Void, Error>
    func getFavoritePhotos() -> AnyPublisher<[Photo], Error>
    func searchPhotos(query: String) -> AnyPublisher<[Photo], Error>
}
