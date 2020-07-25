//
//  DayHeaderCell.swift
//  TaskManager
//
//  Created by Artem on 28.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

class DayHeaderCell: UICollectionViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "9"
        label.font = .systemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weekdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Fr"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        
        let stackView = UIStackView(arrangedSubviews: [
            dateLabel,
            weekdayLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
}
