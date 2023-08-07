//
//  ToDoLengViewController.swift
//  ToDoLeng
//
//  Created by Rotha Chhom on 2/8/23.
//

import UIKit

class ToDoLengViewController: UITableViewController {

  //MARK: - Property
  var itemArray: [String] = []
  let userDefaults = UserDefaults.standard
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    itemArray = userDefaults.array(forKey: "ToDoLengList") as? [String] ?? []
  }

  //MARK: - Data Scource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoLengItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }
  
  //MARK: - Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK: - Add New Items
  @IBAction func addButtonPress(_ sender: Any) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new ToDoLeng", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { action in
      if let text = textField.text, !text.isEmpty {
        self.itemArray.append(text)
        self.userDefaults.set(self.itemArray, forKey: "ToDoLengList")
        self.tableView.reloadData()
      }
    }
    alert.addTextField { alerTextField in
      alerTextField.placeholder = "Create new item"
      textField = alerTextField
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
}

