//
//  StorageService.swift
//  MVVMviaBoxing
//
//  Created by Vladislav Miroshnichenko on 19.10.2021.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

final class StorageService {

    public static var shared: StorageServiceProtocol = StorageService()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MVVMrxSwift")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private init() { }
    
}

extension StorageService: StorageServiceProtocol {
    
    public func createNewEntity(forEntityName name: String) -> NSManagedObject {
        let entity = NSEntityDescription.insertNewObject(forEntityName: name, into: context)
        return entity
    }
    
    public func fetchData(entityName: String, withPredicate predicate: NSPredicate) -> (data: [NSManagedObject], error: Error?) {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        
        fetchRequest.predicate = predicate
        
        do {
            let values = try context.fetch(fetchRequest)
    
            return (values, nil)
        } catch let error as NSError {
            return ([], error)
        }
    }
    
    public func fetchData(byID id: NSManagedObjectID) -> NSManagedObject {
        return context.object(with: id)
    }
    
    public func fetchAllData(entityName: String) -> (data: [NSManagedObject], error: Error?) {
        return fetchData(entityName: entityName, withPredicate: NSPredicate(value: true))
    }
    
    @discardableResult public func deleteData(entity: NSManagedObject) -> Bool {
        context.delete(entity)
        return saveContext()
    }
    
    @discardableResult public func saveContext() -> Bool {
        do {
            try context.save()
            context.refreshAllObjects()
            
            return true
        } catch {
            let error = error as NSError
            
            print("Unresolved error \(error), \(error.userInfo)")
            context.rollback()
    
            return false
        }
    }
    
}

