//
//  CategoryViewController.swift
//  ToDoLeng
//
//  Created by Rotha Chhom on 9/8/23.
//
import UIKit
import CoreData

class CategoryViewController: UITableViewController {
  
  //MARK: Properties
  var categoryArray = [Category]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  //MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
  }

  //MARK: IBAction
  @IBAction func addButtonPress(_ sender: Any) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { action in
      if let text = textField.text, !text.isEmpty {
        let category = Category(context: self.context)
        category.name = text
        self.categoryArray.append(category)
        self.saveCategories()
      }
    }
    alert.addTextField { alerTextField in
      alerTextField.placeholder = "Create new item"
      textField = alerTextField
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
  
  //MARK: Tableview Datasource
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let category = categoryArray[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoLengCategoryCell", for: indexPath)
    cell.textLabel?.text = category.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray.count
  }
  
  //MARK: Tableview Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "gotoItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ToDoLengViewController
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
  }

  //MARK: Actions
  private func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    do {
      categoryArray = try context.fetch(request)
    } catch {
      print("Cannot load categories \(error)")
    }
    self.tableView.reloadData()
  }
  
  private func saveCategories() {
    do {
      try context.save()
    } catch {
      print("Cannnot save category \(error)")
    }
    self.tableView.reloadData()
  }
}
