//
//  WatterfallLayout.swift
//  TZBTV
//
//  Created by tang on 2018/2/25.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

//protocol WatterfallLayoutDataSource {
//
//}

class WatterfallLayout: UICollectionViewFlowLayout {
    
    var attributes : [UICollectionViewLayoutAttributes]? = [UICollectionViewLayoutAttributes]()
    
    var maxH : CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        let cols = 2
        let itemCount = self.collectionView!.numberOfItems(inSection: 0)
        let itemW = (collectionView!.frame.width - sectionInset.left - sectionInset.right - CGFloat((cols - 1))*minimumInteritemSpacing) / CGFloat(cols)
        var colHeights = Array(repeating: sectionInset.top, count: cols)
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            var attrX : CGFloat = 0
            var attrY : CGFloat = 0
            let attrW = itemW
            let attrH : CGFloat = CGFloat(arc4random_uniform(100)) + 100.0
            let minH = colHeights.min()!
            let index = colHeights.index(of: minH)!
            attrX = sectionInset.left + (attrW + minimumInteritemSpacing) * CGFloat(index)
            attrY = minH
            attr.frame = CGRect(x: attrX, y: attrY, width: itemW, height: attrH)
            attributes?.append(attr)
            colHeights[index] += (attrH + minimumLineSpacing)
            //maxH = colHeights[index]
        }
        maxH = colHeights.max()!
    }
}

extension WatterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing)
    }
}
