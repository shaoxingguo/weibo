//
//  AppDelegate.swift
//  weibo
//
//  Created by monkey on 2019/1/13.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SVProgressHUD
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = XGTabBarController()//rootViewController()
        window?.makeKeyAndVisible()
        
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
            return XGNewFeatureViewController()
        } else if XGAdvertisementViewModel.sharedViewModel.isNeedShowAdvertisement {
            return XGAdvertisementViewController()
        } else {
            return XGTabBarController()
        }
    }
    
    /// 设置全局外观
    private func setUpAppearance() -> Void
    {
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.9, alpha: 1))
        SVProgressHUD.setMinimumDismissTimeInterval(2)
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
    
    
    /// 初始化设置
    private func initializationSetting() -> Void
    {
        setUpAppearance()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (isSuccess, error) in
            if error != nil || !isSuccess {
                XGPrint("通知授权失败!")
                return
            } else {
                XGPrint("通知授权成功")
            }
        }
    }
}
