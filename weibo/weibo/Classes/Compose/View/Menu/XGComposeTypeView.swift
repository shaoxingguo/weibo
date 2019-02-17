//
//  XGComposeTypeView.swift
//  weibo
//
//  Created by monkey on 2019/1/31.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SnapKit
import pop

class XGComposeTypeView: UIView
{
    // MARK: - 构造方法
    /// 选择某个按钮的完成回调
    open var selectedItemComletion:((String?) -> Void)?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setUpUI()
        setUpScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        XGPrint("我去了")
    }
    
    override func didMoveToSuperview()
    {
        if superview != nil {
            show()
        }
    }
    
    // MARK: - 事件监听
    
    /// 更多按钮点击事件
    @objc private func clickMoreAction() -> Void
    {
        scrollView.setContentOffset(CGPoint(x: scrollView.width, y: 0), animated: true)
        toolBar.showAllItems()
    }
    
    // 其他撰写类型按钮点击事件
    @objc private func clickComposeTypeAction(selectedButton:XGComposeTypeButton) -> Void
    {
        let page:Int = Int(scrollView.contentOffset.x / scrollView.width)    // 页码
        let contentView = scrollView.subviews[page] // 内容视图
        for (index,button) in contentView.subviews.enumerated() {
            // 缩放动画
            let scaleAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale:CGFloat = (button == selectedButton) ? 2 : 0.2
            scaleAnimation.toValue = CGPoint(x: scale, y: scale)
            scaleAnimation.duration = 0.5
            button.pop_add(scaleAnimation, forKey: nil)
            
            // 透明度渐变动画
            let alphaAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnimation.toValue = 0.2
            alphaAnimation.duration = 0.5
            button.pop_add(alphaAnimation, forKey: nil)
            
            if index == 0 {
                alphaAnimation.completionBlock = { _,_ -> Void in
                    self.selectedItemComletion?(self.buttonsInfo[selectedButton.tag]["viewController"])
                }
            }
        }
    }
    
    // MARK: - 懒加载
    
    /// 毛玻璃视图
    private lazy var visualEffectView:UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        return UIVisualEffectView(effect: effect)
    }()
    /// logo图片
    private lazy var logoImageView:UIImageView = UIImageView(image: UIImage(named: "compose_slogan"))
    /// scrollView
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    /// 底部工具栏
    private lazy var toolBar:XGComposeTypeViewToolBar = { [weak self] in
        let toolBar = XGComposeTypeViewToolBar()
        toolBar.delegate = self
        toolBar.backgroundColor = UIColor.white
        return toolBar
    }()
    /// 按钮数据数组
    private let buttonsInfo:[[String:String]] = [["imageName": "tabbar_compose_idea", "title": "文字", "viewController": "XGComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMoreAction"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]
}

// MARK: - XGComposeTypeViewToolBarDelegate

extension XGComposeTypeView : XGComposeTypeViewToolBarDelegate
{
    func composeTypeViewToolBarCloseButtonDidClick() -> Void
    {
        dismissComposeTypeButtons()
    }
    
    func composeTypeViewToolBarGoBackButtonDidClick() -> Void
    {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
}
// MARK: - 动画相关

extension XGComposeTypeView
{
    /// 展示
    private func show() -> Void
    {
        alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
        })
        
        self.showComposeTypeButtons()
    }
    
    /// 选项按钮展示动画
    private func showComposeTypeButtons() -> Void
    {
        for (index,button) in (scrollView.subviews[0].subviews).enumerated() {
            // 按钮升序上升
            let animation:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation.fromValue = button.centerY + 400
            animation.toValue = button.centerY
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * 0.025
            animation.springSpeed = 8
            animation.springBounciness = 8
            button.layer.pop_add(animation, forKey: nil)
        }
    }
    
    /// 取消选项按钮动画
    private func dismissComposeTypeButtons() -> Void
    {
        let page:Int = Int(scrollView.contentOffset.x / scrollView.width)    // 页码
        let contentView = scrollView.subviews[page] // 内容视图
        for (index,button) in (contentView.subviews.enumerated()) {
            // 按钮倒序下落
            let animation:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation.fromValue = button.centerY
            animation.toValue = button.centerY + 400
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval((contentView.subviews.count - 1 - index)) * 0.025
            animation.springSpeed = 8
            animation.springBounciness = 8
            button.layer.pop_add(animation, forKey: nil)
            
            // 最后一个按钮动画结束 删除视图
            if index == contentView.subviews.count - 1 {
                animation.completionBlock = { _,_ -> Void in
                    self.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - 设置界面

extension XGComposeTypeView
{
    private func setUpUI() -> Void
    {
        backgroundColor = UIColor.clear
        
        // 添加子控件
        addSubview(visualEffectView)
        addSubview(logoImageView)
        addSubview(scrollView)
        addSubview(toolBar)
        
        // 设置自动布局
        visualEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(100)
            make.centerX.equalTo(self)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(toolBar.snp.top)
            make.height.equalTo(224)
        }
        
        toolBar.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(kToolBarHeight)
        }
    }
    
    private func setUpScrollView() -> Void
    {
        // 设置scrollView 添加按钮
        layoutIfNeeded()
        addTypeButtons()
    }
    
    /// 添加选项按钮
    private func addTypeButtons() -> Void
    {
        let count:Int = 6 // 每一页6个按钮
        let page:Int = ((buttonsInfo.count - 1) / count) + 1 //  页数
        let buttonWidth:CGFloat = 100   // 每一个按钮大小
        let columns:Int = 3     // 每一页列数
        let hMargin:CGFloat = (scrollView.width - CGFloat(columns) * buttonWidth) / CGFloat(columns + 1)     // 水平间距
        for i in 0..<page {
            // 1.添加内容视图
            let contentView = UIView(frame: CGRect(origin: CGPoint(x: CGFloat(i) * scrollView.width, y: 0), size: scrollView.size))
            contentView.backgroundColor = scrollView.backgroundColor
            scrollView.addSubview(contentView)
            
            // 2.向内容视图添加选项按钮
            for j in 0..<count {
                let index = i * count + j
                if index >= buttonsInfo.count {
                    break
                }
                
                // 创建按钮
                let button = XGComposeTypeButton(title: buttonsInfo[index]["title"], imageName: buttonsInfo[index]["imageName"])
                button.tag = index
                button.backgroundColor = contentView.backgroundColor
                if let actionName = buttonsInfo[index]["actionName"] {
                    button.addTarget(self, action: NSSelectorFromString(actionName), for: .touchUpInside)
                } else {
                    button.addTarget(self, action: #selector(clickComposeTypeAction(selectedButton:)), for: .touchUpInside)
                }
                
                // 按钮九宫格布局
                let row = j / columns
                let column = j % columns
                let y = row == 0 ? 0 : (scrollView.height - buttonWidth)
                button.frame = CGRect(x: hMargin + (buttonWidth + hMargin) * CGFloat(column), y: y, width: buttonWidth, height: buttonWidth)
                contentView.addSubview(button)
            }
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(page) * scrollView.width, height: 0)
    }
}
