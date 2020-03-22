//
//  ItemController.swift
//  Assessment2
//
//  Created by Hin Wong on 3/6/20.
//  Copyright © 2020 Hin Wong. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    //MARK:- shared instance
    
    static let sharedInstance = ItemController()
    var fetchedResultsController : NSFetchedResultsController<Item>
    
    //MARK:- Source of truth
    
    init() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "isComplete", ascending: true)]
        
        let resultsController: NSFetchedResultsController<Item> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error \(error.localizedDescription)")
        }
    }
    
    //MARK:- CRUD Functions

    func add(name: String) {
        Item(name: name)
        saveToPersistenceStore()
    }

    func update(item: Item, name:String) {
        item.name = name
        saveToPersistenceStore()
    }

    func delete(item: Item) {
        CoreDataStack.context.delete(item)
        saveToPersistenceStore()
    }
    
    func toggling(item: Item) {
        item.isComplete = !item.isComplete
        saveToPersistenceStore()
    }

    private func saveToPersistenceStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error with saving data")
        }
    }
}


