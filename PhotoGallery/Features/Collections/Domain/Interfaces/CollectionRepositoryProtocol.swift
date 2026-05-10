//
//  CollectionRepositoryProtocol.swift
//  PhotoGallery
//

import Foundation
import Combine

protocol CollectionRepositoryProtocol {
    func fetchCollections() -> AnyPublisher<[PhotoCollection], Error>
    func createCollection(name: String) -> AnyPublisher<PhotoCollection, Error>
    func deleteCollection(id: String) -> AnyPublisher<Void, Error>
    func addPhotoToCollection(photoId: String, collectionId: String) -> AnyPublisher<Void, Error>
    func removePhotoFromCollection(photoId: String, collectionId: String) -> AnyPublisher<Void, Error>
}
