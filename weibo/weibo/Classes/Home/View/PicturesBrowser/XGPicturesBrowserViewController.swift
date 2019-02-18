//
//  XGPicturesBrowserViewController.swift
//  weibo
//
//  Created by monkey on 2019/2/18.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

/// cell重用标识符
private let kReuseIdentifier = "XGPicturesBrowserCollectionViewCell"

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
    
    override func loadView()
    {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black
        setUpUI()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 滚动到选中的图片
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: indexPath, at: [], animated: false)
        }
    }
    
    // MARK: - 事件监听
    
    /// 关闭按钮事件监听
    @objc private func closeAction() -> Void
    {
        dismiss(animated: true, completion: nil)
    }
    
    /// 保存按钮事件监听
    @objc private func savePictureAction() -> Void
    {
        XGPrint("保存")
    }
    
    // MARK: - 私有属性
    
    /// 选中的图片索引
    private var selectedIndex:Int = 0
    /// 浏览的图片数组模型
    private var pictures:[XGPictureModel]
    /// collectionView 展示图片
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    /// 关闭按钮
    private lazy var closeButton:UIButton = UIButton(title: "关闭", normalColor: UIColor.white, highlightedColor: UIColor.white, fontSize: 15, backgroundColor: UIColor.darkGray, target: self, action: #selector(closeAction))
    /// 保存按钮
    private lazy var saveButton:UIButton = UIButton(title: "保存", normalColor: UIColor.white, highlightedColor: UIColor.white, fontSize: 15, backgroundColor: UIColor.darkGray, target: self, action: #selector(savePictureAction))
}

extension XGPicturesBrowserViewController:UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseIdentifier, for: indexPath) as! XGPicturesBrowserCollectionViewCell
        cell.pictureModel = pictures[indexPath.item]
        return cell
    }
}

// MARK: - 设置界面

extension XGPicturesBrowserViewController
{
    // 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// 设置界面
    private func setUpUI() -> Void
    {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // 设置自动布局
        closeButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(12)
            make.bottom.equalTo(view).offset(-12)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(view).offset(-12)
            make.size.equalTo(closeButton)
        }
    }
    
    /// 设置collectionView
    private func setUpCollectionView() -> Void
    {
        collectionView.backgroundColor = UIColor.black
        
        // 设置cell布局
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = view.size
        
        // 设置collectionView属性
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        // 设置数据源和代理
        collectionView.dataSource = self
        
        // 注册cell
        collectionView.register(XGPicturesBrowserCollectionViewCell.self, forCellWithReuseIdentifier: kReuseIdentifier)
    }
}