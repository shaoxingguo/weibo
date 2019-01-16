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
        // 设置外观
        setUpAppearance()
        // 添加子控制器
        addAllChildViewControllers()
        // 添加发布按钮
        setUpPublishButton()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // 将发布按钮置前
        tabBar.bringSubviewToFront(publishButton)
    }
    
    // MARK: - 事件监听
    @objc private func publishAction() -> Void
    {
        XGPrint("发布微博")
    }
    
    // MARK: - 懒加载
    private lazy var publishButton:UIButton = { [weak self] in
        let button = UIButton(backgroundImageName: "tabbar_compose_button", imageName: "tabbar_compose_icon_add", target:self, action: #selector(publishAction))
        return button
    }()
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
        
        // 设置tabbar字体大小
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let tabBarItem = UITabBarItem.appearance(whenContainedInInstancesOf: [XGTabBarController.self])
        tabBarItem.setTitleTextAttributes(attributes, for: UIControl.State(rawValue: 0))
    }
    
    /// 添加所有子控制器
    private func addAllChildViewControllers() -> Void
    {
        addChildViewController(className: "XGHomeTableViewController", imageName: "tabbar_home", title: "首页")
        addChildViewController(className: "XGMessageTableViewController", imageName: "tabbar_message_center", title: "信息")
        addChild(UIViewController())
        addChildViewController(className: "XGDiscoverTableViewController", imageName: "tabbar_discover", title: "发现")
        addChildViewController(className: "XGMineTableViewController", imageName: "tabbar_profile", title: "我的")
    }
    
    /// 添加子控制器
    ///
    /// - Parameters:
    ///   - className: 类名
    ///   - imageName: 图片名称
    ///   - title: 标题
    private func addChildViewController(className:String,imageName:String, title:String) -> Void
    {
        guard  let appName = (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String) else {
            return
        }
        
        let className = appName + "." + className
        let classType = NSClassFromString(className) as? UIViewController.Type
        guard let viewControler = classType?.init() else {
            return
        }
        
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
        var width = tabBar.width / CGFloat(viewControllers?.count ?? 1)
        width -= 1
        publishButton.frame = tabBar.bounds.insetBy(dx: 2.0 * width, dy: 0)
        tabBar.addSubview(publishButton)
    }
}