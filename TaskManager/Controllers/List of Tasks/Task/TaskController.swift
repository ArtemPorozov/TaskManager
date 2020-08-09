//
//  TaskController.swift
//  TaskManager
//
//  Created by Artem on 24.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

final class TaskController: BaseTaskController {
    
    // MARK: - Public Properties
    
    let subtasksList = SubtasksList()
        
    // MARK: - Private Properties

    private let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.font = .boldSystemFont(ofSize: 42)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private var task: Task?
    private var subtasksListHeightConstraint: NSLayoutConstraint?

    // MARK: - Initializers
    
    init(task: Task) {
        self.task = task
        self.subtasksList.subtasks = task.subtasks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupViews()
        // dismissing the keyboard by tapping the screen
        setupGesture()
        
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let contentHeight = 24 + tasksTitleLabel.frame.height + 24 + subtasksTitleLabel.frame.height + 16 + subtasksList.collectionView.contentSize.height + 48
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        navigationItem.title = "Task"
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .edit, target: self, action: #selector(editTask)), animated: true)
    }
    
    @objc private func editTask() {
        
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .done, target: self, action: #selector(saveTask)), animated: true)
        
        tasksTitleLabel.isHidden = true
        
        if let tasksTitleLabelText = self.tasksTitleLabel.text {
            textField.text = tasksTitleLabelText
        }
        
        textField.isHidden = false
        textField.becomeFirstResponder()
    }

    @objc private func saveTask() {
        
        let realm = try! Realm()
        
        try! realm.write {
            guard let taskOriginName = task?.name else { return }
            if let typedText = self.textField.text {
                task?.name = typedText
            }
            
            let tasksForDay = realm.objects(TaskForDay.self)
            let myPredicate = NSPredicate(format: "name == '\(taskOriginName)'")
            let tasksForDayFiltered = tasksForDay.filter(myPredicate)
            
            for task in tasksForDayFiltered {
                if task.id == self.task?.id, let typedText = self.textField.text {
                    task.name = typedText
                }
            }
        }
        
        tasksTitleLabel.text = task?.name
        
        textField.resignFirstResponder()
        textField.isHidden = true
        
        tasksTitleLabel.isHidden = false
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .edit, target: self, action: #selector(editTask)), animated: true)
    }
    
    private func setupViews() {
        
        tasksTitleLabel.text = task?.name
        
        scrollView.addSubview(textField)
        textField.text = tasksTitleLabel.text
        textField.isHidden = true
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true

        subtasksTitleLabel.text = "Subtasks"

        scrollView.addSubview(subtasksList.view)
        addChild(subtasksList)
        subtasksList.view.translatesAutoresizingMaskIntoConstraints = false
        subtasksList.view.topAnchor.constraint(equalTo: subtasksTitleLabel.bottomAnchor, constant: 16).isActive = true
        subtasksList.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        subtasksList.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        setSubtasksListHeightConstraint()
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(addSubtask))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func addSubtask() {
        self.view.endEditing(true)
        subtasksList.saveSubtask()
    }
    
    private func setSubtasksListHeightConstraint() {
        subtasksListHeightConstraint = subtasksList.view.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(subtasksList.numItems ?? 0) * subtasksList.itemHeight)
        subtasksListHeightConstraint?.isActive = true
    }
    
    // MARK: - Text Field Delegate
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        if self.textField.text == "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
}
