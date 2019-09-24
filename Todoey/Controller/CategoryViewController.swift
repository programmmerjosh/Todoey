//
//  CategoryViewController.swift
//  Todoey
//
//  Created by admin on 19/09/2019.
//  Copyright © 2019 programmmerjosh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // initialize a new access point to the Realm database
    let realm = try! Realm()
    // changed 'categories' from an array of category items to a new collection type 'Results'
    // which is a collection of results that are category objects.
    // it's also an optional for safety
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    // MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // clicking on one of the cells, perfroms a segue that takes the user to the ToDoListViewController
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        // setting the selectedCategory variable in the ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - data manipulation methods
    
    func save(category: Category) {
        
        do {
            // commit any changes to the Realm
            try realm.write {
                // the only change is adding the new category to the Realm database
                realm.add(category)
            }
        } catch {
            print("Error saving: \(error)")
        }
        tableView.reloadData()
    }

    func loadCategories() {
        // setup categories to look inside our Realm and fetch all the objects that belong to the category data type
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: - Delete Data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns the number of categories if there are any saved categories, otherwise, returns a default value of 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell        = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            guard let categoryColor   = UIColor(hexString: category.hexColor) else {fatalError()}
            cell.backgroundColor      = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            cell.textLabel?.text      = category.name
        } else {
            cell.textLabel?.text = "No category added yet"
            cell.backgroundColor = UIColor.randomFlat
        }
        return cell
    }

    // MARK: - add new categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var myTextField = UITextField()
        let alert       = UIAlertController(title: "Add Category", message: "Add a new category:", preferredStyle: .alert)
        let action      = UIAlertAction(title: "Add Category", style: .default) { (action) in
        let newCategory = Category()
            
            newCategory.name     = myTextField.text!
            newCategory.hexColor = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            myTextField                = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
