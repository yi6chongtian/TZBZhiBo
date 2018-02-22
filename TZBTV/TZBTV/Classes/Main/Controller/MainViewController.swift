//
//  MainViewController.swift
//  TZBTV
//
//  Created by mac  on 2018/2/22.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC("Home")
        addChildVC("Rank")
        addChildVC("Discover")
        addChildVC("Profile")
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func addChildVC(_ storyboard:String) ->Void{
        let childVC = UIStoryboard(name: storyboard, bundle:Bundle.main).instantiateInitialViewController()!
        childVC.view.backgroundColor = UIColor.randomColor()
        self.addChildViewController(childVC)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
