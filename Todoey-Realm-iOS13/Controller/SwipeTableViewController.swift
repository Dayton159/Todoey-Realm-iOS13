//
//  SwipeTableViewController.swift
//  Todoey-Realm
//
//  Created by Dayton on 11/12/20.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

         tableView.rowHeight = 80.0
    }
    
    //MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
                
                 cell.delegate = self
                
                return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
           
            
            self.updateModel(at: indexPath)
            
    }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
         //this option will try to remove the row from the table view, so we don't need to write tableView.reloadData() when deleting.
        options.expansionStyle = .destructiveAfterFill
    
        return options
    }

    
    func updateModel(at indexPath:IndexPath) {
        //Update our data model
    }
}


