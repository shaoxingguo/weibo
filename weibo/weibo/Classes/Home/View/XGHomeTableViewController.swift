//
//  XGHomeTableViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage
import SafariServices

/// 原创微博cell重用标识符
private let kNormalStatusTableViewCellReuseIdentifier = "XGNormalStatusTableViewCell"
/// 转发微博cell重用标识符
private let kRetweetStatusTableViewCellReuseIdentifier = "XGRetweetStatusTableViewCell"

class XGHomeTableViewController: XGVisitorViewController
{
    /// 数据列表视图模型
    private lazy var statusListViewModel:XGStatusListViewModel = XGStatusListViewModel()
    
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // 用户没有登录 直接返回
        if !XGAccountViewModel.shared.isLogin {
            return
        }

        // 监听网络状态
        NotificationCenter.default.addObserver(self, selector: #selector(networkingReachabilityDidChange(notification:)), name: Notification.Name.AFNetworkingReachabilityDidChange, object: nil);
        // 导航栏设置
        setUpNavigationItem()
        // tableView设置
        setUpTaleView()
        // 刷新数量label设置
        setUpRefreshCountLabel()
        // 注册通知
        registerNotification()
        // 加载表情信息
        loadEmotionsData()
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDWebImageManager.shared().imageCache?.clearMemory()
    }
    
    // MARK: - 事件监听
    
    /// 网络状态改变通知监听
    @objc private func networkingReachabilityDidChange(notification:Notification) -> Void
    {
        // 刷新第0组
        tableView.reloadSections(IndexSet(integer: 0), with: .top)
    }
    
