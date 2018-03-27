//
//  NotesViewController.swift
//  NotesCoreData
//
//  Created by Glaphi on 13/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //View Setup
        viewSetup()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch notes from the persistent store
        fetchNotes()
        updateUI()
    }
    
    //--------------------------------------------------------------//
    // MARK: - Private Properties
    private var context: NSManagedObjectContext {
        return CoreDataManager.shared.managedObjectContext
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        
        let fetchedRequestController: NSFetchedResultsController<Note> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRequestController.delegate = self
        
        return fetchedRequestController
    }()
    
    private var hasNotes: Bool {
        guard let fetchedObjects: [Note] = fetchedResultsController.fetchedObjects else {
            return false
        }
        return fetchedObjects.count > 0
    }
    //--------------------------------------------------------------//
    // MARK: - Private functions
    private func updateUI() {
        if !hasNotes {
            view.backgroundColor = UIColor.gray
            tableView.isHidden = true
        }
    }
    
    /// Fetching the notes from the persistent store
    private func fetchNotes() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
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
    
    /// Helper method to configure cell's attribures in table view
    func configure(_ cell: NoteCell, at indexPath: IndexPath) {
        let note: Note = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = note.title
        cell.contentLabel.text = note.contents
        cell.updatedAtLabel.text = note.updatedAt?.description
    }
    
    /// Push the NewNoteViewController with reference to managedObjectContext
    @objc private func addButtonTapped(_ bar: UIBarButtonItem) {        navigationController?.pushViewController(AddNoteViewController(), animated: true)
    }
    
}

//--------------------------------------------------------------//
// Extensions

// MARK: - Table View DataSource
extension NotesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the notes
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: NoteCell.id, for: indexPath) as? NoteCell else {
            fatalError("Unexpected Index Path for Cell")
        }
        configure(cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let note: Note = fetchedResultsController.object(at: indexPath)
        // Deleting the note from the Managed Object Context to which it belongs
        //note.managedObjectContext?.delete(note)
        // Deleting the note from the Core Data Manager context (which is here the same)
        context.delete(note)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note: Note = fetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(EditNoteViewController(note), animated: true)
    }
}

// MARK: - Table View Delegate
extension NotesViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}

// MARK: - NS Fetched Results Controller Delegate
extension NotesViewController {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // inform table view about upcoming updates
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // inform table view we finished sending updates
        tableView.endUpdates()
        updateUI()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // NSFetchedResultsChangeType can be insert, delete, update, move
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? NoteCell {
                configure(cell, at: indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            return
        }
    }
}
