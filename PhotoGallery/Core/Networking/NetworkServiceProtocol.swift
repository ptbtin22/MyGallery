//
//  NetworkServiceProtocol.swift
//  PhotoGallery
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error>
    func searchPhotos(query: String) -> AnyPublisher<[Photo], Error>
}
