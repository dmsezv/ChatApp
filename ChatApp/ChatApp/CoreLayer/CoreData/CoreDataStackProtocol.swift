//
//  ICoreDataStack.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 13.04.2021.
//

import CoreData

protocol CoreDataStackProtocol {
    func performSave(_ block: (NSManagedObjectContext) -> Void)
}
