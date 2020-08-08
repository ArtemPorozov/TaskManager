//
//  TaskController.swift
//  TaskManager
//
//  Created by Artem on 24.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

final class TaskController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Private Properties

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private let tasksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Task"
        label.font = .boldSystemFont(ofSize: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.font = .boldSystemFont(ofSize: 42)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let subtasksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtasks"
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtasksList = SubtasksList()
    private var task: Task?
    private var scrollViewBottomAnchor: NSLayoutConstraint?
        
    // MARK: - Initializers
    
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        self.subtasksList.subtasks = task.subtasks
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupViews()
        setupKeyboardObservers()
        // dismissing the keyboard by tapping the screen
        setupGestureRecognizer()
        
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let contentHeight = 24 + tasksTitleLabel.frame.height + 24 + subtasksTitleLabel.frame.height + 16 + subtasksList.collectionView.contentSize.height + 48
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
                
        view.backgroundColor = .white

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
        
        tasksTitleLabel.text = task?.name
        
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
    
    private func setupKeyboardObservers() {

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification) {
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        scrollViewBottomAnchor?.constant = -keyboardFrame.height
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = 24
        scrollView.contentInset = contentInset
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification) {
        
        guard let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        scrollViewBottomAnchor?.constant = -48
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(addSubtask))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func addSubtask() {
        self.view.endEditing(true)
        subtasksList.saveSubtask()
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == "" {
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if self.textField.text == "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
}
