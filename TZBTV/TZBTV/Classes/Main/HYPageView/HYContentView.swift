//
//  HYContentView.swift
//  TZBTV
//
//  Created by mac  on 2018/2/24.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

fileprivate let kCellID = "CELL"

@objc protocol HYContentViewDelegate : class {
    
    func contentView(_ contentView : HYContentView, progres : CGFloat, sourceIndex : Int, targetIndex : Int)
    
    @objc optional func contentViewEndScroll(_ contentView : HYContentView)
}

class HYContentView: UIView {

    weak var delegate : HYContentViewDelegate?
    
    private let childVCs : [UIViewController]!
    
    private let parentVC : UIViewController!
    
    private var isForbidScrollDelegate : Bool = false
    
    private var startOffsetX : CGFloat = 0.0
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectView.isPagingEnabled = true
        collectView.showsHorizontalScrollIndicator = false
        collectView.bounces = false
        collectView.dataSource = self
        collectView.delegate = self
        collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        return collectView
    }()
    
    
    init(frame: CGRect,childVCs : [UIViewController], parentVC : UIViewController) {
        self.childVCs = childVCs;
        self.parentVC = parentVC;
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HYContentView{
    func setupUI() -> Void {
        for vc in childVCs {
            parentVC.addChildViewController(vc)
        }
        
        addSubview(collectionView)
    }
}

extension HYContentView : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let vc = childVCs[indexPath.item]
        cell.contentView.addSubview(vc.view)
        vc.view.frame = cell.contentView.bounds
        return cell
    }
}


extension HYContentView : UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0.判断是否点击事件
        if isForbidScrollDelegate {
            return
        }
        
        //1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {//左滑
            //1.计算progress
            //floor(currentOffsetX / scrollViewW) 向下取整 0.2->0.0 0.5->0.0 0.8->0.0
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            //2.计算sourceIndex
            //Int(currentOffsetX / scrollViewW) 向下取整 1.7 ->1
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            if(targetIndex >= childVCs.count){
                targetIndex = childVCs.count - 1
            }
            
            //4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{ // 右滑
            //1.计算process
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            //2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            //3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if(sourceIndex >= childVCs.count){
                sourceIndex = childVCs.count - 1
            }
        }
        delegate?.contentView(self, progres: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll?(self)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            delegate?.contentViewEndScroll?(self)
        }
    }
}

// MARK : 对外暴露的方法
extension HYContentView{
    func setCurrentIndex(_ index :Int) -> Void {
        //1.记录标识
        isForbidScrollDelegate = true
        //2.滚动到正确的位置，会调用didScroll方法
        let offsetX = collectionView.frame.width * CGFloat(index)
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
