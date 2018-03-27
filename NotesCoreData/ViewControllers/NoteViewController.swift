//
//  NewNoteViewController.swift
//  NotesViews
//
//  Created by Glaphi on 18/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import UIKit

/// Superclass with the basic views for representing the note
/// for other classes to subclass
open class NoteViewController: UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote))
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleTextField.frame = titleTextFieldFrame
        contentTextField.frame = contentTextFieldFrame
    }
    
    @objc func saveNote() {
        // Pop the previous View controller with all the notes
        navigationController?.popViewController(animated: true)
    }
    
    //--------------------------------------------------------------//
    // MARK: - Properties
    lazy var titleTextField: UITextField = {
        var textField: UITextField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var contentTextField: UITextField = {
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
}

