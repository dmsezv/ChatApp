//
//  CoreDataStackMock.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 05.05.2021.
//

import Foundation
import CoreData

@testable import ChatApp

class CoreDataStackMock: CoreDataStackProtocol {
    var mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    private var performSaveCallCount = 0
    private var deleteCallCount = 0
    private var readCallCount = 0
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        performSaveCallCount += 1
    }
    
    func delete(from entity: CoreDataEntityName, in context: NSManagedObjectContext, by predicate: NSPredicate) {
        deleteCallCount += 1
    }
    
    func read(from entity: CoreDataEntityName, in context: NSManagedObjectContext, by predicate: NSPredicate?) -> [NSManagedObject]? {
        readCallCount += 1
        return nil
    }
}
