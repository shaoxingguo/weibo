//
//  XGVisitorViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/16.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SnapKit

class XGVisitorViewController: UITableViewController
{
    /// 访客视图配置信息
    var visitorInfo:[String:String]?
    
    // MARK: - 控制器生命周期方法
    
    override func loadView()
    {
        XGAccountViewModel.shared.isLogin ? super.loadView() : setUpUI()
    }
    
    // MARK: - 事件监听
    
    @objc private func LoginAction() -> Void
    {
        let viewController = XGLoginViewController()
        let nav = XGNavigationController(rootViewController: viewController)
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func registerAction() -> Void
    {
        XGPrint("注册")
    }
    
    // MARK: - 私有属性
    
    private var visitorView:XGVisitorView?
}

 // MARK: - 设置界面

extension XGVisitorViewController
{
    private func setUpUI() -> Void
    {
        visitorView = XGVisitorView()
        visitorView?.visitorInfo = visitorInfo
        visitorView?.backgroundColor = UIColor(white: 0.93, alpha: 1)
        view = visitorView
        
        // 设置导航栏
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(LoginAction))
        
        // 设置按钮监听事件
        visitorView?.loginButton.addTarget(self, action: #selector(LoginAction), for: .touchUpInside)
        visitorView?.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
    }
}
