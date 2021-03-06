//
//  XGSettingTableViewController.swift
//  weibo
//
//  Created by monkey on 2019/2/9.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SVProgressHUD

class XGSettingTableViewController: UITableViewController
{
    /// 表格数据
    private var dataArray = [[["title":"清除缓存",
                               "actionName":"clearCache"]],
                             [["title":"退出登录",
                               "actionName":"quitLogin"]]]
    
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "设置"
    }
    
    init()
    {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 其他方法

extension XGSettingTableViewController
{
    /// 清除缓存
    @objc private func clearCache() -> Void
    {
        // 清空cachePath目录
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        FileManager.default.removeFilePath(filePath: cachePath) { (error) in
            if error == nil {
                SVProgressHUD.showSuccess(withStatus: "清除成功")
            }
        }
    }
    
    /// 退出登录
    @objc private func quitLogin() -> Void
    {
        // 弹框 是否确定退出登录
        let alert = UIAlertController(title: "提示", message: "是否要退出登录", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (_) in
            // 清除用户数据
            XGAccountViewModel.shared.removeAccountInfos()
            // 发布通知 切换根控制器
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSwitchApplicationRootViewControllerNotification), object: kFromMainToLogin, userInfo: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension XGSettingTableViewController
{
    // 多少组
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return dataArray.count
    }

    // 多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray[section].count
    }

    // 每行的内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if  cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }

        cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row]["title"]
        return cell!
    }
    
    // 选中某一行
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // 如果当前行 有监听方法 执行监听方法
        if let actionName = dataArray[indexPath.section][indexPath.row]["actionName"] {
            let action = Selector(actionName)
            perform(action)
        }
    }
}

