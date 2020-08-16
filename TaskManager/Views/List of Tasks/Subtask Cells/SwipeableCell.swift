//
//  SwipeableCell.swift
//  TaskManager
//
//  Created by Artem on 02.07.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

protocol SwipeableCollectionViewCellDelegate: class {
    func deleteLabelTapped(inCell cell: UICollectionViewCell)
}

class SwipeableCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties

    let visibleContainerView = UIView()
    weak var delegate: SwipeableCollectionViewCellDelegate?
    
    // MARK: - Private Properties

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let hiddenContainerView = UIView()
    
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .init(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods

    private func setupSubviews() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(visibleContainerView)
        stackView.addArrangedSubview(hiddenContainerView)
        
        addSubview(scrollView)
        scrollView.pinEdgesToSuperView()
        
        scrollView.addSubview(stackView)
        stackView.pinEdgesToSuperView()
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2).isActive = true
        
        hiddenContainerView.addSubview(deleteLabel)
        hiddenContainerView.backgroundColor = .clear
        deleteLabel.trailingAnchor.constraint(equalTo: hiddenContainerView.trailingAnchor).isActive = true
        deleteLabel.centerYAnchor.constraint(equalTo: hiddenContainerView.centerYAnchor).isActive = true
        deleteLabel.widthAnchor.constraint(equalToConstant: 72).isActive = true
        deleteLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let deleteItemTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteLabelTapped))
        deleteLabel.addGestureRecognizer(deleteItemTapGestureRecognizer)
    }
    
    @objc private func deleteLabelTapped() {
        delegate?.deleteLabelTapped(inCell: self)
    }

}
