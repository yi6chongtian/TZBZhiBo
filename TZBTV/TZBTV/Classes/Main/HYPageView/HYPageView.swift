//
//  HYPageView.swift
//  TZBTV
//
//  Created by mac  on 2018/2/24.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

class HYPageView: UIView {
    fileprivate let titles : [String]
    fileprivate let style : HYTitleStyle
    fileprivate let childVCs : [UIViewController]
    fileprivate let parentVC : UIViewController
    
    fileprivate var titleView : HYTitleView!
    fileprivate var contentView : HYContentView!
    
    init(frame : CGRect, titles:[String], style : HYTitleStyle, childVCs : [UIViewController], parentVC : UIViewController){
        self.titles = titles
        self.style = style
        self.childVCs = childVCs
        self.parentVC = parentVC
        parentVC.automaticallyAdjustsScrollViewInsets = false
        guard titles.count == childVCs.count else {
            fatalError("个数不相等")
        }
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HYPageView{
    func setupUI() -> Void {
        let titleRect = CGRect(x: 0, y: 0, width: bounds.width, height: 64)
        let titleView = HYTitleView(frame: titleRect, titles: titles, style: style)
        addSubview(titleView)
        self.titleView = titleView
        
        let contentRect = CGRect(x: 0, y: titleRect.maxY, width: bounds.width, height: bounds.height - titleRect.height)
        let contentView = HYContentView(frame: contentRect, childVCs: childVCs, parentVC: parentVC)
        addSubview(contentView)
        self.contentView = contentView
        
        //设置代理
        titleView.delegate = self
        contentView.delegate = self
    }
}

extension HYPageView : HYTitleViewDelegate{
    func titleView(_ titleView: HYTitleView, selectedIndex: Int) {
        contentView.setCurrentIndex(selectedIndex)
    }
}

extension HYPageView : HYContentViewDelegate{
    func contentViewEndScroll(_ contentView: HYContentView) {
        titleView.contentViewDidEndScroll()
    }
    
    func contentView(_ contentView : HYContentView, progres : CGFloat, sourceIndex : Int, targetIndex : Int){
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
