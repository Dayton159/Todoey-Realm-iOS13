//
//  ViewController.swift
//  Todoey-Realm
//
//  Created by Dayton on 11/12/20.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    @IBOutlet var searchBar: UISearchBar!
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    //the value of category that was pressed
    var selectedCategory: Category? {
        didSet{
            // everything inside the didSet is going to happen as soon as selectedCategory get set with a value
            loadItems()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            // if there is the string hex color on category object
        if let colourHex = selectedCategory?.color{
            
            title = selectedCategory!.name
                
            guard let navbar = navigationController?.navigationBar else{fatalError("Navigation Controller does not exist")}
               
            //if the string hex color are able to be converted to 
            if let navbarColor = UIColor(hexString: colourHex) {
                if #available(iOS 13.0, *) {
                    let navBarAppearance = UINavigationBarAppearance()
                    navBarAppearance.configureWithOpaqueBackground()
                    navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                     navBarAppearance.backgroundColor = navbarColor
                 navigationController?.navigationBar.standardAppearance = navBarAppearance
                 navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
                }
                
                navbar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
                
                navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navbarColor, returnFlat: true)]
                
                searchBar.barTintColor = navbarColor
            }
            
    }
    }
    
    //MARK: - TableViewDataSource
    
    //how many row you want to display on the tableview and it will execute cellForRowAt function as many as this func
    // value that is returned.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //ofcourse all of them
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
           
            if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
            // Ternary: set cell accessory type depending on the item.done is true
            //if it's true set to checkmark and if it is not set it to none
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if there is an item, and grabbing the selected row
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write({
                    //Deleting item in realm
//                    realm.delete(item)
                    
                    //Update item in realm
                    item.done = !item.done
                })
            }catch{
                print("Error updating data, \(error)")
            }
        }
        tableView.reloadData()
      
        //to disable hightlighting when selecting a row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        //automatically gets the current date and time and set it to the item property
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    })
                } catch {
                    print("Error saving data")
                }
            }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            
            //storing the temporary variable into a local variable to be displayed later
            textField = alertTextField
            
            alertTextField.placeholder = "Create new item"
            
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: Model Manipulation Method
    
    
    func loadItems(){
        // Adding all the items that belongs to the selected category to the itemArray for display
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
                   do{
                       try self.realm.write({
                        self.realm.delete(item)
                       })
                   }catch {
                       print("Error deleting Category indexPath")
                   }

               }
    }
    
}

//MARK: - Search bar method
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //filter the item by the search bar text and sort by the time it created
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //when we hit the X button to empty the search bar after we searched for data once.
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                //getting the search bar dismissed. Removing the keyboard and cursor on search bar.
                searchBar.resignFirstResponder()
            }
        }
    }

}
