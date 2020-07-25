//
//  SubtasksList.swift
//  TaskManager
//
//  Created by Artem on 26.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

class SubtasksList: BaseSubtasksList, SwipeableCollectionViewCellDelegate {

    var subtasks: List<Subtask>?
    
//    var taskController: TaskController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        taskController?.delegate = self
        
        collectionView.register(SubtaskCell.self, forCellWithReuseIdentifier: CellType.subtask.rawValue)
        collectionView.register(AddSubtaskCell.self, forCellWithReuseIdentifier: CellType.addSubtask.rawValue)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
        if let subtasks = subtasks {
            return subtasks.count + 1
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == subtasks?.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.addSubtask.rawValue, for: indexPath) as! AddSubtaskCell
            
            cell.textField.isUserInteractionEnabled = false
            cell.textField.text = ""
            
            cell.addSubtaskLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addSubtask)))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.subtask.rawValue, for: indexPath) as! SubtaskCell
            cell.delegate = self
                        
            if let subtask = self.subtasks?[indexPath.item] {
                cell.subtaskNumLabel.text = "\(indexPath.item + 1)"
                cell.subtaskLabel.text = subtask.name
            }
            
            return cell
        }
        
//        let cell = collectionView.cellForItem(at: indexPath) as! SwipeableCollectionViewCell
//        if cell.scrollView.contentOffset.x > 0 {
//            cell.isGoingToBeDeleted = true
////            cell.scrollView.contentOffset.x
//        }
//
//        if cell.isGoingToBeDeleted == true {
//            print("azaza")
//        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
                
        if (collectionView.cellForItem(at: indexPath) as? AddSubtaskCell) != nil {
            return false
        } else {
            return true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if let subtasks = subtasks {
            if proposedIndexPath.item == subtasks.count {
                return IndexPath(row: proposedIndexPath.item - 1, section: proposedIndexPath.section)
            }
        }
        return proposedIndexPath
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        collectionView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let realm = try! Realm()

        try! realm.write {
            if let subtasks = self.subtasks {
                let subtask = subtasks[sourceIndexPath.item]
                subtasks.remove(at: sourceIndexPath.item)
                subtasks.insert(subtask, at: destinationIndexPath.item)
            }
        }
        collectionView.reloadData()
    }
    
    @objc fileprivate func addSubtask(gesture: UIGestureRecognizer) {
        
        let view = gesture.view
        var superview = view?.superview
        
        while superview != nil {
            if let cell = superview as? AddSubtaskCell {
                
                cell.textField.isUserInteractionEnabled = true
                cell.textField.becomeFirstResponder()
                cell.textField.delegate = self
                return
            }
            superview = superview?.superview
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                
        if textField.text! == "" {
            return false
        } else {
//            let subtask = Subtask()
//            subtask.name = textField.text!
//
//            let realm = try! Realm()
//
//            try! realm.write {
//                self.subtasks?.append(subtask)
//            }
//
//            textField.resignFirstResponder()
//
//            self.numItems! += 1
//
//            collectionView.reloadData()
//            self.view.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(self.numItems ?? 0) * self.itemHeight).isActive = true
//
//            return true
            
            saveSubtask()
            textField.resignFirstResponder()
            return true
        }
    }
    
    func saveSubtask() {
        
        if let subtasks = subtasks {
            let indexPath = IndexPath(item: subtasks.count, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! AddSubtaskCell
            
            let textField = cell.textField
            
            if textField.text! != "" {
                let subtask = Subtask()
                subtask.name = textField.text!

                let realm = try! Realm()

                try! realm.write {
                    self.subtasks?.append(subtask)
                }

                textField.resignFirstResponder()

                self.numItems! += 1

                collectionView.reloadData()
                self.view.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(self.numItems ?? 0) * self.itemHeight).isActive = true
            }
        }
    }

    
    func deleteLabelTapped(inCell cell: UICollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let realm = try! Realm()
        
        try! realm.write {
            if let subtasks = self.subtasks {
                subtasks.remove(at: indexPath.item)
            }
            print("subtasks: ", subtasks as Any)
        }

        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        })
    }
}
