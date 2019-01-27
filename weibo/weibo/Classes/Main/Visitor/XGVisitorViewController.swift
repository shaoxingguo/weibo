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
    var visitorInfo:[String:String]? {
        didSet {
            visitorView.visitorInfo = visitorInfo
        }
    }
    
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
    
    // MARK: - 懒加载
    
    private lazy var visitorView:XGVisitorView = {
        let visitorView = XGVisitorView()
        visitorView.backgroundColor = UIColor(white: 0.93, alpha: 1)
        return visitorView
    }()
}

 // MARK: - 设置界面

extension XGVisitorViewController
{
    private func setUpUI() -> Void
    {
        view = visitorView
        
        // 设置导航栏
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(LoginAction))
        
        // 设置按钮监听事件
        visitorView.loginButton.addTarget(self, action: #selector(LoginAction), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
    }
}
