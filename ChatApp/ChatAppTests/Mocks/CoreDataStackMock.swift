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
    var deleteEntityName: CoreDataEntityName?

    // Counters

    var performSaveCallCount = 0
    var deleteCallCount = 0
    var readCallCount = 0

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
