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
}
