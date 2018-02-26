//
//  HomeViewModel.swift
//  TZBTV
//
//  Created by mac  on 2018/2/26.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    var anchorModels : [AnchorModel] = [AnchorModel]()
}

extension HomeViewModel {
    func loadHomeData(type : HomeType, index : Int, finishedCallback : @escaping () -> ()) -> Void {
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type" : type.type, "index" : index, "size" : 48], finishedCallback: { (result) -> Void in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            
            for (index, dict) in dataArray.enumerated() {
                let anchor = AnchorModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }
            
            finishedCallback()
        })
    }
}
