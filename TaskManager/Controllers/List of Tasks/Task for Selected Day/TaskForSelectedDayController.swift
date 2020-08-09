//
//  TaskForSelectedDayController.swift
//  TaskManager
//
//  Created by Artem on 04.07.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

final class TaskForSelectedDayController: BaseTaskController, SubtasksListForDayTaskDelegate {

    // MARK: - Private Properties

    private var taskForDay: TaskForDay?
    private let subtasksListForDayTask = SubtasksListForDayTask()
    private var subtasksListHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Initializers
    
    init(task: TaskForDay) {
        self.taskForDay = task
        self.subtasksListForDayTask.taskForDay = task
        self.subtasksListForDayTask.subtasks = task.subtasks
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
        subtasksListForDayTask.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let contentHeight = 24 + tasksTitleLabel.frame.height + 48 + subtasksTitleLabel.frame.height + 16 + subtasksListForDayTask.collectionView.contentSize.height + 48
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }
    
    // MARK: - Private Methods

    private func setupNavigationBar() {
        navigationItem.title = "Day Task"
    }
    
    private func setupViews() {

        tasksTitleLabel.text = taskForDay?.name
        
        subtasksTitleLabel.text = "Subtasks completed today:"

        scrollView.addSubview(subtasksListForDayTask.view)
        addChild(subtasksListForDayTask)
        subtasksListForDayTask.view.translatesAutoresizingMaskIntoConstraints = false
        subtasksListForDayTask.view.topAnchor.constraint(equalTo: subtasksTitleLabel.bottomAnchor, constant: 16).isActive = true
        subtasksListForDayTask.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        subtasksListForDayTask.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        setSubtasksListHeightConstraint()
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setSubtasksListHeightConstraint() {
        subtasksListHeightConstraint = subtasksListForDayTask.view.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(subtasksListForDayTask.numItems ?? 0) * subtasksListForDayTask.itemHeight)
        subtasksListHeightConstraint?.isActive = true
    }
    
    // MARK: - Subtasks List For Day Task Delegate

    func updateCollectionView() {
        setSubtasksListHeightConstraint()
    }
    
}
