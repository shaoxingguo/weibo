//
//  Common.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

func XGPrint(_ item : Any, file : String = #file, lineNum : Int = #line)
{
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("fileName:\(fileName)" + "\t" + "lineNum:\(lineNum)" + "\t" + "\(item)")
    #endif
}


/// 屏幕宽度
public let kScreenWidth:CGFloat = UIScreen.main.bounds.width
/// 屏幕高度
public let kScreenHeight:CGFloat = UIScreen.main.bounds.height

// MARK: - 网络相关
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
/// 请求授权码码接口
public let kAuthorizeCodeAPI:String = "oauth2/authorize"
/// 请求授权令牌接口
public let kAccessTokenAPI:String = "oauth2/access_token"
