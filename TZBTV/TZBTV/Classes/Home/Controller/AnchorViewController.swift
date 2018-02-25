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

    lazy var collectionview : UICollectionView = {
        let waterLayout = WatterfallLayout()
        waterLayout.sectionInset = UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin)
        waterLayout.minimumLineSpacing = kMargin
        waterLayout.minimumInteritemSpacing = kMargin
        waterLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: waterLayout)
        view.backgroundColor = UIColor.white
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        view.dataSource = self
        view.delegate = self
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]//这句一定要加
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AnchorViewController {
    func setupUI() -> Void {
        view.addSubview(collectionview)
    }
}

extension AnchorViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
        cell.contentView.backgroundColor = UIColor.randomColor()
        return cell
    }
    
}

extension AnchorViewController : UICollectionViewDelegate {
    
}
