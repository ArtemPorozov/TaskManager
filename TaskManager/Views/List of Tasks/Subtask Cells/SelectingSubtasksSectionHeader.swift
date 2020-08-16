//
//  SelectingSubtasksSectionHeader.swift
//  TaskManager
//
//  Created by Artem on 09.08.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

final class SelectingSubtasksSectionHeader: UICollectionReusableView {
    
    // MARK: - Public Properties

    var label: UILabel = {
        let label = UILabel()
        label.text = "0 subtasks selected"
        label.font = .boldSystemFont(ofSize: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    
    private func setupViews() {
        addSubview(label)
        
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
}
