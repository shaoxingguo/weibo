//
//  XGHomeTableViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import MJRefresh

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
        
        // tableView设置
        setUpTaleView()
        // 注册通知
        registerNotification()
        // 刷新数据
        tableView.mj_header.beginRefreshing()
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
    
    @objc private func tapHomeTabBarBadgeValueAction(notification:Notification) -> Void
    {
        DispatchQueue.main.async {
            // 滚动到顶部
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: true)
            
            // 加载最新数据
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.tableView.mj_header.beginRefreshing()
            }
        }
    }
    
    // MARK: - 内部其他私有方法
    private func registerNotification() -> Void
    {
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(accessTokenTimeOutAction(notification:)), name: NSNotification.Name(rawValue: kAccessTokenTimeOutNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tapHomeTabBarBadgeValueAction(notification:)), name: NSNotification.Name(rawValue: kTapHomeTabBarBadgeValueNotification), object: nil)
    }
}

// MARK: - tableView数据源和代理方法
extension XGHomeTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = dataArray?.count ?? 0
        tableView.mj_footer.isHidden = count == 0
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.purple
            cell?.selectionStyle = .none
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
        
        // 取消默认64偏移
        tableView.contentInsetAdjustmentBehavior = .never
        
        // 设置cell分割线
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // 设置下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        
        // 设置上拉刷新
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        
        // 设置内容边距
        tableView.contentInset = UIEdgeInsets(top: kNavigationBarHeight, left: 0, bottom: kTabBarHeight, right: 0)
    }
}

// MARK: - 获取微博数据
extension XGHomeTableViewController
{
    private func loadData(sinceId:Int64 = 0,maxId:Int64 = 0) -> Void
    {
        XGDataManager.loadStatusList(sinceId: sinceId, maxId: maxId) { (dataArray, error) in
            // 结束下拉刷新
            self.tableView.mj_header.isRefreshing ?
                self.tableView.mj_header.endRefreshing() : ()
            
            if error != nil {
                XGPrint("获取微博数据失败! \(error!.localizedDescription)")
                self.tableView.mj_footer.isRefreshing ? self.tableView.mj_footer.endRefreshing() : ()
                return
            } else {
                guard let dataArray = dataArray else {
                    self.tableView.mj_footer.isRefreshing ? self.tableView.mj_footer.endRefreshing() : ()
                    return
                }
                
                if dataArray.count == 0 {
                    self.tableView.mj_footer.isRefreshing ? self.tableView.mj_footer.endRefreshingWithNoMoreData() : ()
                    return
                } else if sinceId > 0 {
                    self.dataArray = dataArray + self.dataArray!
                } else if maxId > 0 {
                    self.dataArray = self.dataArray! + dataArray
                } else  {
                    self.dataArray = dataArray
                }
                
                self.tableView.mj_footer.isRefreshing ? self.tableView.mj_footer.endRefreshing() : ()
                self.tableView.reloadData()
            }
        }
    }
    
    /// 获取最新微博数据
    @objc private func loadNewData() -> Void
    {
        loadData(sinceId: dataArray?.first?.id ?? 0)
    }
    
    /// 获取更多微博数据
    @objc private func loadMoreData() -> Void
    {
        var maxId = dataArray?.last?.id ?? 0
        maxId = maxId > 0 ? maxId - 1 : maxId
        loadData(maxId: maxId)
    }
}
