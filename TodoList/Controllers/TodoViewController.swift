//
//  ViewController.swift
//  TodoList
//
//  Created by Hasan Aden on 13/06/2019.
//  Copyright © 2019 hasan. All rights reserved.
//

import UIKit
import RealmSwift


class TodoViewController: UITableViewController {

    
    var TodoItems: Results<Items>!
   let realm = try! Realm()
    
    
    var selectedCategory: Categories? {
        didSet {
            LoadItems()
        }
    }
    
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TodoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = TodoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ?  .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added"
        }
      
        return cell
    }
    
    //MARK - TableView delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = TodoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
         tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New TodoList Item", message: " ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Items()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        }
                    } catch {
                    print("Error saving new items \(error)")
                    }
              }
                self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK - Model Manipulation Methods
    
    func LoadItems() {
        
        TodoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
       
        tableView.reloadData()
    }
   
}

extension TodoViewController: UISearchBarDelegate {
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    TodoItems = TodoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {        
        if searchBar.text?.count == 0 {
            LoadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

