//
//  viewController+CoreData.swift
//  MyGames
//
//  Created by Jair Guedes Ferreira Neto on 13/2/18.
//  Copyright © 2018 Pay Back $istemas. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
