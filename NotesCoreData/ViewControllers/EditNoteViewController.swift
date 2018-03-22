//
//  EditNoteViewController.swift
//  NotesCoreData
//
//  Created by Glaphi on 22/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import UIKit

class EditNoteViewController: NoteViewController {
    
    var note: Note!
    
    convenience init(_ note: Note) {
        self.init(nibName: nil, bundle: nil)
        self.note = note
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View Setup
        title = String.editNoteViewControllerTitle
        self.titleTextField.text = note.title
        self.contentTextField.text = note.contents
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if note.contents != contentTextField.text {
            note.updatedAt = Date()
            note.contents = contentTextField.text
        }
        if let title = titleTextField.text, !title.isEmpty {
            if note.title != title {
                note.updatedAt = Date()
                note.title = title
            }
        }
    }
}
