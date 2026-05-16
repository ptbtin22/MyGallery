//
//  ImageClassificationService.swift
//  PhotoGallery
//

import UIKit
import Vision
import Combine

class VisionClassificationService: ImageClassificationServiceProtocol {
    func classify(image: UIImage) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            // Resize image to 224x224 (standard for many models) to save memory and avoid espresso context issues
            let size = CGSize(width: 224, height: 224)
            UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            guard let finalImage = resizedImage, let ciImage = CIImage(image: finalImage) else {
                promise(.failure(NSError(domain: "VisionClassificationService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create CIImage"])))
                return
            }
            
            let request = VNClassifyImageRequest { request, error in
                if let error {
                    print("Vision Request Error: \(error)")
                    promise(.failure(error))
                    return
                }
                
                guard let observations = request.results as? [VNClassificationObservation] else {
                    promise(.failure(NSError(domain: "VisionClassificationService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No results found"])))
                    return
                }
                
                // Get the top result with highest confidence
                if let topResult = observations.first(where: { $0.confidence > 0.3 }) {
                    promise(.success(topResult.identifier))
                } else {
                    promise(.success("Unknown"))
                }
            }
            
            // Try using an older revision if available, which might be more compatible with simulators
            request.revision = VNClassifyImageRequestRevision1
            
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("Vision Handler Error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
