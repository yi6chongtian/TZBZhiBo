//
//  WatterfallLayout.swift
//  TZBTV
//
//  Created by tang on 2018/2/25.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

@objc protocol WatterfallLayoutDataSource : class {
    
    /// indexPath高度
    func waterfallLayout(_ layout : WatterfallLayout, indexPath : IndexPath) -> CGFloat
    ///列数
    @objc optional func numberOfColsInWaterfallLayout(_ layout : WatterfallLayout) -> Int
}

class WatterfallLayout: UICollectionViewFlowLayout {
    
    weak var datasource :WatterfallLayoutDataSource?
    
    var attributes : [UICollectionViewLayoutAttributes]? = [UICollectionViewLayoutAttributes]()
    
    fileprivate var maxH : CGFloat = 0
    
    fileprivate var startIndex : Int = 0
    
    fileprivate lazy var colHeights : [CGFloat] = {
        let cols = self.datasource?.numberOfColsInWaterfallLayout?(self) ?? 2
        var colHeights = Array(repeatElement(self.sectionInset.top, count: cols))
        return colHeights
    }()
    
    override func prepare() {
        super.prepare()
        
        let cols = datasource?.numberOfColsInWaterfallLayout?(self) ?? 2
        let itemCount = self.collectionView!.numberOfItems(inSection: 0)
        let itemW = (collectionView!.frame.width - sectionInset.left - sectionInset.right - CGFloat((cols - 1))*minimumInteritemSpacing) / CGFloat(cols)
        for i in startIndex..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            var attrX : CGFloat = 0
            var attrY : CGFloat = 0
            let attrW = itemW
            guard let attrH : CGFloat = datasource?.waterfallLayout(self, indexPath: indexPath) else{
                fatalError("请提供高度")
            }
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
        startIndex = itemCount
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
