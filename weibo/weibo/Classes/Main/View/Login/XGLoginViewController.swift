//
//  XGLoginViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/19.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import WebKit

class XGLoginViewController: UIViewController
{

    // MARK: - 控制器生命周期方法
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpNavigationItem()
        setUpUI()
    }
    
    // MARK: - 事件监听
    @objc private func quitAction() -> Void
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFillAction() -> Void
    {
        XGPrint("自动填充")
    }
    
    // MARK: - 懒加载
    private lazy var webView:WKWebView = { [weak self] in
        let webView = WKWebView(frame: CGRect.zero)
        return webView
    }()
}

// MARK: - 网络请求
extension XGLoginViewController
{
    
}

// MARK: - 设置界面
extension XGLoginViewController
{
    private func setUpNavigationItem() -> Void
    {
        navigationItem.title = "登录"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(quitAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(autoFillAction))
    }
    
    private func setUpUI() -> Void
    {
        view = webView
    }
}
