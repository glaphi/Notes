//
//  CoreDataManager.swift
//  NotesCoreData
//
//  Created by Glaphi on 13/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "Notes")

    // Mark: - Initialisation
    private init(modelName: String) {
        self.modelName = modelName
        
        setupNotigicationHandling()
    }
    
    //--------------------------------------------------------------//
    // Mark: - Private Properties
    private let modelName: String
    
    // To set up Core Data we need to initiate 3 objects:
    // - Managed Object Context
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        // Every parent Managed Object Context keeps a reference to
        // the Persistent Store Coordinator of the Core Data Stack
        // Configure persistentStoreCoordinator property of the Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    // - Managed Object Model
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to find Data Model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load Data Model")
        }
        return managedObjectModel
    }()
    
    // - Persistent Store Coordinator
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        // Helpers
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        // URL Documets Directory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
        // URL Persistent Store
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        // Core Data stack is only functional once the Persistent Store is added
        // to the Persistent Store Coordinator
        do {
            // Add persistent store
            let options = [ NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true ]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
        }
        catch {
            fatalError("Unable to add Persistent Store")
        }
        return persistentStoreCoordinator
    }()
    
    //--------------------------------------------------------------//
    // Mark - Private Functions
    private func setupNotigicationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: Notification.Name.UIApplicationWillTerminate, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    private func saveChanges() {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch {
            print("Unable to Save Managed Object Context")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    @objc private func saveChanges(_ notification: Notification) {
        let notificationString: String = notification.description
        print(notificationString)
        saveChanges()
    }
}
