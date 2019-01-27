//
//  XGNewFeatureViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/20.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGNewFeatureViewController: UIViewController
{

    // MARK: - 控制器生命周期方法
    
    override func loadView()
    {
        super.loadView()
        setUpUI()
    }
    
    deinit {
        XGPrint("我去了")
    }

    // MARK: - 事件监听
    
    @objc private func enterButtonClickAction() -> Void
    {
        // 发送通知 从新特性切换到主界面
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSwitchApplicationRootViewControllerNotification), object: kFromNewFeatureToToMain, userInfo: nil)
    }
    
    // MARK: - 懒加载
    
    private lazy var contentScrollView:UIScrollView = { [weak self] in
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    /// 登录按钮
    private lazy var enterButton:UIButton = {
        let button = UIButton(title: "立即进入", backgroundImageName: "new_feature_finish_button",normalColor: UIColor.white, highlightedColor: UIColor.orange, target: self, action: #selector(enterButtonClickAction))
        return button
    }()
    /// 分页指示器
    private lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = kMaxCount
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.isUserInteractionEnabled = false
        pageControl.sizeToFit()
        return pageControl
    }()
    /// 最大图片数量
    private let kMaxCount:Int = 4
}

// MARK: - UIScrollViewDelegate

extension XGNewFeatureViewController:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        enterButton.isHidden = true
        let page:Int = Int(scrollView.contentOffset.x / scrollView.width + 0.5)
        pageControl.currentPage = page
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        if index == kMaxCount - 1 {
            showLoginButton()
        }
    }
}

// MARK: - 设置界面

extension XGNewFeatureViewController
{
    // 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setUpUI() -> Void
    {
        // 添加子控件
        view.addSubview(contentScrollView)
        view.addSubview(enterButton)
        view.addSubview(pageControl)
        
        // 设置位置
        contentScrollView.frame = view.bounds
        
        enterButton.centerX = view.centerX
        enterButton.centerY = view.height * 0.7
        enterButton.isHidden = true
        
        pageControl.centerX = view.centerX
        pageControl.y = view.height - pageControl.height - 10
        
        // 添加新特性背景图片
        for i in 0..<kMaxCount {
            let imageName = "new_feature_" + String(i + 1)
            let imageView = UIImageView(image: UIImage(named: imageName))
            contentScrollView.addSubview(imageView)
            imageView.frame = CGRect(x: CGFloat(i) * contentScrollView.width, y: 0, width: contentScrollView.width, height: contentScrollView.height)
        }
        
        // 设置scrollView滚动范围
        contentScrollView.contentSize = CGSize(width:  CGFloat(kMaxCount) * contentScrollView.width, height: 0)
    }
    
    /// 展示登录按钮
    private func showLoginButton() -> Void
    {
        enterButton.isUserInteractionEnabled = false
        enterButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
            self.enterButton.isHidden = false
            self.enterButton.transform = CGAffineTransform.identity
        }) { (_) in
            self.enterButton.isUserInteractionEnabled = true
        }
    }
}

