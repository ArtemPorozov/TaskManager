//
//  BaseSubtasksList.swift
//  TaskManager
//
//  Created by Artem on 24.06.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

class BaseSubtasksList: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var numItems: Int?
    var itemHeight: CGFloat = 36
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum CellType: String {
        case subtask
        case addSubtask
        case selectSubtask
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        self.collectionView.contentInsetAdjustmentBehavior = .never
        
//        collectionView.register(SubtaskCell.self, forCellWithReuseIdentifier: CellType.subtask.rawValue)
//        collectionView.register(AddSubtaskCell.self, forCellWithReuseIdentifier: CellType.addSubtask.rawValue)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        numItems = collectionView.numberOfItems(inSection: 0)
        
    }
    
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
