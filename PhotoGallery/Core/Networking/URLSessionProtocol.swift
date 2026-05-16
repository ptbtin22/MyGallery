//
//  URLSessionProtocol.swift
//  PhotoGallery
//
//  Created by Tin Pham on 16/5/26.
//

import Foundation
import Combine

protocol URLSessionProtocol {
    func publisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

// MARK: - URLSession

extension URLSession: URLSessionProtocol {
    func publisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return self.dataTaskPublisher(for: url).eraseToAnyPublisher()
    }
}
