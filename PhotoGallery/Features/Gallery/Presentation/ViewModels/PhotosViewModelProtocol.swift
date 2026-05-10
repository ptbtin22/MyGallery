//
//  PhotosViewModelProtocol.swift
//  PhotoGallery
//

import Foundation
import Combine

protocol PhotosViewModelProtocol: ObservableObject {
    var photos: [Photo] { get }
    var isLoading: Bool { get }
    var error: Error? { get }
    var searchQuery: String { get set }
    
    func loadPhotos()
    func loadMorePhotos()
    func searchPhotos()
    func toggleFavorite(photo: Photo)
}
