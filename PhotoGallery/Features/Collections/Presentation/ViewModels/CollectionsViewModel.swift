//
//  CollectionsViewModel.swift
//  PhotoGallery
//

import Foundation
import Combine

class CollectionsViewModel: CollectionsViewModelProtocol {
    @Published var collections: [PhotoCollection] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let getCollectionsUseCase: GetCollectionsUseCaseProtocol
    private let createCollectionUseCase: CreateCollectionUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getCollectionsUseCase: GetCollectionsUseCaseProtocol,
        createCollectionUseCase: CreateCollectionUseCaseProtocol
    ) {
        self.getCollectionsUseCase = getCollectionsUseCase
        self.createCollectionUseCase = createCollectionUseCase
    }
    
    func loadCollections() {
        isLoading = true
        getCollectionsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] collections in
                self?.collections = collections
            }
            .store(in: &cancellables)
    }
    
    func createCollection(name: String) {
        createCollectionUseCase.execute(name: name)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] newCollection in
                self?.collections.insert(newCollection, at: 0)
            }
            .store(in: &cancellables)
    }
}
