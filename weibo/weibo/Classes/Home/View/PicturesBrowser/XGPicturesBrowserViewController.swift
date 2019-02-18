//
//  XGPicturesBrowserViewController.swift
//  weibo
//
//  Created by monkey on 2019/2/18.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGPicturesBrowserViewController: UIViewController
{
    
    // MARK: - 构造方法
    
    init(selectedIndex:Int,pictures:[XGPictureModel])
    {
        self.selectedIndex = selectedIndex
        self.pictures = pictures
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purple
    }
    
    // MARK: - 私有属性
    
    /// 选中的图片索引
    private var selectedIndex:Int = 0
    /// 浏览的图片数组模型
    private var pictures:[XGPictureModel]
    /// collectionView 展示图片
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var closeButton:UIButton = UIButton(title: "关闭", normalColor: UIColor.white, highlightedColor: UIColor.white, fontSize: 15, backgroundColor: UIColor.darkGray, target: nil, action: nil)
}
