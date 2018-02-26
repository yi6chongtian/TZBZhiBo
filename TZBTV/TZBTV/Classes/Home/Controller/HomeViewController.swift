//
//  HomeViewController.swift
//  TZBTV
//
//  Created by mac  on 2018/2/22.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController{
    fileprivate func setupUI() -> Void {
        //view.backgroundColor = UIColor.randomColor()
        self.automaticallyAdjustsScrollViewInsets = false
        setupNaviBar()
        
        setupContentView()
        
    }
    
    fileprivate func setupNaviBar(){
        //home-logo search_btn_follow
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let logoImage = UIImage(named: "home-logo")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        let rightImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: nil, action: nil)
        
        let searchRect = CGRect(x: 0, y: 0, width: 200, height: 32)
        let searchBar = UISearchBar(frame: searchRect)
        searchBar.placeholder = "主播昵称/房间号/链接"
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white
        navigationItem.titleView = searchBar
        
//        //获取UISearchBar的所有成员变量
//        var count:UInt32 = 0;
//        let ivars = class_copyIvarList(UISearchBar.self, &count)!
//        for i in 0..<count{
//            let nameC = ivar_getName(ivars[Int(i)])
//            let namePro = String(cString: nameC!)
//            print(namePro)
//        }
    }
    
    fileprivate func setupContentView(){
        let typelist = loadTypeData()
        let titles = typelist.map { $0.title}
        
        var vcList = [UIViewController]()
        for i in 0..<titles.count {
            let vc = AnchorViewController()
            vc.homeType = typelist[i]
            vcList.append(vc)
        }
        
        let style = HYTitleStyle()
        style.isShowBottomLine = true
        style.isScrollEnable = true
//        print( UIApplication.shared.statusBarFrame.height)
//        print( self.navigationController?.navigationBar.frame)
        let pageY = kStatusBarH + kNavigationBarH + 0;
        let pageRect = CGRect(x: 0, y: pageY, width: kScreenW, height: view.bounds.height - pageY - kTabBarH)
        let pageView = HYPageView(frame: pageRect, titles: titles, style: style, childVCs: vcList, parentVC: self)
        view.addSubview(pageView)
        
    }
}

extension HomeViewController {
    func loadTypeData() -> [HomeType] {
        var homeTypeList = [HomeType]()
        let path = Bundle.main.path(forResource: "types", ofType: "plist")!
        let array = NSArray(contentsOfFile: path) as! [[String : Any]]
        for dict in array {
            let hometype = HomeType(dict: dict)
            homeTypeList.append(hometype)
        }
        return homeTypeList
    }
}
