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
        setUpUI()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    // MARK: - 懒加载
    private lazy var contentScrollView:UIScrollView = { [weak self] in
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    /// 登录按钮
    private lazy var loginButton:UIButton = {
        let button = UIButton(title: "立即登录", backgroundImageName: "new_feature_finish_button",normalColor: UIColor.white, highlightedColor: UIColor.orange, target: nil, action: nil)
        button.isHidden = true
        return button
    }()
    /// 最大图片数量
    private let kMaxCount:Int = 4
}

// MARK: - UIScrollViewDelegate
extension XGNewFeatureViewController:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        XGPrint(scrollView.contentOffset.x)
        loginButton.isHidden = true
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
    private func setUpUI() -> Void
    {
        view = contentScrollView
        
        // 添加背景图片
        for i in 0..<kMaxCount {
            let imageName = "new_feature_" + String(i + 1)
            let imageView = UIImageView(image: UIImage(named: imageName))
            contentScrollView.addSubview(imageView)
            imageView.frame = CGRect(x: CGFloat(i) * contentScrollView.width, y: 0, width: contentScrollView.width, height: contentScrollView.height)
            if i == kMaxCount - 1 {
                contentScrollView.addSubview(loginButton)
                loginButton.centerX = imageView.centerX
                loginButton.y = contentScrollView.height * 0.7
            }
        }
        
        // 设置scrollView滚动范围
        contentScrollView.contentSize = CGSize(width:  CGFloat(kMaxCount) * contentScrollView.width, height: 0)
    }
    
    /// 展示登录按钮
    private func showLoginButton() -> Void
    {
        loginButton.isUserInteractionEnabled = false
        loginButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
            self.loginButton.isHidden = false
            self.loginButton.transform = CGAffineTransform.identity
        }) { (_) in
            self.loginButton.isUserInteractionEnabled = true
        }
    }
}

