//
//  AddNoteViewController.swift
//  NotesCoreData
//
//  Created by Glaphi on 22/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import CoreData

class AddNoteViewController: NoteViewController {
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.managedObjectContext
    }
    
    //--------------------------------------------------------------//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String.newNoteViewControllerTitle
    }

    //--------------------------------------------------------------//
    /// Save new `Note` with CoreData and pop the root view
    @objc internal override func saveNote() {
        print("saveNote")
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(with: "Title Missing", and: "Please put the title")
            return
        }
        // Create the Note
        let note: Note = Note(context: context)
        note.createdAt = Date()
        note.updatedAt = Date()
        note.title = titleTextField.text
        note.contents = contentTextField.text
        // Pop the previous View controller with all the notes
        super.saveNote()
    }
}


