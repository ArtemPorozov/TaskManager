//
//  TaskController.swift
//  TaskManager
//
//  Created by Artem on 24.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

//protocol TaskControllerDelegate: class {
//    func cancelDeletion()
//}

//protocol TaskControllerDelegate: class {
//    func saveSubtask()
//}

class TaskController: UIViewController, UITextFieldDelegate {
    
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
        label.text = "Task"
        label.font = .boldSystemFont(ofSize: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.font = .boldSystemFont(ofSize: 42)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let subtasksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtasks"
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtasksList = SubtasksList()
    
    var task: Task?
    
//    weak var delegate: TaskControllerDelegate?
    
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .white
        navigationItem.title = "Task"
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .edit, target: self, action: #selector(editTask)), animated: true)
        
        tasksTitleLabel.text = task?.name
        if let subtasks = task?.subtasks {
            self.subtasksList.subtasks = subtasks
        }
        
        setupViews()
        
        self.subtasksList.setEditing(true, animated: true)
        
        setupKeyboardObservers()
        
        self.textField.delegate = self
//        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // dismissing the keyboard by tapping the screen
//        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(addSubtask))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
//        let cancelDeletionTap = UITapGestureRecognizer(target: self, action: #selector(hideDeleteLabel))
//        view.addGestureRecognizer(cancelDeletionTap)

    }
    
    @objc fileprivate func addSubtask() {
                
        self.view.endEditing(true)
                
//        delegate?.saveSubtask()
//        print("delegate: ", delegate)

        subtasksList.saveSubtask()
    }
    
//    @objc fileprivate func hideDeleteLabel() {
//
//        print("cancel")
//        self.view.endEditing(true)
//    }
    
    @objc fileprivate func editTask() {
        
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .done, target: self, action: #selector(saveTask)), animated: true)
        
        tasksTitleLabel.isHidden = true
        
        textField.text! = tasksTitleLabel.text!
        textField.isHidden = false
        textField.becomeFirstResponder()
    }

    @objc fileprivate func saveTask() {
        
        let realm = try! Realm()
        
        try! realm.write {
            guard let taskOriginName = task?.name else { return }
            task?.name = self.textField.text!
            if let subtasks = subtasksList.subtasks {
                task?.subtasks = subtasks
            }
            
            let tasksForDay = realm.objects(TaskForDay.self)
            let myPredicate = NSPredicate(format: "name == '\(taskOriginName)'")
            let tasksForDayFiltered = tasksForDay.filter(myPredicate)
            
            for task in tasksForDayFiltered {
                if task.id == self.task?.id {
                    task.name = self.textField.text!
                }
            }
            // print("updated task: ", task as Any)
        }
        
        tasksTitleLabel.text = task?.name
        
        textField.resignFirstResponder()
        textField.isHidden = true
        
        tasksTitleLabel.isHidden = false
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .edit, target: self, action: #selector(editTask)), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text! == "" {
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let contentHeight = 24 + tasksTitleLabel.frame.height + 24 + subtasksTitleLabel.frame.height + 16 + subtasksList.collectionView.contentSize.height + 48
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }
    
    func setupKeyboardObservers() {

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        
        scrollViewBottomAnchor?.constant = -keyboardFrame!.height
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = 24
        scrollView.contentInset = contentInset
        
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        
        scrollViewBottomAnchor?.constant = -48
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
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
        
        scrollView.addSubview(textField)
        textField.text = tasksTitleLabel.text
        textField.isHidden = true
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true

        scrollView.addSubview(subtasksTitleLabel)
        subtasksTitleLabel.topAnchor.constraint(equalTo: tasksTitleLabel.bottomAnchor, constant: 48).isActive = true
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
