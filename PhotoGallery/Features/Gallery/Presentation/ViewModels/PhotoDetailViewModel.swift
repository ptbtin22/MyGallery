//
//  PhotoDetailViewModel.swift
//  PhotoGallery
//

import Foundation
import Combine
import UIKit

protocol PhotoDetailViewModelProtocol: ObservableObject {
    var photo: Photo { get }
    var isFavorite: Bool { get }
    var collections: [PhotoCollection] { get }
    var isAddingToCollection: Bool { get }
    var detectedCategory: String? { get }
    
    func toggleFavorite()
    func loadCollections()
    func addToCollection(_ collection: PhotoCollection)
    func classifyImage(_ image: UIImage)
}

class PhotoDetailViewModel: PhotoDetailViewModelProtocol {
    @Published var photo: Photo
    @Published var isFavorite: Bool
    @Published var collections: [PhotoCollection] = []
    @Published var isAddingToCollection: Bool = false
    @Published var detectedCategory: String?
    
    private let toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol
    private let getCollectionsUseCase: GetCollectionsUseCaseProtocol
    private let addPhotoToCollectionUseCase: AddPhotoToCollectionUseCaseProtocol
    private let classifyPhotoUseCase: ClassifyPhotoUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        photo: Photo,
        toggleFavoriteUseCase: ToggleFavoriteUseCaseProtocol,
        getCollectionsUseCase: GetCollectionsUseCaseProtocol,
        addPhotoToCollectionUseCase: AddPhotoToCollectionUseCaseProtocol,
        classifyPhotoUseCase: ClassifyPhotoUseCaseProtocol
    ) {
        self.photo = photo
        self.isFavorite = photo.isFavorite
        self.detectedCategory = photo.category
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.getCollectionsUseCase = getCollectionsUseCase
        self.addPhotoToCollectionUseCase = addPhotoToCollectionUseCase
        self.classifyPhotoUseCase = classifyPhotoUseCase
    }
    
    func toggleFavorite() {
        toggleFavoriteUseCase.execute(photo: photo)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.isFavorite.toggle()
                    self?.photo.isFavorite.toggle()
                }
            )
            .store(in: &cancellables)
    }
    
    func loadCollections() {
        getCollectionsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] collections in
                    self?.collections = collections
                }
            )
            .store(in: &cancellables)
    }
    
    func addToCollection(_ collection: PhotoCollection) {
        isAddingToCollection = true
        addPhotoToCollectionUseCase.execute(photoId: photo.id, collectionId: collection.id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isAddingToCollection = false
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    func classifyImage(_ image: UIImage) {
        // Only classify if category is missing or unknown
        guard detectedCategory == nil || detectedCategory == "Unknown" else { return }
        
        classifyPhotoUseCase.execute(photo: photo, image: image)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] category in
                    self?.detectedCategory = category
                    self?.photo.category = category
                }
            )
            .store(in: &cancellables)
    }
}
