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

final class MonthView: UIView {
    
    // MARK: - Public Properties
    
    weak var delegate: MonthViewDelegate?
    
    // MARK: - Private Properties
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previousMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("＜", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(changeMonth), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 96).isActive = true
        return button
    }()
    
    private let nextMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("＞", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(changeMonth), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 96).isActive = true
        return button
    }()
    
    private var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private var currentMonthIndex: Int = 0
    private var currentYear: Int = 0
    
    private var presentMonthIndex: Int = 0
    private var presentYear: Int = 0
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeData()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func initializeData() {
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
    }
    
    private func setupViews() {
        
        let stackView = UIStackView(arrangedSubviews: [
            previousMonthButton,
            monthLabel,
            nextMonthButton
        ])
        
        monthLabel.text = "\(months[presentMonthIndex]) \(presentYear)"
        monthLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    @objc private func changeMonth(button: UIButton) {
        
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
