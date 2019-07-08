//
//  TestTable.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 03/06/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

class MemesTableViewController: MemeMeController {
    
    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var logo: UIImageView!
    
    let cellID = "MemeCell"
    var meme: Meme?
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.white
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        isViewInEditMode(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        checkMemesArray()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tableView.isEditing = false
        isViewInEditMode(false)
    }
    
    //MARK: Buttons
    
    @IBAction func deleteButton(_ sender: Any) {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            
            var items = [Meme]()
            for indexPath in selectedRows  {
                items.append((MemesList.shared.memes[indexPath.row]))
            }
            for item in items {
                if let index = MemesList.shared.memes.firstIndex(of: item) {
                    MemesList.shared.memes.remove(at: index)
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
            checkMemesArray()
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        var editToggle = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(!tableView.isEditing, animated: true)
        editToggle = tableView.isEditing ? true : false
        isViewInEditMode(editToggle)
        checkMemesArray()
    }
    
    @IBAction func addButton(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "EditMemeController") as? EditMemeController else {return}
        present(controller, animated: true, completion: nil)
    }
    
    //Method to check if the view is in edit mode and set buttons and UI properly
    
    func isViewInEditMode(_ editing: Bool) {
        switch editing {
        case true:
            editButton.image = UIImage(named: "doneShape")
            addButton.isEnabled = false
            deleteButton.tintColor = .white
            deleteButton.isEnabled = true
        case false:
            editButton.image = UIImage(named: "editShape")
            addButton.isEnabled = true
            deleteButton.tintColor = .clear
            deleteButton.isEnabled = false
        }
    }
    
    //Check if memes array is empty and set the logo and edit button enable accordingly
    
    func checkMemesArray() {
        if MemesList.shared.memes.isEmpty {
            editButton.isEnabled = false
            logo.isHidden = false
            isViewInEditMode(false)
        } else {
            editButton.isEnabled = true
            logo.isHidden = true
        }
    }
}

//MARK: UITableView Delegate and DataSource

extension MemesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Number of sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Number of row based on memes array count
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemesList.shared.memes.count
    }
    
    //Set and configure cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TableViewCellController
        let model = MemesList.shared.memes[indexPath.row]
        cell.configureCell(with: model)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 0.35
        
        return cell
    }
    
    //Present MemeDetailController when cell is tapped
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing { //This statment prevent the user to be send to MemeDetailController if clicks on the cell while editing
            return
        }
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailController") as? MemeDetailController else {return}
        let model = MemesList.shared.memes[indexPath.row]
        controller.meme = model
        present(controller, animated: true, completion: nil)
    }
    
    //Reorder array when deleting
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        MemesList.shared.memes.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    //Change the indexPath of the moved cells
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = MemesList.shared.memes[sourceIndexPath.row]
        
        MemesList.shared.memes.remove(at: sourceIndexPath.row)
        MemesList.shared.memes.insert(itemToMove, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
}

