//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by admin on 16/09/2019.
//  Copyright © 2019 programmmerjosh. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Apples", "Oranges", "Peaches", "Mangos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }

    // MARK: - Add button pressed
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var myTextfield = UITextField()
        let alert       = UIAlertController(title: "Add Item", message: "Insert your new item here:", preferredStyle: .alert)
        let action      = UIAlertAction(title: "Add Item", style: .default) { (action) in
                          self.itemArray.append(myTextfield.text!)
                          self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Example: Apples"
            myTextfield = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
}
