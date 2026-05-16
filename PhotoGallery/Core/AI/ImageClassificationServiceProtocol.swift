//
//  ImageClassificationServiceProtocol.swift
//  PhotoGallery
//
//  Created by Tin Pham on 16/5/26.
//

import UIKit
import Combine

protocol ImageClassificationServiceProtocol {
    func classify(image: UIImage) -> AnyPublisher<String, Error>
}
