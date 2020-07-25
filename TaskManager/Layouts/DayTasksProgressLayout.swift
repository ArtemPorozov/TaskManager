//
//  DayTasksProgressLayout.swift
//  TaskManager
//
//  Created by Artem on 30.05.2020.
//  Copyright © 2020 Artem P. All rights reserved.
//

import UIKit

class DayTasksProgressLayout: UICollectionViewFlowLayout, UIScrollViewDelegate {
        
    // сделать так, чтобы при листании вниз и влево верхняя строка и левый столбец не были закреплены
    
    var numberOfColumns: Int = 0
    
    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var contentSize: CGSize = .zero
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        self.numberOfColumns = collectionView.numberOfItems(inSection: 0)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }
                        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if section != 0 && item != 0 {
                    continue
                }
                
                
                
                let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))!
                if section == 0 {
                    attributes.frame.origin.y = collectionView.contentOffset.y + collectionView.safeAreaInsets.top
                }

                if item == 0 {
                    attributes.frame.origin.x = collectionView.contentOffset.x
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }
            attributes.append(contentsOf: filteredArray)
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        guard let collectionView = self.collectionView else {
            return parent
        }
        
        let cellWidth = sizeForItemWithColumnIndex(1).width
        let itemWidth = 3 * cellWidth
        let itemSpace = itemWidth + minimumInteritemSpacing
        var pageNumber = round(collectionView.contentOffset.x / itemWidth)
        
        if velocity.x > 0 {
            pageNumber += 1
        } else if velocity.x < 0 {
            pageNumber -= 1
        }
        
        let nearestPageOffset = pageNumber * itemSpace
        return CGPoint(x: nearestPageOffset, y: parent.y)
    }
}

extension DayTasksProgressLayout {
    
    fileprivate func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        switch columnIndex {
        case 0:
            return CGSize(width: 172, height: 70)
        default:
            return CGSize(width: 70, height: 70)
        }
    }
    
    func generateItemAttributes(collectionView: UICollectionView) {
        
//        scrollDirection = .horizontal
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        
        itemAttributes = []
        
        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
            for index in 0..<numberOfColumns {
                let itemSize = sizeForItemWithColumnIndex(index)
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                if section == 0 && index == 0 {
                    // First cell should be on top
                    attributes.zIndex = 2
                } else if section == 0 || index == 0 {
                    // First row/column should be above other cells
                    attributes.zIndex = 1
                }
                
                if section == 0 {
                    attributes.frame.origin.y = collectionView.contentOffset.y + collectionView.safeAreaInsets.top
                }
                if index == 0 {
                    attributes.frame.origin.x = collectionView.contentOffset.x
                }
                
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                column += 1
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            
            itemAttributes.append(sectionAttributes)
        }
        
        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }
}
