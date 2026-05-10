//
//  Photo.swift
//  PhotoGallery
//
//  Created by Tin Pham on 13/12/25.
//

import Foundation

struct Photo: Identifiable, Equatable {
    let id: String
    let author: String
    let imageUrl: URL
    let thumbnailUrl: URL
    var isFavorite: Bool = false
}
