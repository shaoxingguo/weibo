//
//  XGAdvertisementViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/19.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

class XGAdvertisementViewController: UIViewController
{
    // MARK: - 控制器生命周期方法
    
    override func loadView()
    {
        super.loadView()
        
        setUpUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        // 展示广告
         startShow()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // 销毁定时器
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        XGPrint("我去了")
    }
    
    // MARK: - 事件监听
    /// 跟新跳过按钮文字
    @objc private func updateSkipButton() -> Void
    {
        if second == -1 {
            // 切换页面
            skipAction()
            return
        } else {
            skipButton.setTitle("跳过 \(second)", for: .normal)
            second -= 1
        }
    }
    
    // 跳过
    @objc private func skipAction() -> Void
    {
        // 发送通知 从广告页切换到主界面
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSwitchApplicationRootViewControllerNotification), object: kFromAdvertisementToMain, userInfo: nil)
    }
    
    // 点击广告
    @objc private func tapBackgroundImageViewAction(tap:UITapGestureRecognizer) -> Void
    {
        let viewController = SFSafariViewController(url: XGAdvertisementViewModel.sharedViewModel.webURL!)
        viewController.dismissButtonStyle = .close
        viewController.preferredControlTintColor = UIColor.orange
         present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    
    /// 背景图片
    private lazy var backgroundImageView:UIImageView = { [weak self] in
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundImageViewAction(tap:)))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    /// 跳过按钮
    private lazy var skipButton:UIButton = {
        let button = UIButton(title: "测试文本", normalColor: UIColor.white, highlightedColor: UIColor.white, target: self, action: #selector(skipAction))
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return button
    }()
    /// 定时器
    private var timer:Timer?
    /// 倒计时秒数
    private var second:Int = 5
}

// MARK: - 设置界面
extension XGAdvertisementViewController
{
    /// 展示广告
    private func startShow()
    {
        backgroundImageView.image = XGAdvertisementViewModel.sharedViewModel.advertisementImage
        updateSkipButton()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSkipButton), userInfo: nil, repeats: true)
    }
    
    // 隐藏状态栏
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    private func setUpUI() -> Void
    {
        view.backgroundColor = UIColor.white

        // 添加子控件
        view.addSubview(backgroundImageView)
        view.addSubview(skipButton)
        
        // 设置自动布局
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        skipButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.view).offset(30)
            make.size.equalTo(CGSize(width: 60, height: 36))
        }
    }
}

