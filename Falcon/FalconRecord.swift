//
//  FalconRecord.swift
//  Habit
//
//  Created by Tayson Nguyen on 2015-08-21.
//  Copyright (c) 2015 Tayson Nguyen. All rights reserved.
//

import Foundation
import CoreData

public class FalconRecord {
    
    public fileprivate(set) static var bundleName: String = {
        let infoDict = Bundle.main.infoDictionary
        return infoDict!["CFBundleName"] as! String
        }()
    
    public static var defaultDirectory: String {
        return NSPersistentContainer.defaultDirectoryURL().path
    }
    
    public fileprivate(set) static var documentsDirectory: String = {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        }()
    
    public private(set) static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: bundleName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    public static var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    public static func resetCoreDataStack() {
        container = NSPersistentContainer(name: bundleName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension NSPersistentContainer {
    public func newViewContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }
}

extension NSManagedObjectContext {
    public func childContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: concurrencyType)
        context.parent = self
        return context
    }
    
    public func saveContext() {
        do {
            try save()
        } catch {
            print(error)
        }
    }
    
    public func save(_ completion: @escaping (Result<Void>) -> Void) {
        
        perform { [weak self] in
            do {
                try self?.save()
                completion(Result.success())
                
            } catch {
                completion(Result.failure(error))
            }
        }
    }
    
}

private func objcast<T>(_ obj: AnyObject) -> T {
    return obj as! T
}

extension NSManagedObject {
    
    public func delete() {
        managedObjectContext?.delete(self)
    }
    
    public static func find(in context: NSManagedObjectContext = FalconRecord.viewContext,
                               where format: String? = nil, _ args: CVarArg...) -> [NSManagedObject] {
        
        let fetchRequest = self.requestAll()
        
        if let format = format {
            let pred = withVaList(args) { (pointer) -> NSPredicate in
                return NSPredicate(format: format, arguments: pointer)
            }
            
            fetchRequest.predicate = pred
        }

        var result = [NSManagedObject]()
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest) as! [NSManagedObject]
            } catch {
                result = [NSManagedObject]()
            }
        }
        return result
    }
    
    public static func find(in context: NSManagedObjectContext = FalconRecord.viewContext,
                               where format: String? = nil,
                                     _ args: CVarArg...,
        completion: @escaping (Result<[NSManagedObject]>) -> Void) {
        
        var predicate: NSPredicate? = nil
        
        if let format = format {
            let pred = withVaList(args) { (pointer) -> NSPredicate in
                return NSPredicate(format: format, arguments: pointer)
            }
            predicate = pred
        }
        
        self.find(in: context, with: predicate, completion: completion)
    }
    
    public static func find(in context: NSManagedObjectContext,
                               with predicate: NSPredicate?,
                                    completion: @escaping (Result<[NSManagedObject]>) -> Void) {
        
        let fetchRequest = self.requestAll()
        fetchRequest.predicate = predicate
        
        context.perform {
            do {
                let objects = try context.fetch(fetchRequest) as! [NSManagedObject]
                completion(Result.success(objects))
                
            } catch {
                completion(Result.failure(error))
            }
        }
    }
    
    public func inContext(_ context: NSManagedObjectContext) -> Self {
        if managedObjectContext == context {
            return self
        } else {
            return objcast(context.object(with: objectID))
        }
    }
    
    public static func requestAll() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        return fetchRequest
    }
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}
