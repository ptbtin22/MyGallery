//
//  MockURLSession.swift
//  PhotoGalleryTests
//
//  Created by Tin Pham on 16/5/26.
//

import Foundation
import Combine
@testable import PhotoGallery

class MockURLSession {
    var dataToReturn: Data?
    var responseToReturn: URLResponse?
    var errorToReturn: URLError?
}

// MARK: - URLSessionProtocol

extension MockURLSession: URLSessionProtocol {
    func publisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        if let error = errorToReturn {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let data = dataToReturn ?? Data()
        let response = responseToReturn ?? HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
