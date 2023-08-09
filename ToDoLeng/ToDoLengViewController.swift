//
//  ToDoLengViewController.swift
//  ToDoLeng
//
//  Created by Rotha Chhom on 2/8/23.
//

import UIKit
import CoreData

class ToDoLengViewController: UITableViewController {

  //MARK: - Property
  var itemArray = [Item]()
  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  //MARK: - Data Scource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView:   UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoLengItemCell", for: indexPath)
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    cell.accessoryType = item.done ? .checkmark : .none
    return cell
  }
  
  //MARK: - Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    context.delete(itemArray[indexPath.row])
//    itemArray.remove(at: indexPath.row)
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItems()
  }
  
  //MARK: - Add New Items
  @IBAction func addButtonPress(_ sender: Any) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new ToDoLeng", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { action in
      if let text = textField.text, !text.isEmpty {
        let newItem = Item(context: self.context)
        newItem.title = text
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
        self.itemArray.append(newItem)
        self.saveItems()
      }
    }
    alert.addTextField { alerTextField in
      alerTextField.placeholder = "Create new item"
      textField = alerTextField
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
  
  //MARK: Actions
  private func saveItems() {
    do {
      try context.save()
    } catch {
      print("Error Saving Context \(error)")
    }
    self.tableView.reloadData()
  }
  
  private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
    let predicate =  NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    request.predicate = predicate
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error Fetching Context \(error)")
    }
    self.tableView.reloadData()
  }
  
  private func search(with searchText: String = "") {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    if !searchText.isEmpty {
      let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
      let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
      request.predicate = predicate
      request.sortDescriptors = [sortDescriptor]
      loadItems(with: request)
    } else {
      loadItems()
    }
  }
}

//MARK : Search bar delegate
extension ToDoLengViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text {
      search(with: searchText)
    }
  }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if let searchText = searchBar.text {
      search(with: searchText)
    }
  }
}

