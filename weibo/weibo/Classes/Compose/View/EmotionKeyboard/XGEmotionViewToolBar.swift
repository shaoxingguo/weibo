//
//  XGEmotionToolBar.swift
//  weibo
//
//  Created by monkey on 2019/2/13.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGEmotionViewToolBar: UIScrollView
{
    /// 选中的分组索引
    open var selectedIndex:Int = 0 {
        didSet {
            for view in subviews {
                let button = view as! UIButton
                button.isSelected = false
            }
            
            (subviews[selectedIndex] as! UIButton).isSelected = true
            
            let maxOffset:CGFloat = contentSize.width - width
            var offset = CGFloat(selectedIndex / 4) * width
            offset = offset > maxOffset ? maxOffset : offset
            setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    weak var toolBardelegate:XGEmotionViewToolBarDelegate?
    
    // MARK: - 构造方法
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        setUpUI()
        
        // 初始化设置
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        bounces = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 监听方法
    
    /// 分组按钮点击事件监听
    @objc private func groupScrollViewItemSelectedAction(button:UIButton) -> Void
    {
        toolBardelegate?.emotionViewToolBarDidSelectedGroupIndex?(index: button.tag)
    }
}

// MARK: - 设置界面

extension XGEmotionViewToolBar
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        // 工具栏内部子控件布局
        let itemWidth = width / 4
        for (index,view) in subviews.enumerated() {
            view.frame = CGRect(x: CGFloat(index) * itemWidth, y: 0, width: itemWidth, height: height)
        }
        
        // 设置工具栏滚动范围
        contentSize = CGSize(width: CGFloat(subviews.count) * itemWidth, height: 0)
    }
    
    private func setUpUI() -> Void
    {
        for (index,emotionsGroupModel) in XGEmotionsListViewModel.shared.emotionsGroupList.enumerated() {
            let button = UIButton(title: emotionsGroupModel.category, backgroundImageName: "common_button_white_disable", normalColor: UIColor.darkGray, highlightedColor: UIColor.darkGray, target: self, action: #selector(groupScrollViewItemSelectedAction(button:)))
            button.tag = index
            button.setTitleColor(UIColor.white, for: .selected)
            button.setBackgroundImage(UIImage.stretchableImage(imageName: "common_button_orange"), for: .selected)
            addSubview(button)
            
            if index == 0 {
                button.isSelected = true
            }
        }
    }
}

@objc public protocol XGEmotionViewToolBarDelegate
{
    @objc optional func emotionViewToolBarDidSelectedGroupIndex(index:Int) -> Void
}
