//
//  APIEndpoint.swift
//  PhotoGallery
//
//  Created by Tin Pham on 13/12/25.
//

import Foundation

enum APIEndpoint {
    case photos(page: Int, limit: Int = 30)
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "picsum.photos"
        components.path = "/v2/list"
        
        switch self {
        case .photos(let page, let limit):
            components.queryItems = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        }
        
        return components.url
    }
}
