//
//  TasksNameCell.swift
//  TaskManager
//
//  Created by Artem on 28.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

final class TasksNameCell: UICollectionViewCell {
    
    // MARK: - Public Properties

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 28)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods

    private func setupView() {

        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
}
