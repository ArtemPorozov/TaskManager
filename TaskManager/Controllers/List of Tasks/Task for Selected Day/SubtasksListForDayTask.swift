//
//  SubtasksListForDayTask.swift
//  TaskManager
//
//  Created by Artem on 05.07.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

protocol SubtasksListForDayTaskDelegate: class {
    func updateCollectionView()
}

final class SubtasksListForDayTask: BaseSubtasksList, SwipeableCollectionViewCellDelegate, SelectingSubtasksControllerDelegate {
    
    // MARK: - Public Properties

    weak var delegate: SubtasksListForDayTaskDelegate?
    
    var taskForDay: TaskForDay?
    var subtasks: List<Subtask>?
    
    // MARK: - Private Properties

    private var task: Task?
    
    private var selectingSubtaskController: SelectingSubtasksController? {
        didSet {
            selectingSubtaskController?.delegate = self
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        readTask()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupGesture()
    }
    
    // MARK: - Collection View Delegate

    override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if let subtasks = subtasks {
            if proposedIndexPath.item == subtasks.count {
                return IndexPath(row: proposedIndexPath.item - 1, section: proposedIndexPath.section)
            }
        }
        return proposedIndexPath
    }

    // MARK: - Collection View Data Source

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
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
                
        if (collectionView.cellForItem(at: indexPath) as? AddSubtaskCell) != nil {
            return false
        } else {
            return true
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
    
    // MARK: - Private Methods
    
    private func setupGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @objc private func addSubtask(gesture: UIGestureRecognizer) {

        let selectingSubtaskController = SelectingSubtasksController(task: task!)
        self.selectingSubtaskController = selectingSubtaskController
        present(UINavigationController(rootViewController: selectingSubtaskController), animated: true, completion: nil)
    }
    
    private func readTask() {
        
        let realm = try! Realm()
        let tasks = realm.objects(Task.self)
        for task in tasks {
            if task.id == self.taskForDay?.id {
                self.task = task
            }
        }
    }
    
    // MARK: - Swipeable Collection View Cell Delegate

    func deleteLabelTapped(inCell cell: UICollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let realm = try! Realm()
        
        try! realm.write {
            if let subtasks = self.subtasks {
                subtasks.remove(at: indexPath.item)
            }
        }
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        })
    }
    
    // MARK: - Selecting Subtasks Controller Delegate
    
    func readSubtasks(subtasks: List<Subtask>) {
        
        // think of refactoring
        
        let realm = try! Realm()
        
        guard let subtasksExist = self.subtasks else { return }
        var results: Results<Subtask>
        
        if subtasksExist.count == 0 {
            try! realm.write {
                subtasksExist.append(objectsIn: subtasks)
                self.subtasks = subtasksExist
            }
        } else {
            for i in 0...subtasks.count-1 {
                let myPredicate = NSPredicate(format: "name != '\(subtasks[i].name)'")
                results = subtasksExist.filter(myPredicate)
                
                let filtered = results.reduce(List<Subtask>()) { (list, element) -> List<Subtask> in
                    list.append(element)
                    return list
                }
                try! realm.write {
                    subtasksExist.removeAll()
                    subtasksExist.append(objectsIn: filtered)
                }
            }
            try! realm.write {
                subtasksExist.append(objectsIn: subtasks)
            }
        }
        if let subtasksNumber = self.subtasks?.count {
            numItems = subtasksNumber + 1
        }
        self.collectionView.reloadData()
        delegate?.updateCollectionView()
    }
    
}
