//
//  PhotoDTO.swift
//  PhotoGallery
//
//  Created by Tin Pham on 13/12/25.
//

import Foundation

struct PhotoDTO: Identifiable, Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String
    
    func toDomain(size: Int = 300) -> Photo {
        Photo(
            id: id,
            author: author,
            imageUrl: URL(string: "https://picsum.photos/id/\(id)/600/600")!,
            thumbnailUrl: URL(string: "https://picsum.photos/id/\(id)/\(size)/\(size)")!
        )
    }
}
