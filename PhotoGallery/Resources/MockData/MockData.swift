//
//  MockData.swift
//  PhotoGallery
//

import Foundation

struct MockData {
    static let samplePhotos: [Photo] = [
        Photo(
            id: "1",
            author: "Alejandro Escamilla",
            imageUrl: URL(string: "https://picsum.photos/id/0/5000/3333")!,
            thumbnailUrl: URL(string: "https://picsum.photos/id/0/300/200")!,
            isFavorite: false
        ),
        Photo(
            id: "2",
            author: "Paul Jarvis",
            imageUrl: URL(string: "https://picsum.photos/id/10/2500/1667")!,
            thumbnailUrl: URL(string: "https://picsum.photos/id/10/300/200")!,
            isFavorite: true
        ),
        Photo(
            id: "3",
            author: "Tina Rataj",
            imageUrl: URL(string: "https://picsum.photos/id/100/2500/1656")!,
            thumbnailUrl: URL(string: "https://picsum.photos/id/100/300/200")!,
            isFavorite: false
        )
    ]
}
