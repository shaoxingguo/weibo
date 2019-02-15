//
//  XGImagePickerCollectionViewController.swift
//  weibo
//
//  Created by monkey on 2019/2/15.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

/// cell重用标识符
private let kReuseIdentifier = "XGImagePickerCollectionViewCell"

class XGImagePickerCollectionViewController: UICollectionViewController
{

    // MARK: - 构造方法
    
    init()
    {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        setUpCollectionView()
        view.layoutIfNeeded()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 9
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseIdentifier, for: indexPath) as! XGImagePickerCollectionViewCell
        
        return cell
    }
}

// MARK: - 其他私有方法

extension XGImagePickerCollectionViewController
{
    /// 设置CollectionView
    private func setUpCollectionView() -> Void
    {
        // 设置布局
        let columns:Int = 3 // 列数
        let itemWidth:CGFloat = 100
        let margin = (collectionView.width - CGFloat(columns) * itemWidth) / CGFloat(columns - 1 + 2)
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
        
        collectionView.bounces = false
        collectionView.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
        
        // 注册cell
        collectionView.register(XGImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: kReuseIdentifier)
    }
}
