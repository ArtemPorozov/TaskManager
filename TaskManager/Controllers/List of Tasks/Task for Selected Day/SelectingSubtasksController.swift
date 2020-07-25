//
//  SelectingSubtasksController.swift
//  TaskManager
//
//  Created by Artem on 08.07.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

protocol SelectingSubtasksControllerDelegate: class {
    func readSubtasks(subtasks: List<Subtask>)
}

class SelectingSubtasksController: BaseSubtasksList {
    
    var task: Task?
    var subtasks: List<Subtask>?
    
    var subtasksSelected = List<Subtask>()
    var subtasksSelectedArray = Set<Subtask>()
    
    fileprivate let headerId = "headerId"
    
    weak var delegate: SelectingSubtasksControllerDelegate?
    
    init(task: Task) {
        self.task = task
        self.subtasks = self.task?.subtasks
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.allowsMultipleSelection = true
        
        navigationItem.title = "Select Subtasks"
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .done, target: self, action: #selector(saveTask)), animated: true)
        navigationItem.setLeftBarButton(.init(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss)), animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(SelectableSubtaskCell.self, forCellWithReuseIdentifier: CellType.selectSubtask.rawValue)
    }
    
    @objc fileprivate func saveTask() {
        
        print("save")
        
//        let task = Task()
//        task.name = textField.text!
//        task.color = setColor()
//        task.subtasks = subtasksList.subtasks
        
//        self.subtasksSelected = self.subtasksSelectedArray
        
        for subtask in subtasksSelectedArray {
            subtasksSelected.append(subtask)
        }
        
        delegate?.readSubtasks(subtasks: subtasksSelected)
        
        handleDismiss()
        
//        let realm = try! Realm()
        
        //        if let info = realm.object(ofType: Task.self, forPrimaryKey: task.name) {
        //            print("task with the name \(info.name) has already been added")
        //
        //            // ADD ALERT!
        //
        //        } else {
        //            try! realm.write {
        //                realm.add(task)
        //            }
        //            handleDismiss()
        //        }
        
//        try! realm.write {
//            realm.add(task)
//        }
    }
    
    @objc fileprivate func handleDismiss() {
        
        //        delegate?.updateCollectionView()
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SectionHeader
        header.frame = .init(x: 16, y: 72, width: view.frame.width - 32, height: 48)
        //        header.label.text = "\(subtasksSelectedArray.count) Selected"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let subtasks = subtasks {
            return subtasks.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.selectSubtask.rawValue, for: indexPath) as! SelectableSubtaskCell
        
        if let subtask = self.subtasks?[indexPath.item] {
            cell.isSelectedLabel.text = "○"
            cell.subtaskLabel.text = subtask.name
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: [0, 0]) as! SectionHeader

        let cell = collectionView.cellForItem(at: indexPath) as! SelectableSubtaskCell
        if cell.isSelected {
            cell.isSelectedLabel.text = "●"
            cell.isSelectedLabel.textColor = .orange
        }
        if let selectedSubtask = subtasks?[indexPath.item] {
            var isContainSelectedSubtask = false
            for subtask in subtasksSelectedArray {
                if selectedSubtask.name == subtask.name {
                    isContainSelectedSubtask = true
                }
            }
            if !isContainSelectedSubtask {
                subtasksSelectedArray.insert(selectedSubtask)
            }
        }
        header.label.text = "\(subtasksSelectedArray.count) subtasks selected"
        if subtasksSelectedArray.count > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
//        print("subtasks selected: ", subtasksSelectedArray)
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: [0, 0]) as! SectionHeader
        let cell = collectionView.cellForItem(at: indexPath) as! SelectableSubtaskCell
        cell.isSelectedLabel.text = "○"
        cell.isSelectedLabel.textColor = .orange
        if let selectedSubtask = subtasks?[indexPath.item] {
            for subtask in subtasksSelectedArray {
                if selectedSubtask.name == subtask.name {
                    subtasksSelectedArray.remove(subtask)
                }
            }
        }
        header.label.text = "\(subtasksSelectedArray.count) subtasks selected"
        if subtasksSelectedArray.count > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
//        print("subtasks selected: ", subtasksSelectedArray)
    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: [0, 0]) as! SectionHeader
//
//        let cell = collectionView.cellForItem(at: indexPath) as! SelectableSubtaskCell
//        if cell.isSelected {
//            cell.isSelectedLabel.text = "●"
//            cell.isSelectedLabel.textColor = .orange
//        }
//        if let selectedSubtask = subtasks?[indexPath.item] {
//            var isContainSelectedSubtask = false
//            guard let subtasksSelected = subtasksSelected else { return }
//            for subtask in subtasksSelected {
//                if selectedSubtask.name == subtask.name {
//                    isContainSelectedSubtask = true
//                }
//            }
//            if !isContainSelectedSubtask {
//                subtasksSelected.append(selectedSubtask)
//            }
//        }
//        header.label.text = "\(subtasksSelected?.count) subtasks selected"
//        if subtasksSelected!.count > 0 {
//            navigationItem.rightBarButtonItem?.isEnabled = true
//        } else {
//            navigationItem.rightBarButtonItem?.isEnabled = false
//        }
//        print("subtasks selected: ", subtasksSelected)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//
//        let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: [0, 0]) as! SectionHeader
//        let cell = collectionView.cellForItem(at: indexPath) as! SelectableSubtaskCell
//        cell.isSelectedLabel.text = "○"
//        cell.isSelectedLabel.textColor = .orange
//        if let selectedSubtask = subtasks?[indexPath.item] {
//            guard let subtasksSelected = subtasksSelected else { return }
//            for subtask in subtasksSelected {
//                if selectedSubtask.name == subtask.name {
//                    subtasksSelected.removeLast()
//                }
//            }
//        }
//        header.label.text = "\(subtasksSelected?.count) subtasks selected"
//        if subtasksSelected!.count > 0 {
//            navigationItem.rightBarButtonItem?.isEnabled = true
//        } else {
//            navigationItem.rightBarButtonItem?.isEnabled = false
//        }
//        print("subtasks selected: ", subtasksSelected)
//    }
//
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 32, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return .init(top: 96, left: 0, bottom: 0, right: 0)
    }
    
    
}


class SectionHeader: UICollectionReusableView {
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "0 subtasks selected"
        label.font = .boldSystemFont(ofSize: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
