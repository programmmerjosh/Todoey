//
//  CategoryViewController.swift
//  Todoey
//
//  Created by admin on 19/09/2019.
//  Copyright © 2019 programmmerjosh. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context       = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    // MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - data manipulation methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
        }
        tableView.reloadData()
    }

    func loadCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading: \(error)")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell     = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }

    // MARK: - add new categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var myTextField = UITextField()
        let alert       = UIAlertController(title: "Add Category", message: "Add a new category:", preferredStyle: .alert)
        let action      = UIAlertAction(title: "Add Category", style: .default) { (action) in
        let category    = Category(context: self.context)
            
            category.name = myTextField.text!
            self.categoryArray.append(category)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            myTextField                = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
