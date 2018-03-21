//
//  NewNoteViewController.swift
//  NotesViews
//
//  Created by Glaphi on 18/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import UIKit
import CoreData

class NewNoteViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    
    convenience init(_ context: NSManagedObjectContext) {
        self.init(nibName: nil, bundle: nil)
        self.managedObjectContext = context
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        title = String.newNoteViewControllerTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote))
    }
    
    override func viewDidLayoutSubviews() {
        titleTextField.frame = titleTextFieldFrame
        contentTextField.frame = contentTextFieldFrame
    }
    
    private lazy var titleTextField: UITextField = {
        var textField: UITextField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private lazy var contentTextField: UITextField = {
        var textField: UITextField = UITextField()
        textField.textAlignment = .left
        textField.contentVerticalAlignment = .top
        return textField
    }()
    
    private var titleTextFieldFrame: CGRect {
        let paddingX: CGFloat = 5
        let offsetY: CGFloat = 5
        let width: CGFloat = view.bounds.width - 2 * paddingX
        let height: CGFloat = view.bounds.height/15
        let frame = CGRect(x: paddingX, y: offsetY, width: width, height: height)
        return frame
    }
    
    private var contentTextFieldFrame: CGRect {
        let offsetY: CGFloat = 5
        var frame: CGRect = titleTextFieldFrame
        frame.origin.y = frame.height + offsetY
        let height: CGFloat = view.bounds.height - frame.height
        frame.size.height = height
        return frame
    }
    
    /// Save new `Note` with CoreData and pop the root view
    @objc func saveNote() {
        print("saveNote")
        guard let context = managedObjectContext else { return }
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
        _ = navigationController?.popViewController(animated: true)
    }
}

