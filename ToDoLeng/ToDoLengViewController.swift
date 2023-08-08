//
//  ToDoLengViewController.swift
//  ToDoLeng
//
//  Created by Rotha Chhom on 2/8/23.
//

import UIKit

class ToDoLengViewController: UITableViewController {

  //MARK: - Property
  var itemArray = [Item]()
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: "Item.plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    loadItems()
  }

  //MARK: - Data Scource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoLengItemCell", for: indexPath)
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    cell.accessoryType = item.done ? .checkmark : .none
    return cell
  }
  
  //MARK: - Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItems()
    tableView.reloadData()
  }
  
  //MARK: - Add New Items
  @IBAction func addButtonPress(_ sender: Any) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new ToDoLeng", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { action in
      if let text = textField.text, !text.isEmpty {
        let newItem = Item()
        newItem.title = text 
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
      let encoder = PropertyListEncoder()
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    } catch {
      print("Unable to Decode Notes (\(error))")
    }
    self.tableView.reloadData()
  }
  
  private func loadItems() {
    if let data = try? Data(contentsOf: dataFilePath!) {
      do {
        let decoder = PropertyListDecoder()
        itemArray = try decoder.decode([Item].self, from: data)
      } catch {
        print("Unable to Decode Notes (\(error))")
      }
    }
  }
}

