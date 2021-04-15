//
//  FetchedResultsService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import CoreData

protocol FetchedResultServiceProtocol {
    
}

class FetchedResultService<T: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
    private let fetchRequest: NSFetchRequest<T>
    private let coreDataStack: CoreDataStackProtocol
    
    private lazy var fetchedResultsController: NSFetchedResultsController<T> = {
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.delegate = self
        return controller
    }()
    
    init(coreDataStack: CoreDataStackProtocol,
         fetchRequest: NSFetchRequest<T>) {
        self.coreDataStack = coreDataStack
        self.fetchRequest = fetchRequest
    }
    
    func performFetch(completion: (Error?) -> Void) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            completion(error)
        }
    }
    
    func object(at indexPath: IndexPath) -> T {
        fetchedResultsController.object(at: indexPath)
    }
    
    func fetchedObjects() -> [T]? {
        fetchedResultsController.fetchedObjects
    }
}
