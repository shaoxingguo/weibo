//
//  Common.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

// MARK: - 调试相关

func XGPrint(_ item : Any, file : String = #file, lineNum : Int = #line)
{
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("fileName:\(fileName)" + "\t" + "lineNum:\(lineNum)" + "\t" + "\(item)")
    #endif
}

// MARK: - 应用程序相关

/// 屏幕宽度
public let kScreenWidth:CGFloat = UIScreen.main.bounds.width
/// 屏幕高度
public let kScreenHeight:CGFloat = UIScreen.main.bounds.height
/// 屏幕比例
public let kScreenScale:CGFloat = UIScreen.main.scale
/// 导航栏高度
public let kNavigationBarHeight:CGFloat = 44 + kStatusBarHeight
/// tabBar高度
public let kTabBarHeight:CGFloat = 49
/// 工具栏高度
public let kToolBarHeight:CGFloat = 44
/// 状态栏高度
public let kStatusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.size.height
/// 是否是IPhoneX
public let isIPhoneX:Bool = (UIApplication.shared.statusBarFrame.size.height > 20)
/// 底部间距
public let kBottmMargin:CGFloat = (isIPhoneX ? 34 : 0)

/// 沙盒缓存版本对应的key
public let kSandBoxVersionKey:String = "kSandBoxVersionKey"

// MARK: - 界面布局相关

/// 正文字体大小
public let kContentTextFontSize:CGFloat = 15
// 正文字体颜色
public let kContentTextColor:UIColor = UIColor.lightGray
/// 占位图片
public let kPlaceholderImage:UIImage? = UIImage(named: "avatar_default_big")
/// 微博配图外部间距
public let kStatusCellPictureOuterMargin:CGFloat = 12
/// 微博配图内部间距
public let kStatusCellPictureInnerMargin:CGFloat = 3
/// 微博配图视图列数
public let kStatusPicturesViewColumns:Int = 3
/// 配图视图单个图片宽高
public let kStatusPicturesViewItemWidth:CGFloat = ((kScreenWidth - 2 * kStatusCellPictureOuterMargin) - CGFloat(kStatusPicturesViewColumns - 1) * kStatusCellPictureInnerMargin) / CGFloat(kStatusPicturesViewColumns)
/// 配图视图最大宽度
public let kPicturesViewMaxWidth:CGFloat = kScreenWidth - 2 * kStatusCellPictureOuterMargin

// MARK: - 通知相关

/// access_token过期通知
public let kAccessTokenTimeOutNotification:String = "kAccessTokenTimeOutNotification"
/// 点击首页bagdeValue通知
public let kTapHomeTabBarBadgeValueNotification:String = "kTapHomeTabBarBadgeValueNotification"
/// 切换应用程序根控制器通知
public let kSwitchApplicationRootViewControllerNotification:String = "kSwitchApplicationRootViewControllerNotification"
/// 从广告页切换到主界面
public let kFromAdvertisementToMain:String = "kFromAdvertisementToMain"
/// 从新特性切换到主界面
public let kFromNewFeatureToToMain:String = "kFromNewFeatureToToMain"
/// 从欢迎页面切换到主界面
public let kFromWelcomeToMain:String = "kFromWelcomeToToMain"
/// 从登录页面切换到主界面
public let kFromLoginToMain:String = "kFromLoginToMain"
/// 从主界面跳转到登录页面
public let kFromMainToLogin:String = "kFromMainToLogin"
/// 浏览图片通知
public let kPicturesBrowserNotification:String = "kPicturesBrowserNotification"
/// 选中的图片索引
public let kPicturesBrowserSelectedIndexKey:String = "kPicturesBrowserSelectedIndexKey"
/// 浏览的图片数组
public let kPicturesBrowserPicturesKey:String = "kPicturesBrowserPicturesKey"

// MARK: - 微博接口相关

/// 应用程序AppKey
public let kAppKey:String = "2247988996"
/// 应用程序AppSecret
public let kAppSecret:String = "ea0e0c5d1d2fd153a7c68f8d5f97c9a4"
/// 授权回调页
public let kRedirectURLString:String = "https://api.weibo.com/oauth2/default.html"

/// 服务器地址
public let kBaseURLString:String = "https://api.weibo.com/"
/// 广告数据接口
public let kAdvertisementAPI:String = "http://mobads.baidu.com/cpro/ui/mads.php"
/// 请求用户授权码接口
public let kAuthorizeCodeAPI:String = "oauth2/authorize"
/// 获取用户授权的AccessToken接口
public let kAccessTokenAPI:String = "oauth2/access_token"
/// 获取当前登录用户及其所关注（授权）用户的最新微博接口
public let kHomeTimelineAPI:String = "2/statuses/home_timeline.json"
/// 获取某个用户的各种消息未读数接口
public let kUnreadCountAPI:String = "https://rm.api.weibo.com/2/remind/unread_count.json"
/// 获取用户信息接口
public let kUserInfoAPI:String = "2/users/show.json"
/// 获取微博官方表情的详细信息接口
public let kEmotionsAPI:String = "2/emotions.json"
/// 第三方分享一条链接到微博接口
public let kShareAPI:String = "2/statuses/share.json"
