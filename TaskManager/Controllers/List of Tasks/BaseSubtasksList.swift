//
//  BaseSubtasksList.swift
//  TaskManager
//
//  Created by Artem on 24.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

class BaseSubtasksList: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // MARK: - Public Properties

    var numItems: Int?
    var itemHeight: CGFloat = 36
    
    enum CellType: String {
        case subtask
        case addSubtask
        case selectSubtask
    }
    
    // MARK: - Initializers

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        numItems = collectionView.numberOfItems(inSection: 0)
    }
    
    // MARK: - Private Methods

    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