    /// access_token过期通知监听
    @objc private func accessTokenTimeOutAction(notification:Notification) -> Void
    {
        let alert = UIAlertController(title: "用户授权超时", message: "请重新登录", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let nav = XGNavigationController(rootViewController: XGLoginViewController())
            self.present(nav, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    /// 点击首页tabBar通知监听
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
    
    /// 点击首页导航栏按钮事件
    @objc private func titleButtonClickAction(button:UIButton) -> Void
    {
        button.isSelected = !button.isSelected
    }
    
    // 点击cell图片通知监听
    @objc private func showPicturesBrowserAction(notification:Notification) -> Void
    {
        guard let selectedIndex = notification.userInfo?[kPicturesBrowserSelectedIndexKey] as? Int,
              let pictures = notification.userInfo?[kPicturesBrowserPicturesKey] as? [XGPictureModel],
              let statusPicturesView = notification.object as? XGStatusPicturesView else {
            return
        }
        
        let viewController = XGPicturesBrowserViewController(selectedIndex: selectedIndex, pictures: pictures)
        // 自定义modal动画
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = pictureBrowserTransitioningAnimator
        viewController.modalPresentationCapturesStatusBarAppearance = true
        pictureBrowserTransitioningAnimator.selecedIndex = selectedIndex
        pictureBrowserTransitioningAnimator.setDelegate(presentedDelegate: statusPicturesView, dismissDelegate: viewController, selectedIndex: selectedIndex)
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    
    private lazy var refreshCountLabel:UILabel = {
        let label = UILabel(text: "刷新到10条新微博", fontSize: 15, textColor: UIColor.white, textAlignment: .center)
        label.backgroundColor = UIColor.orange
        return label
    }()

    private lazy var pictureBrowserTransitioningAnimator:XGPictureBrowserTransitioningAnimator = XGPictureBrowserTransitioningAnimator()
}

// MARK: - tableView数据源和代理方法

extension XGHomeTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return (XGNetworkManager.sharedManager.reachabilityManager.isReachable ? 0 : 1)
        } else {
            let count = statusListViewModel.statusList.count
            tableView.mj_footer.isHidden = count == 0
            return count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(XGNetworkTipTableViewCell.self)")
            return cell!
        } else {
            let viewModel = statusListViewModel.statusList[indexPath.row]
            let reuseIdentifier = viewModel.isRetweetedStatus ? kRetweetStatusTableViewCellReuseIdentifier : kNormalStatusTableViewCellReuseIdentifier
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? XGStatusTableViewCell
            cell?.statusViewModel = viewModel
            cell?.delegate = self
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 44
        } else {
            return statusListViewModel.statusList[indexPath.row].rowHeight
        }
    }
}

// MARK: - XGStatusTableViewCellDelegate

extension XGHomeTableViewController:XGStatusTableViewCellDelegate
{
    func statusTableViewCellDidSelectedURLString(URLString: String)
    {
        if URLString.hasPrefix("http://") || URLString.hasPrefix("https://") {
            if let url = URL(string: URLString) {
                let viewController = SFSafariViewController(url: url)
                present(viewController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - 获取微博数据

extension XGHomeTableViewController
{
    /// 获取表情信息
    private func loadEmotionsData() -> Void
    {
        DispatchQueue.main.async {
            XGEmotionsListViewModel.shared.loadEmotionsList { (isSuccess) in
                if !isSuccess {
                    XGPrint("加载表情信息失败!")
                    return
                }
                
                // 加载微博数据
                self.tableView.mj_header.beginRefreshing()
            }
        }
    }
    
    /// 获取最新微博数据
    @objc private func loadNewData() -> Void
    {
        statusListViewModel.loadNewStatusList { (isSuccess, count) in
            // 结束下拉刷新
            self.tableView.mj_header.isRefreshing ? self.tableView.mj_header.endRefreshing() : ()
            
            if !isSuccess {
                XGPrint("加载最新微博数据失败")
                return
            }
            
            // 刷新表格
            count > 0 ? self.tableView.reloadData() : ()
            // 展示刷新数量
            self.showRefreshCountLabel(count: count)
        }
    }
    
    /// 获取更多微博数据
    @objc private func loadMoreData() -> Void
    {
        statusListViewModel.loadMoreStatuslist { (isSuccess, count) in
            if !isSuccess {
                XGPrint("加载更多微博数据失败")
                self.tableView.mj_footer.isRefreshing ? self.tableView.mj_footer.endRefreshing() : ()
                return
            }
            
            if count == 0 {
                self.tableView.mj_footer.isRefreshing ? self.tableView.mj_footer.endRefreshingWithNoMoreData() : ()
                return
            } else {
                // 结束刷新
                self.tableView.mj_footer.isRefreshing ? self.tableView.mj_footer.endRefreshing() : ()
                // 刷新表格
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - 内部其他私有方法

extension XGHomeTableViewController
{
    /// 设置导航栏
    private func setUpNavigationItem() -> Void
    {
        //设置标题按钮
        let title = (XGAccountViewModel.shared.screenName ?? "") + "  "
        let titleButton = UIButton(title: title, normalColor: UIColor.darkGray, highlightedColor: UIColor.darkGray, fontSize: 17, target: self, action: #selector(titleButtonClickAction(button:)))
        titleButton.setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        titleButton.setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        titleButton.layoutButtonWithEdgeInsetsStyle(style: .right, space: 0)
        navigationItem.titleView = titleButton
    }
    
    /// 设置tableView
    private func setUpTaleView() -> Void
    {
        // 注册cell
        tableView.register(XGNormalStatusTableViewCell.self, forCellReuseIdentifier: kNormalStatusTableViewCellReuseIdentifier)
        tableView.register(XGRetweetStatusTableViewCell.self, forCellReuseIdentifier: kRetweetStatusTableViewCellReuseIdentifier)
        tableView.register(XGNetworkTipTableViewCell.self, forCellReuseIdentifier: "\(XGNetworkTipTableViewCell.self)")
        
        // 设置行高
        tableView.estimatedRowHeight = 200
        
        // 取消默认64偏移
        tableView.contentInsetAdjustmentBehavior = .never
        
        // 取消默认分割线
        tableView.separatorStyle = .none
        
        // 设置下拉刷新
        tableView.mj_header = XGRefreshHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        
        // 设置上拉刷新
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        
        // 设置内容边距
        tableView.contentInset = UIEdgeInsets(top: kNavigationBarHeight, left: 0, bottom: kTabBarHeight + kBottmMargin, right: 0)
        
        // 设置滚动指示器
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    /// 注册通知
    private func registerNotification() -> Void
    {
        // 监听授权过期通知
        NotificationCenter.default.addObserver(self, selector: #selector(accessTokenTimeOutAction(notification:)), name: NSNotification.Name(rawValue: kAccessTokenTimeOutNotification), object: nil)
        // 监听点击tabBar通知
        NotificationCenter.default.addObserver(self, selector: #selector(tapHomeTabBarBadgeValueAction(notification:)), name: NSNotification.Name(rawValue: kTapHomeTabBarBadgeValueNotification), object: nil)
        // 监听点击cell内图片通知
        NotificationCenter.default.addObserver(self, selector: #selector(showPicturesBrowserAction(notification:)), name: NSNotification.Name(rawValue: kPicturesBrowserNotification), object: nil)
    }
    
    // 设置刷新数量label
    private func setUpRefreshCountLabel() -> Void
    {
        navigationController?.navigationBar.addSubview(refreshCountLabel)
        refreshCountLabel.frame = CGRect(x: 0, y: 0, width: view.width, height: kToolBarHeight)
        navigationController?.navigationBar.sendSubviewToBack(refreshCountLabel)
        refreshCountLabel.isHidden = true
    }
    
    /// 展示刷新数量
    private func showRefreshCountLabel(count:Int) -> Void
    {
        refreshCountLabel.isHidden = false
        refreshCountLabel.text = "刷新到\(count)条微博"
        UIView.animate(withDuration: 1, animations: {
            self.refreshCountLabel.transform = CGAffineTransform(translationX: 0, y: self.refreshCountLabel.height)
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                UIView.animate(withDuration: 1, animations: {
                    self.refreshCountLabel.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    self.refreshCountLabel.isHidden = true
                })
            })
        }
    }
}

