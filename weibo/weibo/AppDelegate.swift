//
//  AppDelegate.swift
//  weibo
//
//  Created by monkey on 2019/1/13.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder
{

    var window: UIWindow?
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
        // 停在监测网络状态
        AFNetworkReachabilityManager.shared().stopMonitoring()
    }
}

// MARK: - UIApplicationDelegate
import SDWebImage
extension AppDelegate:UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = XGWelcomeViewController()//rootViewController()
        window?.makeKeyAndVisible()
        XGPrint(NSHomeDirectory())
        initializationSetting()
       
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: - 其他方法
extension AppDelegate
{
    /// 返回根控制器
    private func rootViewController() -> UIViewController
    {
        if isNewVersion {
            // 新版本
            return XGNewFeatureViewController()
        } else if
            // 广告
            XGAdvertisementViewModel.sharedViewModel.isNeedShowAdvertisement {
            return XGAdvertisementViewController()
        } else if XGAccountViewModel.shared.isLogin {
            // 欢迎
            return XGWelcomeViewController()
        } else {
            // 主界面
            return XGTabBarController()
        }
    }
    
    /// 切换应用程序根控制器通知监听
    @objc private func switchApplicationRootViewController(notification:Notification) -> Void
    {
        guard let type = notification.object as? String else {
            return
        }
        
        switch type {
        case kFromAdvertisementToMain:
            XGPrint("广告页切换到主界面")
        case kFromLoginToMain:
            XGPrint("登录切换到主界面")
        case kFromNewFeatureToToMain:
            XGPrint("新特性切换到主界面")
        case kFromWelcomeToMain:
            XGPrint("欢迎切换到主界面")
        default:
            break
        }
        let viewController:UIViewController = XGTabBarController()
        window?.rootViewController = viewController
    }
    /// 初始化设置
    private func initializationSetting() -> Void
    {
        // 设置全局外观
        setUpAppearance()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(switchApplicationRootViewController(notification:)), name: NSNotification.Name(rawValue: kSwitchApplicationRootViewControllerNotification), object: nil)
        
        
        // 开始监测网络状态
        AFNetworkReachabilityManager.shared().startMonitoring()
    }
    
    /// 设置全局外观
    private func setUpAppearance() -> Void
    {
        // 设置 SVProguressHUD 最小解除时间
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.9, alpha: 1))
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        
        // 设置网络指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
    }
    
    /// 是否是新版本
    private var isNewVersion:Bool {
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let cacheVersion = UserDefaults.standard.string(forKey: kSandBoxVersionKey)
        if currentVersion?.compare(cacheVersion ?? "") != ComparisonResult.orderedSame {
            UserDefaults.standard.set(currentVersion, forKey: kSandBoxVersionKey)
            UserDefaults.standard.synchronize()
            return true
        } else {
           return false
        }
    }
}
