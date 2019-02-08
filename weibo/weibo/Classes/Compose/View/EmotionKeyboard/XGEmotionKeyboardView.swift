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
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        XGPrint("我去了")
    }
    
    // MARK: - 监听方法
    
    /// 工具栏分组被选中事件
    @objc private func groupScrollViewItemSelectedAction(button:UIButton) -> Void
    {
        let item = button.tag > selectedGroupIndex ? 0 : XGEmotionsListViewModel.shared.emotionsGroupList[button.tag].numberOfPages - 1
       
        // 选则工具栏对应的分组
        let selectedButton = groupScrollView.subviews[selectedGroupIndex] as? UIButton
        selectedButton?.isSelected = false
        button.isSelected = true
        selectedGroupIndex = button.tag
        
        // 表情滚动到对应的组
        let indexPath = IndexPath(item: item, section: selectedGroupIndex)
        emotionCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.numberOfPages = XGEmotionsListViewModel.shared.emotionsGroupList[indexPath.section].numberOfPages
        pageControl.currentPage = indexPath.item
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
    private lazy var groupScrollView:UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.bounces = false
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
        return cell
    }
    
    // 停止减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let indexPath = emotionCollectionView.indexPathsForVisibleItems[0]
        
        // 选中新的分组
        if indexPath.section != selectedGroupIndex {
            let button = groupScrollView.subviews[indexPath.section] as! UIButton
            let maxOffset:CGFloat = groupScrollView.contentSize.width - groupScrollView.width
            let minOffset:CGFloat = 0
            var offset = CGFloat(button.tag - selectedGroupIndex) * button.width + groupScrollView.contentOffset.x
            offset = offset > maxOffset ? maxOffset : offset
            offset = offset < minOffset ? minOffset : offset
            groupScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
            groupScrollViewItemSelectedAction(button: button)
        } else {
            // 设置分页指示器
            pageControl.numberOfPages = XGEmotionsListViewModel.shared.emotionsGroupList[indexPath.section].numberOfPages
            pageControl.currentPage = indexPath.item
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

        // 工具栏内部子控件布局
        let itemWidth = groupScrollView.width / 4
        for (index,view) in groupScrollView.subviews.enumerated() {
            view.frame = CGRect(x: CGFloat(index) * itemWidth, y: 0, width: itemWidth, height: groupScrollView.height)
        }
        
        // 设置工具栏滚动范围
        groupScrollView.contentSize = CGSize(width: CGFloat(groupScrollView.subviews.count) * itemWidth, height: 0)
        
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
        setUpGroupScrollView()
        setUpEmotionCollectionView()
        
        pageControl.numberOfPages = XGEmotionsListViewModel.shared.emotionsGroupList[0].numberOfPages
    }
    
    /// 设置工具栏
    private func setUpGroupScrollView() -> Void
    {
        for (index,emotionsGroupModel) in XGEmotionsListViewModel.shared.emotionsGroupList.enumerated() {
            let button = UIButton(title: emotionsGroupModel.category, backgroundImageName: "common_button_white_disable", normalColor: UIColor.darkGray, highlightedColor: UIColor.darkGray, target: self, action: #selector(groupScrollViewItemSelectedAction(button:)))
            button.tag = index
            button.setTitleColor(UIColor.white, for: .selected)
            button.setBackgroundImage(UIImage.stretchableImage(imageName: "common_button_orange"), for: .selected)
            groupScrollView.addSubview(button)
            
            if index == 0 {
                button.isSelected = true
            }
        }
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
