//
//  XGMineTableViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGMineTableViewController: XGVisitorViewController
{
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !XGAccountViewModel.shared.isLogin {
            return
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: .plain, target: self, action: #selector(settingItemAction))
    }
    
    // MARK: - 监听方法
    
    @objc private func settingItemAction() -> Void
    {
        navigationController?.pushViewController(XGSettingTableViewController(), animated: true)
    }
}
