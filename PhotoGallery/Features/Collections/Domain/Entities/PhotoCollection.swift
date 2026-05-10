//
//  PhotoCollection.swift
//  PhotoGallery
//

import Foundation

struct PhotoCollection: Identifiable, Equatable {
    let id: String
    let name: String
    let createdAt: Date
    let photos: [Photo]
    
    static func == (lhs: PhotoCollection, rhs: PhotoCollection) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.photos.count == rhs.photos.count
    }
}
