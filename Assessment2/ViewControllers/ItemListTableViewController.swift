//
//  ItemListTableViewController.swift
//  Assessment2
//
//  Created by Hin Wong on 3/6/20.
//  Copyright © 2020 Hin Wong. All rights reserved.
//

import UIKit
import CoreData

class ItemListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ItemController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        //Create the alert
        let alert = UIAlertController(title: "Add item", message: "Add item to the list", preferredStyle: .alert)
        
        //Add a text field
        alert.addTextField(configurationHandler: nil)
        
        //Create cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        //Create add button
        let addButton = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let item = alert.textFields?[0].text, item != "" else {return}
            ItemController.sharedInstance.add(name: item)
            
            //reload data
            self.tableView.reloadData()
        }
        
        //Add our buttons to the alert
        alert.addAction(cancelButton)
        alert.addAction(addButton)
        
        //Present our alert
        self.present(alert, animated: true)
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ItemController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ItemController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else {return UITableViewCell ()}

        let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        cell.delegate = self
        cell.update(item: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ItemController.sharedInstance.fetchedResultsController.sectionIndexTitles[section] == "0" ? "Incomplete" : "Complete"
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ItemController.sharedInstance.delete(item: item)
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ItemListTableViewController: ItemTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ItemTableViewCell) {
        guard let index =  tableView.indexPath(for: sender) else {return}
        let item = ItemController.sharedInstance.fetchedResultsController.object(at: index)
        ItemController.sharedInstance.toggling(item: item)
        sender.update(item: item)
        
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension ItemListTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
    
  // sets behavior for cells
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    
    let indexSet = IndexSet(integer: sectionIndex)
    switch type {
    case .insert:
      tableView.insertSections(indexSet, with: .fade)
    case .delete:
      tableView.deleteSections(indexSet, with: .fade)
    default: return
        
    }
  }
    
  // additional behavior for cells
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
    case .insert:
      guard let newIndexPath = newIndexPath
        else { return }
      tableView.insertRows(at: [newIndexPath], with: .fade)
    case .delete:
      guard let indexPath = indexPath
        else { return }
      tableView.deleteRows(at: [indexPath], with: .fade)
    case .update:
      guard let indexPath = indexPath
        else { return }
      tableView.reloadRows(at: [indexPath], with: .none)
    case .move:
      guard let indexPath = indexPath, let newIndexPath = newIndexPath
        else { return }
      tableView.moveRow(at: indexPath, to: newIndexPath)
    @unknown default:
      fatalError("NSFetchedResultsChangeType has new unhandled cases")
    }
  }
    
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}


