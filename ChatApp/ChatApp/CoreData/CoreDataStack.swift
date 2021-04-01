//
//  CoreDataStack.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 31.03.2021.
//

import Foundation
import CoreData

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
            print("Count objects added: ", inserts.count)
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           updates.count > 0 {
            print("Count objects updated: ", updates.count)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            print("Count objects deleted: ", deletes.count)
        }
    }
    
    // MARK: - Core Data Logs
    
    func printDatabaseStatistics() {
        mainContext.perform {
            do {
                let countChannels = try self.mainContext.count(for: ChannelDB.fetchRequest())
                print("\(countChannels) Channels")
                
                let arrayChannels = try self.mainContext.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] ?? []
                arrayChannels.forEach { ($0.about()) }
                
                
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
    
