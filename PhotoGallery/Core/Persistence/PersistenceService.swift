//
//  PersistenceServiceProtocol.swift
//  PhotoGallery
//

import Foundation
import CoreData
import Combine

protocol PersistenceServiceProtocol {
    var viewContext: NSManagedObjectContext { get }
    func save() -> AnyPublisher<Void, Error>
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> AnyPublisher<[T], Error>
    func delete(_ object: NSManagedObject) -> AnyPublisher<Void, Error>
}

extension PersistenceController: PersistenceServiceProtocol {
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save() -> AnyPublisher<Void, Error> {
        Future { promise in
            let context = self.container.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            } else {
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> AnyPublisher<[T], Error> {
        Future { promise in
            do {
                let results = try self.container.viewContext.fetch(request)
                promise(.success(results))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(_ object: NSManagedObject) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.container.viewContext.delete(object)
            self.save().sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                },
                receiveValue: { _ in
                    promise(.success(()))
                }
            ).store(in: &CancellableBag.shared.subscriptions)
        }.eraseToAnyPublisher()
    }
}

class CancellableBag {
    static let shared = CancellableBag()
    var subscriptions = Set<AnyCancellable>()
}
