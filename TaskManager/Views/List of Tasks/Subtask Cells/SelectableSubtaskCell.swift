//
//  SelectableSubtaskCell.swift
//  TaskManager
//
//  Created by Artem on 08.07.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

final class SelectableSubtaskCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    let isSelectedLabel: UILabel = {
        let label = UILabel()
        label.text = "○"
        label.textColor = .orange
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.widthAnchor.constraint(equalToConstant: 22).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let subtaskLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtask"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: - Private Properties
    
    private let stackView = UIStackView(frame: .zero)
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0.3, alpha: 0.3)
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func initializeViews() {
        
        backgroundColor = .white
        
        stackView.addArrangedSubview(isSelectedLabel)
        stackView.addArrangedSubview(subtaskLabel)
        
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
        separatorView.leadingAnchor.constraint(equalTo: subtaskLabel.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
}
