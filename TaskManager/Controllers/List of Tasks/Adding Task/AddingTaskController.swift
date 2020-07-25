//
//  AddingTaskController.swift
//  TaskManager
//
//  Created by Artem on 08.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit
import RealmSwift

protocol AddingTaskControllerDelegate: class {
    func updateCollectionView()
}

class AddingTaskController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: AddingTaskControllerDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
        
    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 24)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.becomeFirstResponder()
        return textField
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = .init(8)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let colorsArray: [UIColor] = [#colorLiteral(red: 0.7255310416, green: 0.841386497, blue: 0.9580315948, alpha: 1), #colorLiteral(red: 1, green: 0.6965349317, blue: 0.6934005022, alpha: 1), #colorLiteral(red: 0.9972595572, green: 0.9766866565, blue: 0.6829898953, alpha: 1), #colorLiteral(red: 0.770422399, green: 1, blue: 0.6855098009, alpha: 1), #colorLiteral(red: 0.9998723865, green: 0.8488969803, blue: 0.688331604, alpha: 1), #colorLiteral(red: 0.6878448129, green: 0.9979556203, blue: 0.9499351382, alpha: 1), #colorLiteral(red: 0.694781661, green: 0.7719338536, blue: 1, alpha: 1), #colorLiteral(red: 0.8936495185, green: 0.6900729537, blue: 1, alpha: 1), #colorLiteral(red: 0.9830673337, green: 0.680178225, blue: 0.4388229251, alpha: 1)]
        
    let subtasksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtasks"
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtasksList = AddingSubtasksList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .white
        navigationItem.title = "New Task"
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .done, target: self, action: #selector(saveTask)), animated: true)
        navigationItem.setLeftBarButton(.init(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss)), animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        setupViews()
        setupKeyboardObservers()
        
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // dismissing the keyboard by tapping the screen
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        stackView.arrangedSubviews.forEach({ $0.isUserInteractionEnabled = true })
        stackView.arrangedSubviews.forEach({ $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectColor))) })
    }
    
    var selectedColor: UIColor?
    
    @objc fileprivate func selectColor(gesture: UIGestureRecognizer) {
        
        self.stackView.arrangedSubviews.forEach( {$0.layer.borderWidth = 0.5} )
        let view = gesture.view
        view?.layer.borderWidth = 2.0

        textField.backgroundColor = view?.backgroundColor
        self.selectedColor = view?.backgroundColor
    }
    
    @objc fileprivate func saveTask() {
        
        let task = Task()
        task.name = textField.text!
//        task.isCompleted = false
        task.color = setColor()
        task.subtasks = subtasksList.subtasks
        
        let realm = try! Realm()
        
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
        
        try! realm.write {
            realm.add(task)
        }
        handleDismiss()
    }
    
    fileprivate func setColor() -> TaskColor {
        
        let taskColor = TaskColor()
        
        if let color = self.selectedColor {
            let colorComponents = color.cgColor.components!
            let floatComponents = colorComponents.map { Float($0) }
            taskColor.colorComponents.append(floatComponents[0])
            taskColor.colorComponents.append(floatComponents[1])
            taskColor.colorComponents.append(floatComponents[2])
            taskColor.colorComponents.append(floatComponents[3])
        } else {
            let color = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            let colorComponents = color.cgColor.components!
            let floatComponents = colorComponents.map { Float($0) }
            taskColor.colorComponents.append(floatComponents[0])
            taskColor.colorComponents.append(floatComponents[1])
            taskColor.colorComponents.append(floatComponents[2])
            taskColor.colorComponents.append(floatComponents[3])
        }
        return taskColor
    }
    
    @objc fileprivate func handleDismiss() {
        
        delegate?.updateCollectionView()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        let contentHeight = 48 + textField.frame.height + 24 + stackView.frame.height + 48 + subtasksTitleLabel.frame.height + 16 + subtasksList.collectionView.contentSize.height + 48
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if self.textField.text! == "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text! == "" {
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
    
    var scrollViewBottomAnchor: NSLayoutConstraint?

    fileprivate func setupViews() {
                
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomAnchor?.isActive = true

        scrollView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 48).isActive = true
        textField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true

        for i in 0...8 {
            let label = UILabel()
            label.backgroundColor = colorsArray[i]
            label.layer.borderWidth = 0.5
            label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 36).isActive = true
            label.widthAnchor.constraint(equalToConstant: 36).isActive = true
            label.layer.cornerRadius = 18
            label.layer.masksToBounds = true
            label.isUserInteractionEnabled = true
            stackView.addArrangedSubview(label)
        }

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true

        let sizeOfArrangedSubview: CGSize = .init(width: 36, height: 36)
        stackView.widthAnchor.constraint(equalToConstant: CGFloat(colorsArray.count) * sizeOfArrangedSubview.width + CGFloat(colorsArray.count - 1) * stackView.spacing).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: sizeOfArrangedSubview.height).isActive = true

        scrollView.addSubview(subtasksTitleLabel)
        subtasksTitleLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 48).isActive = true
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
