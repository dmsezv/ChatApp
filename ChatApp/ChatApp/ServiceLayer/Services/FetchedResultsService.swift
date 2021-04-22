//
//  FetchedResultsService.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 15.04.2021.
//

import CoreData

class FetchedResultService<T: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
    private let fetchRequest: NSFetchRequest<T>
    private let coreDataStack: CoreDataStackProtocol
    
    private lazy var fetchedResultsController: NSFetchedResultsController<T> = {
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return controller
    }()
        
    init(coreDataStack: CoreDataStackProtocol,
         fetchRequest: NSFetchRequest<T>) {
        self.coreDataStack = coreDataStack
        self.fetchRequest = fetchRequest
    }
    
    func setFetchedResultsController(delegate: NSFetchedResultsControllerDelegate?) {
        fetchedResultsController.delegate = delegate
    }
    
    func performFetch(_ errorHandler: (Error?) -> Void) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            errorHandler(error)
        }
    }
    
    func object(at indexPath: IndexPath) -> T {
        fetchedResultsController.object(at: indexPath)
    }
    
    func fetchedObjects() -> [T]? {
        fetchedResultsController.fetchedObjects
    }
}
