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
    var isLogin:Bool = false
    var visitorInfo:[String:String]? {
        didSet {
            visitorView.visitorInfo = visitorInfo
        }
    }
    
    // MARK: - 控制器生命周期方法
    override func loadView()
    {
        isLogin ? super.loadView() : setUpUI()
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
    }
}
