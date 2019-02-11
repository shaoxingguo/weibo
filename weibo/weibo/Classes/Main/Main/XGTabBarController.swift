//
//  XGTabBarController.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGTabBarController: UITabBarController
{
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        // 添加子控制器
        addAllChildViewControllers()
        // 添加发布按钮
        setUpPublishButton()
        // 设置外观
        setUpAppearance()
        // 设置定时器
        if XGAccountViewModel.shared.isLogin {
            timer = Timer.scheduledTimer(timeInterval:5 * 60, target: self, selector: #selector(updateUnreadCountAction), userInfo: nil, repeats: true)
        }
        
        // 设置代理
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // 将发布按钮置前
        tabBar.bringSubviewToFront(publishButton)
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
    
    // 撰写按钮点击事件
    @objc private func publishAction() -> Void
    {
        if !XGAccountViewModel.shared.isLogin {
            return
        }
        
        let composeTypeView = XGComposeTypeView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        view.addSubview(composeTypeView)
        composeTypeView.selectedItemComletion = {[weak self,weak composeTypeView] className -> Void in
            guard let className = className,
                  let nameSpace = Bundle.main.nameSpace,
                  let classType = NSClassFromString(nameSpace + className) as? UIViewController.Type else {
                    composeTypeView?.removeFromSuperview()
                    return
            }
            
            // 控制器跳转
            let viewController = classType.init()
            let nav = XGNavigationController(rootViewController: viewController)
            self?.present(nav, animated: true, completion: {
                composeTypeView?.removeFromSuperview()
            })
        }
    }
    
    // 更新未读数事件
    @objc private func updateUnreadCountAction() -> Void
    {
        XGStatusDAL.loadUnreadCount { (count, error) in
            self.tabBar.items?.first?.badgeValue = count > 0 ? "\(count)" : nil
        }
    }
    
    // MARK: - 懒加载
    
    /// 撰写按钮
    private lazy var publishButton:UIButton = { [weak self] in
        let button = UIButton(backgroundImageName: "tabbar_compose_button", imageName: "tabbar_compose_icon_add", target:self, action: #selector(publishAction))
        return button
    }()
    /// 定时器
    private var timer:Timer?
}

// MARK: - UITabBarControllerDelegate

extension XGTabBarController:UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
    {
        if viewControllers == nil || viewController.isMember(of: UIViewController.self) {
            return false
        } else {
            let nextIndex = (viewControllers! as NSArray).index(of: viewController)
            if tabBarController.selectedIndex == nextIndex && nextIndex == 0 {
                // 清除角标
                self.tabBar.items?.first?.badgeValue = nil
                // 点击首页tabBar 发送通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kTapHomeTabBarBadgeValueNotification), object: nil, userInfo: nil)
            }
            return true
        }
    }
}

// MARK: - 设置界面

extension XGTabBarController
{
    /// 设置外观
    private func setUpAppearance() -> Void
    {
        // 设置tabbar渲染颜色
        let tabBar = UITabBar.appearance(whenContainedInInstancesOf: [XGTabBarController.self])
        tabBar.tintColor = UIColor.orange
        
        // 设置tabbarItem字体大小
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let tabBarItem = UITabBarItem.appearance(whenContainedInInstancesOf: [XGTabBarController.self])
        tabBarItem.setTitleTextAttributes(attributes, for: UIControl.State(rawValue: 0))
        
        // 设置navigationBar渲染颜色
        let navigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [XGNavigationController.self])
        navigationBar.tintColor = UIColor.darkGray
        
        // 设置navigationBar标题字体大小
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor:UIColor.orange]
        
        // 设置穿透效果
        navigationBar.isTranslucent = true
        tabBar.isTranslucent = true
    }
    
    /// 添加所有子控制器
    private func addAllChildViewControllers() -> Void
    {
        addChildViewController(className: "XGHomeTableViewController", imageName: "tabbar_home", title: "首页",visitorInfo: ["imageName": "","title": "关注一些人,回这里看看有什么惊喜"])
        addChildViewController(className: "XGMessageTableViewController", imageName: "tabbar_message_center", title: "信息",visitorInfo: ["imageName": "visitordiscover_image_message","title": "登录后,别人评论你的微薄,发给你的消息,都会在这里收到通知"])
        addChild(UIViewController())
        addChildViewController(className: "XGDiscoverTableViewController", imageName: "tabbar_discover", title: "发现",visitorInfo: ["imageName": "visitordiscover_image_message","title": "登录后,最新、最热微博尽在掌握,不会再与时事潮流擦肩而过"])
        addChildViewController(className: "XGMineTableViewController", imageName: "tabbar_profile", title: "我的",visitorInfo: ["imageName": "visitordiscover_image_profile","title": "登录后,你的微博、相册、个人资料会显示在这里,展示给别人"])
    }
    
    /// 添加子控制器
    ///
    /// - Parameters:
    ///   - className: 类名
    ///   - imageName: 图片名称
    ///   - title: 标题
    ///   - visitorInfo: 访客视图信息
    private func addChildViewController(className:String,imageName:String, title:String,visitorInfo:[String:String]) -> Void
    {
        guard let nameSpace = Bundle.main.nameSpace,
              let classType = NSClassFromString(nameSpace + className) as? XGVisitorViewController.Type else {
            return
        }
        
        let viewControler = classType.init()
        viewControler.visitorInfo = visitorInfo
        let nav = XGNavigationController(rootViewController: viewControler)
        viewControler.navigationItem.title = title
        viewControler.tabBarItem.title = title
        viewControler.tabBarItem.image = UIImage(named: imageName)
        viewControler.tabBarItem.selectedImage  = UIImage(named: (imageName + "_highlighted"))?.withRenderingMode(.alwaysOriginal)
        addChild(nav)
    }
    
    /// 设置发布按钮
    private func setUpPublishButton() -> Void
    {
        // 宽度减1 这样缩进时发布按钮就会大一点 防止容错点 点击后进入中间的占位控制器
        let width = tabBar.width / CGFloat(viewControllers?.count ?? 1)
        publishButton.frame = tabBar.bounds.insetBy(dx: 2.0 * width, dy: 0)
        tabBar.addSubview(publishButton)
    }
}
