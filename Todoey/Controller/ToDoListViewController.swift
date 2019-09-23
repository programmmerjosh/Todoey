//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by admin on 16/09/2019.
//  Copyright © 2019 programmmerjosh. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm     = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet{
            // only once the category has been set, this loads the items linked to that category
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // check if there are any items in the toDoItems and assign the values appropriately
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType   = item.checked ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    // if I want to delete the item instead of check it: uncomment next line and comment out the uncommented line
                    // realm.delete(item)
                    item.checked = !item.checked
                }
            } catch {
                print("Error saving the checked feature: \(error)")
            }
        }
        tableView.reloadData()
    }

    // MARK: - Add button pressed
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var myTextfield = UITextField()
        let alert       = UIAlertController(title: "Add Item", message: "Insert your new item here:", preferredStyle: .alert)
        let action      = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item  = Item()
                        item.name = myTextfield.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("error: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Example: Apples"
            myTextfield                = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Realm load
    
    func loadItems() {
        // setting the toDoItems in ascending order
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
}

// MARK: - Search Bar

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // update the collection of results here by inserting a filtered version based on a predicate
//        toDoItems = toDoItems?.filter("name CONTIANS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        toDoItems = toDoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // if dismissing the searchbar (or emptying the search bar text), load up the items all over again
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
