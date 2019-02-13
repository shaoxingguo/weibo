//
//  XGEmotionKeyboardView.swift
//  weibo
//
//  Created by monkey on 2019/2/4.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

/// cell重用标识符
private let kEmotionCollectionViewCellReuseIdentifier = "XGEmotionCollectionViewCell"

class XGEmotionKeyboardView: UIView
{

    // MARK: - 构造方法
    
    /// 选中表情回调
    private var selectedEmotionCallBack:(XGEmotionModel?) -> Void
    
    init(callBack:@escaping (XGEmotionModel?) -> Void)
    {
        // 设置选中表情回调
        selectedEmotionCallBack = callBack

        super.init(frame: CGRect.zero)
        
        // 设置界面
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        XGPrint("我去了")
    }
    
    // MARK: - 懒加载
    
    /// collectionView
    private lazy var emotionCollectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return collectionView
    }()
    /// 分页指示器
    private lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect.zero)
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    /// 工具栏
    private lazy var groupScrollView:XGEmotionViewToolBar = { [weak self] in
        let view = XGEmotionViewToolBar()
        view.backgroundColor = UIColor.white
        view.toolBardelegate = self
        return view
    }()
    
    /// 选中的分组索引
    private var selectedGroupIndex:Int = 0
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension XGEmotionKeyboardView:UICollectionViewDataSource,UICollectionViewDelegate
{
    // 多少组
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return XGEmotionsListViewModel.shared.emotionsGroupList.count
    }
    
    // 每组多少行
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let emotionGroupModel =  XGEmotionsListViewModel.shared.emotionsGroupList[section]
        return emotionGroupModel.numberOfPages
    }
    
    // 每行的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmotionCollectionViewCellReuseIdentifier, for: indexPath) as!XGEmotionCollectionViewCell
        let emotionGroupModel =  XGEmotionsListViewModel.shared.emotionsGroupList[indexPath.section]
        cell.emotions = emotionGroupModel.emotionsForPage(page: indexPath.item)
        cell.delegate = self
        return cell
    }
    
    // 正在滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        // 获取下一个cell 离中心分界点进的那一个cell
        let center = scrollView.centerX + scrollView.contentOffset.x
        let visibleCells = emotionCollectionView.visibleCells
        var nextIndexPath:IndexPath?
        for cell in visibleCells {
            if cell.frame.contains(CGPoint(x: center, y: 0)) {
                nextIndexPath = emotionCollectionView.indexPath(for: cell)
                break
            }
        }
        
        if let nextIndexPath = nextIndexPath {
            // 设置分页指示器
            pageControl.numberOfPages = XGEmotionsListViewModel.shared.emotionsGroupList[nextIndexPath.section].numberOfPages
            pageControl.currentPage = nextIndexPath.item
            
            // 设置表情分组
            if selectedGroupIndex != nextIndexPath.section {
                selectedGroupIndex = nextIndexPath.section
                groupScrollView.selectedIndex = nextIndexPath.section
            }
        }
    }
}

// MARK: - XGEmotionCollectionViewCellDelegate

extension XGEmotionKeyboardView:XGEmotionCollectionViewCellDelegate
{
    func emotionCollectionViewCellEmotionDidSelected(emotionModel: XGEmotionModel?)
    {
        // 传递回调 将选中的表情 显示在textView中
        selectedEmotionCallBack(emotionModel)
        
        // 添加最近表情 当前分组要不是0
        if selectedGroupIndex != 0 && emotionModel != nil {
            XGEmotionsListViewModel.shared.addRecentEmotion(emotionModel: emotionModel!)
            // 刷新第0组 即最近分组
            let indexSet = IndexSet(integersIn: 0..<1)
            emotionCollectionView.reloadSections(indexSet)
        }
    }
}

// MARK: - XGEmotionViewToolBarDelegate

extension XGEmotionKeyboardView:XGEmotionViewToolBarDelegate
{
    func emotionViewToolBarDidSelectedGroupIndex(index: Int)
    {
        if selectedGroupIndex != index {
            let indexPath = IndexPath(item: 0, section: index)
            // scrollToItem会调用scrollViewDidScroll方法
            emotionCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
        }
    }
}

// MARK: - 设置界面

extension XGEmotionKeyboardView
{
    /// 布局子控件
    override func layoutSubviews()
    {
        super.layoutSubviews()

        // 设置cell大小
        let flowLayout = emotionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = emotionCollectionView.size
        
    }
    
    /// 设置界面
    private func setUpUI() -> Void
    {
        // 添加子控件
        addSubview(emotionCollectionView)
        addSubview(pageControl)
        addSubview(groupScrollView)
        
        // 设置自动布局
        emotionCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(pageControl.snp.top)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(groupScrollView.snp.top)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 100, height: 37))
        }
        
        groupScrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(kToolBarHeight)
        }
        
        // 设置其他子控件
        setUpEmotionCollectionView()
        
        pageControl.numberOfPages = XGEmotionsListViewModel.shared.emotionsGroupList[0].numberOfPages
    }
    
    /// 设置表情视图
    private func setUpEmotionCollectionView() -> Void
    {
        let flowLayout = emotionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        emotionCollectionView.isPagingEnabled = true
        emotionCollectionView.bounces = false
        emotionCollectionView.showsHorizontalScrollIndicator = false
        
        emotionCollectionView.register(XGEmotionCollectionViewCell.self, forCellWithReuseIdentifier: kEmotionCollectionViewCellReuseIdentifier)
        
        emotionCollectionView.dataSource = self
        emotionCollectionView.delegate = self
    }
}
