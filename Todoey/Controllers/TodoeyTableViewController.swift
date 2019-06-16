//
//  TodoeyTableViewController.swift
//  Todoey
//
//  Created by user154691 on 6/13/19.
//  Copyright © 2019 Shireesh Marla. All rights reserved.
//

import UIKit
import CoreData

class TodoeyTableViewController: UITableViewController {
    
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    //var textField : UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add Todoey Item", message: "Add todo list item", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item(context: self.context)
            item.title = textField.text
            item.done = false
            self.itemArray.append(item)
            self.saveItems()
        }
        alert.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        loadItems()
    }
    
}
// MARK: - Table view data source

extension TodoeyTableViewController {
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoeyAppConstants.todoeyCell, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }

}
//MARK : - Tablve view delegate methods

extension TodoeyTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
    }
}

//MARK: - load items from Core Data
extension TodoeyTableViewController {
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        }catch {
            print(error)
        }
    }
}

//MARK: - save itemd in core data
extension TodoeyTableViewController {
    func saveItems(){
        do {
            try context.save()
        }catch{
            print("error saving items \(error)")
        }
        tableView.reloadData()
    }
}
