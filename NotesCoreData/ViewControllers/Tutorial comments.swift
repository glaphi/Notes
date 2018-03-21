//
//  Tutorial comments.swift
//  NotesCoreData
//
//  Created by Glaphi on 19/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

// The older way to make the note
// To create an instance of the NSManagedObject class, we need 2 ingredients:
// - an entity descriotion
// - a managed object context
// Creating a NSManagedObject original method
//if let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: context) {
//    print(entityDescription.name ?? "No name")
//    print(entityDescription.properties)
//
//    let note = NSManagedObject(entity: entityDescription, insertInto: context)
//    note.setValue(NSDate(), forKey: "createdAt")
//    note.setValue(NSDate(), forKey: "updatedAt")
//    note.setValue("My first note", forKey: "title")
//
//    print(note)
//
//    do { try context.save() } catch {
//        print("Unable to Save Managed Object Context")
//        print("\(error), \(error.localizedDescription)")
//    }
//}


//// Helper for the Core Data Context
//let context = coreDataManager!.managedObjectContext
//
//// Creating Note using automatically generated subclass of NSManagedObject.
//// Since all property of a class or a struct must have a valid initial value
//// By the time the instance is created sets all properties to nil
//let note: Note = Note(context: context)
//note.title = "My default note" // and this is an optional
//// The optionality of the properties is not linked to
//// the 'Optional' checkbox in the 'Data Model Editor'
//note.createdAt = Date()
//note.updatedAt = Date()
