//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by admin on 16/09/2019.
//  Copyright © 2019 programmmerjosh. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray    = [Item]()
    let context      = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.accessoryType   = item.checked ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item     = itemArray[indexPath.row]
        item.checked = !item.checked
        
        saveItems()
    }

    // MARK: - Add button pressed
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var myTextfield = UITextField()
        let alert       = UIAlertController(title: "Add Item", message: "Insert your new item here:", preferredStyle: .alert)
        let action      = UIAlertAction(title: "Add Item", style: .default) { (action) in
        let item        = Item(context: self.context)
            
            item.name           = myTextfield.text!
            item.checked        = false
            item.parentCategory = self.selectedCategory
            
            self.itemArray.append(item)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Example: Apples"
            myTextfield                = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - CoreData save & load
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving items: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), searchPredicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = searchPredicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Load Items Error: \(error)")
        }
    }
}

// MARK: - Search Bar

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate                     = NSPredicate(format: "name CONTIANS[cd] %@", searchBar.text!)
        request.sortDescriptors           = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadItems(with: request, searchPredicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
