//
//  AppDelegate.swift
//  NotesCoreData
//
//  Created by Glaphi on 13/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // No need to initiate it here
    // Would make more sence to put this to vc
    // So appDelegate isn't bothered with Core Data at all
    private let coreDataManager = CoreDataManager(modelName: "Notes")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Wrapping notes in the Navigation Controller
        // NotesViewController is the root and it has
        // the reference to coreDataManager
        let navigationController = UINavigationController(rootViewController: NotesViewController(coreDataManager))
        
        // Making navigation controller visible
        // Views will not be covered by it
        navigationController.navigationBar.isTranslucent = false
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

