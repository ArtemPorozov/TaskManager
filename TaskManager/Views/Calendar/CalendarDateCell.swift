//
//  CalendarDateCell.swift
//  TaskManager
//
//  Created by Artem on 24.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

final class CalendarDateCell: UICollectionViewCell {
        
    // MARK: - Public Properties

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.layer.cornerRadius = 19
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods

    private func setupViews() {
        
        backgroundColor = .white

        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
}
