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

final class SelectingSubtasksController: BaseSubtasksList {
    
    // MARK: - Public Properties

    weak var delegate: SelectingSubtasksControllerDelegate?

    // MARK: - Private Properties

    private var task: Task?
    private var subtasks: List<Subtask>?
    private var subtasksSelected = List<Subtask>()
    private var subtasksSelectedArray = Set<Subtask>()
    
    private let headerId = "headerId"
        
    // MARK: - Initializers

    init(task: Task) {
        self.task = task
        self.subtasks = self.task?.subtasks
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
        
        setupNavigationBar()
        registerCellsAndHeaders()
    }
    
    // MARK: - Collection View Delegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: [0, 0]) as! SelectingSubtasksSectionHeader
        
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: [0, 0]) as! SelectingSubtasksSectionHeader
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 32, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return .init(top: 96, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Collection View Data Source

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SelectingSubtasksSectionHeader
        header.frame = .init(x: 16, y: 72, width: view.frame.width - 32, height: 48)
        return header
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
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        navigationItem.title = "Select Subtasks"
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .done, target: self, action: #selector(saveTask)), animated: true)
        navigationItem.setLeftBarButton(.init(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss)), animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func registerCellsAndHeaders() {
        collectionView.register(SelectingSubtasksSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(SelectableSubtaskCell.self, forCellWithReuseIdentifier: CellType.selectSubtask.rawValue)
    }
    
    @objc private func saveTask() {
        for subtask in subtasksSelectedArray {
            subtasksSelected.append(subtask)
        }
        delegate?.readSubtasks(subtasks: subtasksSelected)
        handleDismiss()
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}
