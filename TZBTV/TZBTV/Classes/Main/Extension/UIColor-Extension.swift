//
//  UIColor-Extension.swift
//  TZBTV
//
//  Created by mac  on 2018/2/22.
//  Copyright © 2018年 mac . All rights reserved.
//

//import Foundation
import UIKit

extension UIColor{
    convenience init(r : CGFloat,g : CGFloat,b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor{
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    func getRGB() -> (CGFloat,CGFloat,CGFloat) {
        guard let compoments = self.cgColor.components else {
            fatalError("....")
        }
        return (compoments[0] * 255.0, compoments[1] * 255.0, compoments[2] * 255.0)
    }
    
}
