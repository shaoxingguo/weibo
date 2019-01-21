//
//  XGHomeTableViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGHomeTableViewController: XGVisitorViewController
{
    var dataArray:[XGStatusModel]?
    
    // MARK: - 控制器生命周期方法
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // 用户没有登录 直接返回
        if !XGAccountViewModel.shared.isLogin {
            return
        }
        
        setUpTaleView()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(accessTokenTimeOutAction(notification:)), name: NSNotification.Name(rawValue: kAccessTokenTimeOutNotification), object: nil)
        
        tableView.refreshControl?.beginRefreshing()
        loadData()
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 事件监听
    @objc private func accessTokenTimeOutAction(notification:Notification) -> Void
    {
        let alert = UIAlertController(title: "用户授权超时", message: "请重新登录", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let nav = XGNavigationController(rootViewController: XGLoginViewController())
            self.present(nav, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

extension XGHomeTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  self.dataArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.purple
        }
        
        cell?.textLabel?.text = dataArray?[indexPath.row].text
        return cell!
    }
}

// MARK: - tableView设置
extension XGHomeTableViewController
{
    private func setUpTaleView() -> Void
    {
        tableView.rowHeight = 64
        
        // 设置cell分割线
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - 获取微博数据
extension XGHomeTableViewController
{
    @objc private func loadData() -> Void
    {
        XGDataManager.loadStatusList { (dataArray, error) in
            self.tableView.refreshControl?.endRefreshing()
            if error != nil {
                XGPrint("获取微博数据失败! \(error!)")
                return
            } else {
                self.dataArray = dataArray
                self.tableView.reloadData()
            }
        }
    }
}
