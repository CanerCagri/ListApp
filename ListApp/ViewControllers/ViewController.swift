//
//  ViewController.swift
//  ListApp
//
//  Created by Caner Çağrı on 2.11.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [NSManagedObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    func configureViewController() {
        title = "ListApp"
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }

    @IBAction func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Deleting All Items", message: nil, preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .default) { _ in
            self.data.removeAll()
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
    
    @IBAction func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        
        let defaultButton = UIAlertAction(title: "Ekle",
                                          style: .default) { _ in
            let textFieldText = alertController.textFields?.first?.text
            if textFieldText != "" {
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedObjectContext!)
                
                let listItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext!)
                listItem.setValue(textFieldText, forKey: "title")
                try? managedObjectContext?.save()

                self.fetchData()
            }
        }
        
        let cancelButton = UIAlertAction(title: "Vazgec", style: .cancel)
        
        alertController.addTextField()
        alertController.addAction(defaultButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
    
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        data = try! managedObjectContext!.fetch(fetchRequest)
        
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Delete") { _, _, _ in
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            managedObjectContext?.delete(self.data[indexPath.row])
            try? managedObjectContext?.save()
            
            self.fetchData()
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}
