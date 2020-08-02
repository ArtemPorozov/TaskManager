//
//  AddingSubtasksList.swift
//  TaskManager
//
//  Created by Artem on 08.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

class AddingSubtasksList: BaseSubtasksList {
    
    var subtasksArray = [Subtask]()
    var subtasks = List<Subtask>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SubtaskCell.self, forCellWithReuseIdentifier: CellType.subtask.rawValue)
        collectionView.register(AddSubtaskCell.self, forCellWithReuseIdentifier: CellType.addSubtask.rawValue)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return subtasksArray.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == subtasksArray.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.addSubtask.rawValue, for: indexPath) as! AddSubtaskCell
            
            cell.textField.isUserInteractionEnabled = false
            cell.textField.text = ""
            
            cell.addSubtaskLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addSubtask)))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.subtask.rawValue, for: indexPath) as! SubtaskCell
            
            let subtask = self.subtasksArray[indexPath.item]
            cell.subtaskNumLabel.text = "\(indexPath.item + 1)"
            cell.subtaskLabel.text = subtask.name
            
            return cell
        }
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
            saveSubtask()
            return true
        }
    }
    
    func saveSubtask() {
        
        let indexPath = IndexPath(item: subtasks.count, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as! AddSubtaskCell
        
        let textField = cell.textField
        
        let subtask = Subtask()
        subtask.name = textField.text!
        self.subtasksArray.append(subtask)
        
        self.subtasks.append(subtask)
        
        textField.resignFirstResponder()
        
        self.numItems! += 1
        
        collectionView.reloadData()
        self.view.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(self.numItems ?? 0) * self.itemHeight).isActive = true
    }
}
