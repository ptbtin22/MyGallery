//
//  NetworkService.swift
//  PhotoGallery
//

import Foundation
import Combine

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error> {
        guard let url = APIEndpoint.photos(page: page).url else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw NetworkError.serverError(statusCode: code)
                }
                return data
            }
            .decode(type: [PhotoDTO].self, decoder: decoder)
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    func searchPhotos(query: String) -> AnyPublisher<[Photo], Error> {
        // Mock search or use a real search endpoint if available
        // For now, let's just fetch photos and filter locally if search endpoint isn't defined
        // but let's assume there is one or we fetch all and filter.
        // Actually, let's just use the fetchPhotos for now but return empty or filtered results.
        return fetchPhotos(page: 1)
            .map { photos in
                photos.filter { $0.author.lowercased().contains(query.lowercased()) }
            }
            .eraseToAnyPublisher()
    }
}
