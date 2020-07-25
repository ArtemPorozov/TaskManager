//
//  DayCell.swift
//  TaskManager
//
//  Created by Artem on 29.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 40)
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
        
        addSubview(progressLabel)
        progressLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        progressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
}


