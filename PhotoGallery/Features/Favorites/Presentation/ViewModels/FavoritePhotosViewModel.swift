//
//  FavoritePhotosViewModel.swift
//  PhotoGallery
//

import Foundation
import Combine

protocol FavoritePhotosViewModelProtocol: ObservableObject {
    var photos: [Photo] { get }
    var isLoading: Bool { get }
    func loadFavorites()
}

class FavoritePhotosViewModel: FavoritePhotosViewModelProtocol {
    @Published var photos: [Photo] = []
    @Published var isLoading: Bool = false
    
    private let getFavoritePhotosUseCase: GetFavoritePhotosUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(getFavoritePhotosUseCase: GetFavoritePhotosUseCaseProtocol) {
        self.getFavoritePhotosUseCase = getFavoritePhotosUseCase
    }
    
    func loadFavorites() {
        isLoading = true
        getFavoritePhotosUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in self?.isLoading = false },
                receiveValue: { [weak self] photos in
                    self?.photos = photos
                }
            )
            .store(in: &cancellables)
    }
}
