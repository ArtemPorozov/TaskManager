//
//  AddingSubtaskController.swift
//  TaskManager
//
//  Created by Artem on 05.07.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

//protocol AddingTaskControllerDelegate: class {
//    func updateCollectionView()
//}

class AddingSubtaskController: UIViewController, UITextFieldDelegate {
    
//    weak var delegate: AddingTaskControllerDelegate?

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    let tasksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "2 Selected"
        label.font = .boldSystemFont(ofSize: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtasksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select subtasks"
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var taskForDay: TaskForDay?

    let subtasksList = AddingSubtasksList()

    init(taskForDay: TaskForDay) {
        self.taskForDay = taskForDay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "Select Subtasks"
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .done, target: self, action: #selector(saveTask)), animated: true)
        navigationItem.setLeftBarButton(.init(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss)), animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        
        setupViews()
    }

    @objc fileprivate func saveTask() {

        print("save")
        
//        let task = Task()
//        task.name = textField.text!
//        task.color = setColor()
//        task.subtasks = subtasksList.subtasks
//
//        let realm = try! Realm()
//
////        if let info = realm.object(ofType: Task.self, forPrimaryKey: task.name) {
////            print("task with the name \(info.name) has already been added")
////
////            // ADD ALERT!
////
////        } else {
////            try! realm.write {
////                realm.add(task)
////            }
////            handleDismiss()
////        }
//
//        try! realm.write {
//            realm.add(task)
//        }
//        handleDismiss()
        
    }

    @objc fileprivate func handleDismiss() {

//        delegate?.updateCollectionView()
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let contentHeight = 24 + tasksTitleLabel.frame.height + 96 + subtasksList.collectionView.contentSize.height + 48
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }

    var scrollViewBottomAnchor: NSLayoutConstraint?

    fileprivate func setupViews() {

        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomAnchor?.isActive = true
        
        scrollView.addSubview(tasksTitleLabel)
        tasksTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        tasksTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        tasksTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        tasksTitleLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true

        scrollView.addSubview(subtasksTitleLabel)
        subtasksTitleLabel.topAnchor.constraint(equalTo: tasksTitleLabel.bottomAnchor, constant: 96).isActive = true
        subtasksTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        subtasksTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        subtasksTitleLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true

        scrollView.addSubview(subtasksList.view)
        addChild(subtasksList)
        subtasksList.view.translatesAutoresizingMaskIntoConstraints = false
        subtasksList.view.topAnchor.constraint(equalTo: subtasksTitleLabel.bottomAnchor, constant: 16).isActive = true
        subtasksList.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        subtasksList.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        subtasksList.view.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(subtasksList.numItems ?? 0) * subtasksList.itemHeight).isActive = true
    }
}
