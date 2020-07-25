//
//  MonthView.swift
//  TaskManager
//
//  Created by Artem on 24.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(month: Int, year: Int)
}

class MonthView: UIView {
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    
    var presentMonthIndex: Int = 0
    var presentYear: Int = 0
    
    weak var delegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        let stackView = UIStackView(arrangedSubviews: [
            previousMonthButton,
            monthLabel,
            nextMonthButton
        ])
        
        monthLabel.text = "\(months[presentMonthIndex]) \(presentYear)"
        monthLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "February 2020"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let previousMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("＜", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(changeMonth), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }()

    let nextMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("＞", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(changeMonth), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }()
    
    @objc fileprivate func changeMonth(button: UIButton) {
        
        switch button {
        case previousMonthButton:
            presentMonthIndex -= 1
            if presentMonthIndex < 0 {
                presentMonthIndex = 11
                presentYear -= 1
            }
        case nextMonthButton:
            presentMonthIndex += 1
            if presentMonthIndex > 11 {
                presentMonthIndex = 0
                presentYear += 1
            }
        default:
            break
        }
        monthLabel.text = "\(months[presentMonthIndex]) \(presentYear)"
        delegate?.didChangeMonth(month: presentMonthIndex, year: presentYear)
    }
}


