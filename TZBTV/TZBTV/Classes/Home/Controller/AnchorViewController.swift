//
//  AnchorViewController.swift
//  TZBTV
//
//  Created by tang on 2018/2/25.
//  Copyright © 2018年 mac . All rights reserved.
//

import UIKit

private let kMargin : CGFloat = 8
private let kCellID = "CELL"

class AnchorViewController: UIViewController {
    
    var homeType : HomeType!
    lazy var homeVM : HomeViewModel = HomeViewModel()
    lazy var collectionview : UICollectionView = {
        let waterLayout = WatterfallLayout()
        waterLayout.datasource = self
        waterLayout.sectionInset = UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin)
        waterLayout.minimumLineSpacing = kMargin
        waterLayout.minimumInteritemSpacing = kMargin
        waterLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: waterLayout)
        view.backgroundColor = UIColor.white
        //view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        let nib = UINib(nibName: "HomeViewCell", bundle: Bundle.main)
        view.register(nib, forCellWithReuseIdentifier: kCellID)
        view.dataSource = self
        view.delegate = self
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]//这句一定要加
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AnchorViewController {
    func loadData(index : Int) -> Void {
        homeVM.loadHomeData(type: homeType, index: index) {
            self.collectionview.reloadData()
        }
    }
}

extension AnchorViewController {
    func setupUI() -> Void {
        view.backgroundColor = UIColor.white
        view.addSubview(collectionview)
    }
}

extension AnchorViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! HomeViewCell
        //cell.contentView.backgroundColor = UIColor.randomColor()
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        if indexPath.item == homeVM.anchorModels.count - 1 {
            loadData(index: homeVM.anchorModels.count)
        }
        return cell
    }
    
}

extension AnchorViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomVC = RoomViewController()
        navigationController?.pushViewController(roomVC, animated: true)
    }
}

extension AnchorViewController : WatterfallLayoutDataSource {
    func numberOfColsInWaterfallLayout(_ layout: WatterfallLayout) -> Int {
        return 2
    }
    
    func waterfallLayout(_ layout: WatterfallLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
}
