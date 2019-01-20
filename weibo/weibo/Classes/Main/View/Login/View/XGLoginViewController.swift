//
//  XGLoginViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/19.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class XGLoginViewController: UIViewController
{
    // MARK: - 控制器生命周期方法
    override func loadView()
    {
        setUpUI()
        setUpNavigationItem()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 加载网页
        loadRequest()
    }
    
    deinit {
        XGPrint("我去了")
    }
    
    // MARK: - 事件监听
    @objc private func quitAction() -> Void
    {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFillAction() -> Void
    {
        let code = "document.getElementById('userId').value = '541145534@qq.com';document.getElementById('passwd').value = '2015xg000@';"
        webView.evaluateJavaScript(code, completionHandler: nil)
    }
    
    // MARK: - 懒加载
    private lazy var webView:WKWebView = { [weak self] in
        let webView = WKWebView(frame: CGRect.zero)
        webView.navigationDelegate = self
        return webView
    }()
}

// MARK: - 网络请求
extension XGLoginViewController
{
    private func loadRequest() -> Void
    {
        let urlString = kBaseURLString + kAuthorizeCodeAPI + "?client_id=\(kAppKey)&redirect_uri=\(kRedirectURLString)"
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}

// MARK: - WKNavigationDelegate
extension XGLoginViewController:WKNavigationDelegate
{
    // 拦截请求
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        /*
         成功 https://api.weibo.com/oauth2/default.html?code=135784de730f5970e68b12e5644276f9
         失败 https://api.weibo.com/oauth2/default.html?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330*/
        if webView.url?.absoluteString.hasPrefix(kRedirectURLString) == true {
            let query = webView.url?.query
            if query?.hasPrefix("code=") == true {
                // 同意授权 获取授权码
                let code = String(query?["code=".endIndex...] ?? "")
                // 根据授权码 加载用户授权令牌
                XGDataManager.loadAccessToken(code: code) { (accountModel, error) in
                    if error != nil {
                        XGPrint("加载accessToken失败 \(error!)")
                        return
                    } else {
                        XGPrint(accountModel ?? "")
                    }
                }
                
                quitAction()
            } else {
                // 拒绝授权
                quitAction()
            }
            // 授权页
            decisionHandler(.cancel)
        } else {
            // 非授权页
            decisionHandler(.allow)
        }
    }
    
    // 开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        SVProgressHUD.show()
    }
    
    // 结束加载
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        SVProgressHUD.dismiss()
    }
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