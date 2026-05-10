//
//  PhotosViewModel.swift
//  PhotoGallery
//

import Foundation
import Combine

class PhotosViewModel: PhotosViewModelProtocol {
    @Published var photos: [Photo] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var searchQuery: String = ""
    
    private let getPhotosUseCase: GetPhotosUseCaseProtocol
    private var currentPage = 1
    private var canLoadMore = true
    private var cancellables = Set<AnyCancellable>()
    
    init(getPhotosUseCase: GetPhotosUseCaseProtocol) {
        self.getPhotosUseCase = getPhotosUseCase
        setupSearch()
    }
    
    private func setupSearch() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.searchPhotos()
            }
            .store(in: &cancellables)
    }
    
    func loadPhotos() {
        guard !isLoading else { return }
        
        isLoading = true
        currentPage = 1
        canLoadMore = true
        
        getPhotosUseCase.execute(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case let .failure(error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] newPhotos in
                    self?.photos = newPhotos
                    self?.currentPage += 1
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMorePhotos() {
        guard !isLoading && canLoadMore else { return }
        
        isLoading = true
        
        getPhotosUseCase.execute(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case let .failure(error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] newPhotos in
                    if newPhotos.isEmpty {
                        self?.canLoadMore = false
                    } else {
                        self?.photos.append(contentsOf: newPhotos)
                        self?.currentPage += 1
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func searchPhotos() {
        // Implementation for search
        // For simplicity, let's just trigger a reload if query is empty
        if searchQuery.isEmpty {
            loadPhotos()
        } else {
            // Filter existing or fetch from search use case if we had one
            // Let's assume we just filter local for now or reload first page
            loadPhotos() 
        }
    }
    
    func toggleFavorite(photo: Photo) {
        // This could be handled by a specific use case
        // But for the list view, we might just update the local state
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[index].isFavorite.toggle()
        }
    }
}
