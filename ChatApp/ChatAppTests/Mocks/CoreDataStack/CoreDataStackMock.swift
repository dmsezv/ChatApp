//
//  CoreDataStackMock.swift
//  ChatAppTests
//
//  Created by Dmitrii Zverev on 05.05.2021.
//

@testable import ChatApp
import Foundation
import CoreData

class CoreDataStackMock: CoreDataStackProtocol {
    var deleteEntityName: CoreDataEntityName?

    // Counters

    private(set) var performSaveCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var readCallCount = 0

    var mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        performSaveCallCount += 1
        block(mainContext)
    }

    func delete(from entity: CoreDataEntityName, in context: NSManagedObjectContext, by predicate: NSPredicate) {
        deleteEntityName = entity
        deleteCallCount += 1
    }

    func read(from entity: CoreDataEntityName,
              in context: NSManagedObjectContext,
              by predicate: NSPredicate?) -> [NSManagedObject]? {
        readCallCount += 1
        return nil
    }
}
