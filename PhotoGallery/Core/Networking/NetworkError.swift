//
//  NetworkError.swift
//  PhotoGallery
//

import Foundation

enum NetworkError: Error {
    case badURL
    case serverError(statusCode: Int)
    case decodingError
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "The URL is invalid."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .decodingError:
            return "Failed to decode the response."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
