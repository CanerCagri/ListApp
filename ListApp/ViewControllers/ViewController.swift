//
//  ViewController.swift
//  ListApp
//
//  Created by Caner Çağrı on 2.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    func configureViewController() {
        title = "ListApp"
        tableView.delegate = self
        tableView.dataSource = self
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
                self.data.append((textFieldText)!)
                self.tableView.reloadData()
            }
        }
        
        let cancelButton = UIAlertAction(title: "Vazgec", style: .cancel)
        
        alertController.addTextField()
        alertController.addAction(defaultButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
      
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Delete") { _, _, _ in
            self.data.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }

}

