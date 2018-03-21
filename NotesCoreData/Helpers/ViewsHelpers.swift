//
//  ViewsHelpers.swift
//  NotesCoreData
//
//  Created by Glaphi on 19/03/2018.
//  Copyright © 2018 Glaphi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Alerts
    func showAlert(with title: String,and message: String){
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Present Alert Controller
        present(alertController, animated: true, completion: nil)
    }
}

