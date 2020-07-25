//
//  AddSubtaskCell.swift
//  TaskManager
//
//  Created by Artem on 21.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

class AddSubtaskCell: UICollectionViewCell {
    
    let stackView = UIStackView(frame: .zero)
    
    let addSubtaskLabel: UILabel = {
        let label = UILabel()
        label.text = "⨁"
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.widthAnchor.constraint(equalToConstant: 22).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 18)
//        textField.borderStyle = .roundedRect
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0.3, alpha: 0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initializeViews() {
        
        backgroundColor = .white
                
        self.stackView.addArrangedSubview(addSubtaskLabel)
        self.stackView.addArrangedSubview(textField)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        addSubview(separatorView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -4).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
