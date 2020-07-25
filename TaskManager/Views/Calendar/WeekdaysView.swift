//
//  WeekdaysView.swift
//  TaskManager
//
//  Created by Artem on 24.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

class WeekdaysView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        let weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
        for i in 0...6 {
            let label = UILabel()
            label.text = weekdays[i]
            label.font = .systemFont(ofSize: 18)
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
}
