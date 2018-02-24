//
//  HYTitleView.swift
//  TZBTV
//
//  Created by mac  on 2018/2/24.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

protocol HYTitleViewDelegate : class{
    func titleView(_ titleView : HYTitleView, selectedIndex : Int)
}

class HYTitleView: UIView {

    weak var delegate : HYTitleViewDelegate?
    
    fileprivate lazy var normalColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = getRGBWithColor(self.style.normalColor)
    fileprivate lazy var selectedColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = getRGBWithColor(self.style.normalColor)
    
    fileprivate var titles : [String]!
    fileprivate var style : HYTitleStyle!
    
    fileprivate var selectedIndex : Int = 0
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView : UIScrollView = {
        print("rect:\(self.bounds)")
        let scrollV = UIScrollView(frame: self.bounds)
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.scrollsToTop = false
        scrollV.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        //scrollV.backgroundColor = UIColor.blue
        return scrollV
    }()
    
    fileprivate lazy var splitLineView : UIView = {
       var lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        let h : CGFloat = 0.5
        lineView.frame = CGRect(x: 0, y: frame.height - h, width: frame.width, height: h)
        return lineView
    }()
    
    fileprivate lazy var bottomLineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = self.style.bottomLineColor
        return lineView
    }()
    
    init(frame: CGRect,titles:[String],style:HYTitleStyle) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.green
        self.clipsToBounds = false
        self.titles = titles
        self.style = style
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension HYTitleView{
    fileprivate func setupUI(){
        //1.添加ScrollView
        addSubview(scrollView)
        
        //2.添加底部分割线
        addSubview(splitLineView)
        
        //3.设置所有的标题label
        setupTitleLabels()
        
        //4.设置laleb的位置
        setupTitleLabelPosition()
        
        //5.设置底部滚动条
        if style.isShowBottomLine{
            setupBottomLine()
        }
    }
    
    fileprivate func setupTitleLabels(){
        for (index, title) in titles.enumerated(){
            let label = UILabel()
            //label.backgroundColor = UIColor.randomColor()
            label.tag = index
            label.text = title
            label.font = style.font
            label.textColor = index == 0 ? style.selectedColor : style.normalColor
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleTap(tap:)))
            label.addGestureRecognizer(tapGes)
            
            titleLabels.append(label)
            scrollView.addSubview(label)
        }
    }
    
    fileprivate func setupTitleLabelPosition(){
        var titleX : CGFloat = 0
        let titleY : CGFloat = 0
        var titleW : CGFloat = 0
        let titleH : CGFloat = frame.height
        print("titleH:\(titleH)")
        
        let count = titleLabels.count
        
        for (index, label) in titleLabels.enumerated(){
            if style.isScrollEnable{
                let rect = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [/*NSAttributedStringKey.font*/NSAttributedStringKey.font : style.font], context: nil)
                titleW = rect.width
                if index == 0 {
                    titleX = style.titleMargin * 0.5
                }else{
                    titleX = titleLabels[index - 1].frame.maxX + style.titleMargin
                }
            }else{
                titleW = scrollView.frame.width / CGFloat(count)
                titleX = CGFloat(index) * titleW
            }
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        }
        
        if style.isScrollEnable{
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: scrollView.frame.height)
        }
        
    }
    
    fileprivate func setupBottomLine(){
        scrollView.addSubview(bottomLineView)
//        bottomLineView.frame = titleLabels.first!.frame
//        bottomLineView.frame.size.height = style.bottomLineHeight
//        bottomLineView.frame.origin.y = bounds.height - style.bottomLineHeight
        bottomLineView.frame = CGRect(x: titleLabels.first!.frame.origin.x, y: bounds.height - style.bottomLineHeight, width: titleLabels.first!.frame.width, height: style.bottomLineHeight)
    }
    
    
}

//MARK: 事件
extension HYTitleView{
    @objc fileprivate func titleTap(tap : UITapGestureRecognizer) -> Void{
        let targetLabel = tap.view as! UILabel
        let sourceLabel = titleLabels[selectedIndex]
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectedColor
        selectedIndex = targetLabel.tag
        
        //居中显示
        contentViewDidEndScroll()
        //通知代理
        delegate?.titleView(self, selectedIndex: selectedIndex)
        
        if style.isShowBottomLine{
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLineView.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLineView.frame.size.width = targetLabel.frame.width
            })
        }
        
    }
    
}

//MARK: 获取RGB的值
extension HYTitleView{
    fileprivate func getRGBWithColor(_ color : UIColor) -> (CGFloat,CGFloat,CGFloat){
        guard let components = color.cgColor.components else{
            fatalError("")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
        
    }
}

//MARK: - 对外暴露的方法
extension HYTitleView{
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2.颜色渐变
        //2.1.渐变范围
        let colorDelta = (selectedColorRGB.0 - normalColorRGB.0,selectedColorRGB.1 - normalColorRGB.1, selectedColorRGB.2 - normalColorRGB.2)
        //2.2.sourceLabel颜色变化
        sourceLabel.textColor = UIColor(r: selectedColorRGB.0 - progress * colorDelta.0, g: selectedColorRGB.1 - progress * colorDelta.1, b: selectedColorRGB.2 - progress * colorDelta.2)
        //2.3target颜色变化
        targetLabel.textColor = UIColor(r: normalColorRGB.0 + progress * colorDelta.0, g: normalColorRGB.1 + progress * colorDelta.1, b: normalColorRGB.2 + progress * colorDelta.2)
    }
    
    func contentViewDidEndScroll(){
        guard style.isScrollEnable else {
            return
        }
        
        let label = titleLabels[selectedIndex]
        
        var offsetX = label.center.x - bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        scrollView.setContentOffset(CGPoint(x : offsetX, y : 0), animated: true)
        
    }
}
