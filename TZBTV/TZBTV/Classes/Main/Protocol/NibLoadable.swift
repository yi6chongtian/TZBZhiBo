//
//  NibLoadable.swift
//  TZBTV
//
//  Created by mac  on 2018/2/26.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
