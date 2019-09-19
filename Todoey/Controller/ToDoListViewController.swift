//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by admin on 16/09/2019.
//  Copyright © 2019 programmmerjosh. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray    = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
        
        let item = itemArray[indexPath.row]
        
        item.checked = !item.checked
        
        saveItems()
    }

    // MARK: - Add button pressed
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var myTextfield = UITextField()
        let alert       = UIAlertController(title: "Add Item", message: "Insert your new item here:", preferredStyle: .alert)
        let action      = UIAlertAction(title: "Add Item", style: .default) { (action) in
                          let item = Item()
                          item.name = myTextfield.text!
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
    
    // MARK: - Encoding and decoding methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("\(error)")
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
