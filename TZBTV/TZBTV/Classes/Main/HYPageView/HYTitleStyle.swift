//
//  HYTitleStyle.swift
//  TZBTV
//
//  Created by mac  on 2018/2/24.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

class HYTitleStyle: NSObject {
    ///普通标题的颜色
    var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    ///选中标题颜色
    var selectedColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    ///文本字体大小
    var font : UIFont = UIFont.systemFont(ofSize: 14.0)
    ///是否可以滚动
    var isScrollEnable : Bool = false
    ///滚动Title的字体间距
    var titleMargin : CGFloat = 20
    /// 设置titleView的高度
    var titleHeight : CGFloat = 44
    ///是否显示底部滚动条
    var isShowBottomLine : Bool = false
    ///底部滚动条高度
    var bottomLineHeight : CGFloat = 2
    ///底部滚动条颜色
    var bottomLineColor : UIColor = UIColor.orange
}
