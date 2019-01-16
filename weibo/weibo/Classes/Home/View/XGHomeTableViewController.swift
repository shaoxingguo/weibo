//
//  XGHomeTableViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGHomeTableViewController: XGVisitorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // FIXME: 测试
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerAction))
    }
    
    @objc private func registerAction() -> Void
    {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.purple
        navigationController?.pushViewController(vc
            , animated: true)
    }

   
}
