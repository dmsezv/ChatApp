//
//  CoreDataStack.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 31.03.2021.
//

import Foundation
import CoreData

enum CoreDataEntityName: String {
    case messages = "MessageDB"
    case channels = "ChannelDB"
}

class CoreDataStack {
    private init() {}
    static let shared = CoreDataStack()
    
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).last else {
            fatalError("document path not found")
        }
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    let entityChannelDBName = String(describing: ChannelDB.self)
    let entityMessageDBName = String(describing: MessageDB.self)
    
    // MARK: - Init Stack
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
            fatalError("model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("managedObjectModel could not be created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeUrl,
                                               options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return coordinator
    }()
    
    // MARK: - Contexts
    
    private lazy var writtenContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writtenContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Context
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                try context.obtainPermanentIDs(for: Array(context.updatedObjects))
                try context.obtainPermanentIDs(for: Array(context.deletedObjects))

                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
            
        if let parent = context.parent {
            performSave(in: parent)
        }
    }
    
    // MARK: - Core Data Observers
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc
    private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
           inserts.count > 0 {
            self.printOutput("Count objects added: \(inserts.count)")
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           updates.count > 0 {
            self.printOutput("Count objects updated: \(updates.count)")
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            self.printOutput("Count objects deleted: \(deletes.count)")
        }
    }
    
    // MARK: - Core Data Logs
    
    func printDatabaseStatistics() {
        mainContext.perform {
            do {
                self.printOutput("-------")
                
                let countChannels = try self.mainContext.count(for: ChannelDB.fetchRequest())
                self.printOutput("\(countChannels) channels")
                
                let countMessages = try self.mainContext.count(for: MessageDB.fetchRequest())
                self.printOutput("\(countMessages) messages")
                self.printOutput("About:")
                let arrayChannels = try self.mainContext.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] ?? []
                arrayChannels.forEach { ($0.about()) }
                
                self.printOutput("-------")
            } catch {
                self.printOutput(error.localizedDescription)
            }
        }
    }
}

// MARK: - Copy Read Update Delete
// TODO: - add update

extension CoreDataStack {
    func delete(from entity: CoreDataEntityName, in context: NSManagedObjectContext, by predicate: NSPredicate) {
        let request = NSFetchRequest<NSManagedObject>(entityName: entity.rawValue)
        request.predicate = predicate
        
        do {
            let objs = try context.fetch(request)
            objs.forEach { context.delete($0) }
        } catch {
            printOutput(error.localizedDescription)
        }
    }
    
    func read(from entity: CoreDataEntityName, in context: NSManagedObjectContext, by predicate: NSPredicate? = nil) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSManagedObject>(entityName: entity.rawValue)
        request.predicate = predicate
        
        do {
            let res = try context.fetch(request)
            return res
        } catch {
            printOutput(error.localizedDescription)
            return nil
        }
    }
}
