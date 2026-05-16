//
//  FavoritePhotosViewModelProtocol.swift
//  PhotoGallery
//
//  Created by Tin Pham on 16/5/26.
//

import Foundation
import Combine

protocol FavoritePhotosViewModelProtocol: ObservableObject {
    var photos: [Photo] { get }
    var isLoading: Bool { get }
    func loadFavorites()
}
