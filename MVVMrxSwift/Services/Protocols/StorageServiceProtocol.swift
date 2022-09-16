//
//  StorageService.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 19.10.2021.
//

import Foundation
import CoreData

protocol StorageServiceProtocol {
    
    static var shared: StorageServiceProtocol { get }
    
    func createNewEntity(forEntityName name: String) -> NSManagedObject
    func fetchData(entityName: String, withPredicate predicate: NSPredicate) -> (data: [NSManagedObject], error: Error?)
    func fetchData(byID id: NSManagedObjectID) -> NSManagedObject
    func fetchAllData(entityName: String) -> (data: [NSManagedObject], error: Error?)
    @discardableResult func deleteData(entity: NSManagedObject) -> Bool
    @discardableResult func saveContext() -> Bool
    
}
