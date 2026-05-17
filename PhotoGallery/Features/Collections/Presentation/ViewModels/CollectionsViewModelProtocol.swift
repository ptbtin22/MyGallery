//
//  CollectionsViewModelProtocol.swift
//  PhotoGallery
//
//  Created by Tin Pham on 17/5/26.
//

import Foundation
import Combine

protocol CollectionsViewModelProtocol: ObservableObject {
    var collections: [PhotoCollection] { get }
    var isLoading: Bool { get }
    var error: Error? { get }
    
    func loadCollections()
    func createCollection(name: String)
}
