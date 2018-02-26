//
//  BaseModel.swift
//  TZBTV
//
//  Created by mac  on 2018/2/26.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

class BaseModel: NSObject {
//    override init() {
//
//    }
    
    init(dict : [String : Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
