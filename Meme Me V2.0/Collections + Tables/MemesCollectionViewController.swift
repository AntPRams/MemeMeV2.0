//
//  MemesCollectionViewController.swift
//  Meme Me V2.0
//
//  Created by António Ramos on 03/06/2019.
//  Copyright © 2019 ARdev. All rights reserved.
//

import UIKit

class MemesCollectionViewController: MemeMeController {
    
    //MARK: Properties
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    @IBOutlet weak var flowLayout:     UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton:     UIBarButtonItem!
    @IBOutlet weak var addButton:      UIBarButtonItem!
    @IBOutlet weak var deleteButton:   UIBarButtonItem!
    @IBOutlet weak var logo:           UIImageView!
    
    let cellID = "CollectionViewCell"
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFlowLayout()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        collectionView.backgroundColor = .clear
        isViewInEditMode(false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        DispatchQueue.main.async {
            self.setFlowLayout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        collectionView.reloadData()
        setFlowLayout()
        checkMemesArray()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        isViewInEditMode(false)
    }
    
    //MARK: Methods
    
    //Set flow layout
    func setFlowLayoutValues(interItemAndLine spacing: CGFloat, cellsPerRow: CGFloat){
        
        guard let collectionViewFrameWidth = collectionView?.frame.width else {return}
        
        let dimension = (collectionViewFrameWidth - ((cellsPerRow + 1) * spacing)) / cellsPerRow
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing =      spacing
        
        flowLayout.itemSize =     CGSize(width: dimension,
                                         height: dimension)
        
        flowLayout.sectionInset = UIEdgeInsets(top:    spacing,
                                               left:   spacing,
                                               bottom: spacing,
                                               right:  spacing)
    }
    
    func setFlowLayout() {
        
        if UIDevice.current.orientation.isPortrait {
            setFlowLayoutValues(interItemAndLine: 5, cellsPerRow: 3)
        } else {
            setFlowLayoutValues(interItemAndLine: 5, cellsPerRow: 6)
        }
    }
    
    //Set editing behaviors
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addButton.isEnabled = !editing
        
        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCellController
            cell.isEditing = editing
        }
        checkMemesArray()
    }
    
    //Method to recognize the long press that will be used to move the cells
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch (gesture.state){
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {break}
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    //MARK: Buttons
    
    @IBAction func editDoneButton(_ sender: Any) {
        
        if editButton.image == UIImage(named: "editShape") {
            setEditing(true, animated: true)
            isViewInEditMode(true)
        } else {
            setEditing(false, animated: true)
            isViewInEditMode(false)
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "EditMemeController") as? EditMemeController else {return}
        present(controller, animated: true, completion: nil)
    }
    
    //This button allows multiple cells to be deleted at the same time
    
    @IBAction func deleteButton(_ sender: Any) {
        
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            var items = [Meme]()
            for indexPath in selectedCells {
                items.append((MemesList.shared.memes[indexPath.row]))
            }
            for item in items {
                if let index = MemesList.shared.memes.firstIndex(of: item) {
                    MemesList.shared.memes.remove(at: index)
                }
            }
            collectionView.deleteItems(at: selectedCells)
            collectionView.reloadData()
            checkMemesArray()
            setFlowLayout()
        }
        
    }
    
    //Method to check if the view is in edit mode and set buttons and UI properly
    
    func isViewInEditMode(_ editing: Bool) {
        
        switch editing {
        case true:
            editButton.image =       UIImage(named: "doneShape")
            addButton.isEnabled =    false
            deleteButton.tintColor = .white
            deleteButton.isEnabled = true
        case false:
            editButton.image =       UIImage(named: "editShape")
            addButton.isEnabled =    true
            deleteButton.tintColor = .clear
            deleteButton.isEnabled = false
        }
    }
    
    //Check if memes array is empty and set the logo and edit button enable accordingly
    
    func checkMemesArray() {
        
        if MemesList.shared.memes.isEmpty {
            editButton.isEnabled = false
            logo.isHidden =        false
            isViewInEditMode(false)
        } else {
            editButton.isEnabled = true
            logo.isHidden =        true
        }
    }
}

//MARK: UICollectionView Delegate and DataSource

extension MemesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Number of sections
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Number of row based on memes array count
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemesList.shared.memes.count
    }
    
    //Set and configure cell
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CollectionViewCellController
        let model = MemesList.shared.memes[indexPath.row]
        
        cell.configureCell(with: model)
        
        cell.layer.shadowColor =   UIColor.black.cgColor
        cell.layer.shadowOffset =  CGSize(width: 1, height: 1.0)
        cell.layer.shadowRadius =  1.0
        cell.layer.shadowOpacity = 0.2
        
        cell.isEditing = isEditing
        
        return cell
    }
    
    //Present MemeDetailController when cell is tapped
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEditing { //This statment prevent the user to be sent to MemeDetailController if clicks on the cell while editing
            return
        }
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailController") as? MemeDetailController else {return}
        
        let model =       MemesList.shared.memes[indexPath.row]
        controller.meme = model
        present(controller, animated: true, completion: nil)
    }
    
    //Allows cell to be moved
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Change the indexPath of the moved cells
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = MemesList.shared.memes[sourceIndexPath.row]
        
        MemesList.shared.memes.remove(at: sourceIndexPath.row)
        MemesList.shared.memes.insert(itemToMove, at: destinationIndexPath.row)
        
        collectionView.reloadData()
    }
}


