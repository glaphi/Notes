//
//  NotesViewController.swift
//  NotesCoreData
//
//  Created by Glaphi on 13/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {

    // MARK: - Properties
    var context: NSManagedObjectContext!

    //--------------------------------------------------------------//
    convenience init(_ manager: CoreDataManager) {
        self.init(nibName: nil, bundle: nil)
        self.context = manager.managedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //View Setup
        viewSetup()
        configureTableView()
        notificationHandlingSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch notes from the persistent store
        fetchNotes()
    }
    
    //--------------------------------------------------------------//
    // MARK: - Private Properties
    private var notes: [Note]? {
        didSet { updateUI() }
    }
    
    //--------------------------------------------------------------//
    // MARK: - Private functions
    private func updateUI() {
        tableView.isHidden = (notes == nil)
    }
    
    /// Fetching the notes from the persistent store
    private func fetchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        // Sorting the fetch notes by the updated date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        
        context.performAndWait {
            do {
                let notes = try fetchRequest.execute()
                self.notes = notes
                self.tableView.reloadData()
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request: ")
                print("\(fetchRequest), \(fetchError.localizedDescription)")
            }
        }
    }
    
    /// Set up the view
    private func viewSetup() {
        view.backgroundColor = UIColor.white
        self.title = String.notesViewControllerTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    /// Configure TableView DataSource, Delegate and register Cell
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.id)
    }
    
    private func notificationHandlingSetup() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        // If we had more contexts, it should only observe the
        // managed object context the object is interested in
    }
    
    // Updating the notes array according to changes made in the
    // managed object context and updating UI
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        var notesDidChange = false
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            for insert in inserts {
                if let note = insert as? Note {
                    notes?.append(note)
                    notesDidChange = true
                }
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            for update in updates {
                if let _ = update as? Note {
                    notesDidChange = true
                }
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            for delete in deletes {
                if let note = delete as? Note {
                    if let index = notes?.index(of: note){
                        notes?.remove(at: index)
                        notesDidChange = true
                    }
                }
            }
        }
        
        if notesDidChange {
            // FIX IT: - dates format and !
            notes?.sort(by: { $0.updatedAt! > $1.updatedAt! })
            tableView.reloadData()
            updateUI()
        }

    }
    
    /// Push the NewNoteViewController with reference to managedObjectContext
    @objc private func addButtonTapped(_ bar: UIBarButtonItem) {
        guard context != nil else { return }
        navigationController?.pushViewController(AddNoteViewController(context), animated: true)
    }
    
}

//--------------------------------------------------------------//
// Extensions

// MARK: - Table View DataSource
extension NotesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (notes != nil) ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the notes
        guard let note: Note = notes?[indexPath.row] else {
            fatalError("Unexpected Index Path for Note")
        }
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: NoteCell.id, for: indexPath) as? NoteCell else {
            fatalError("Unexpected Index Path for Cell")
        }
        cell.titleLabel.text = note.title
        cell.contentLabel.text = note.contents
        cell.updatedAtLabel.text = note.updatedAt?.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let note = notes?[indexPath.row] else {
            fatalError("Unexpected Index Path for Note")
        }
        // Deleting the note from the Managed Object Context to which it belongs
        note.managedObjectContext?.delete(note)
        // Deleting the note from the Core Data Manager context (which is here the same)
        //context.delete(note)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = notes?[indexPath.row] else {
            fatalError("Unexpected Index Path for Note")
        }
        navigationController?.pushViewController(EditNoteViewController(note), animated: true)
    }
}

// MARK: - Table View Delegate
extension NotesViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}

