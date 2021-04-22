//
//  ICoreDataStack.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.04.2021.
//

import CoreData

protocol CoreDataStackProtocol {
    var mainContext: NSManagedObjectContext { get }
    
    func performSave(_ block: (NSManagedObjectContext) -> Void)
    func delete(from entity: CoreDataEntityName, in context: NSManagedObjectContext, by predicate: NSPredicate)
    func read(from entity: CoreDataEntityName, in context: NSManagedObjectContext, by predicate: NSPredicate?) -> [NSManagedObject]?
}
