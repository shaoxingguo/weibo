//
//  XGAccountViewModel.swift
//  weibo
//
//  Created by monkey on 2019/1/20.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGAccountViewModel:NSObject
{
    // MARK: - 单例相关
    
    /// 单例
    public static let shared:XGAccountViewModel = XGAccountViewModel()
    
    /// 设置模型数据
    ///
    /// - Parameter accountModel: 数据模型
    open func setAccountModel(accountModel:XGAccountModel?) -> Void
    {
        self.accountModel = accountModel
        // 将用户账号模型保存到文件中
        if accountModel != nil {
            NSKeyedArchiver.archiveRootObject(accountModel!, toFile: modelCachePath)
        }
    }
    
    private override init()
    {
        super.init()
        
        // 从文件读取用户账号模型
        if FileManager.default.fileExists(atPath: modelCachePath) {
            accountModel = NSKeyedUnarchiver.unarchiveObject(withFile: modelCachePath) as? XGAccountModel
        }
    }
    
    // MARK: - 开放方法
    
    /// 用户是否登录
    open var isLogin:Bool {
        if accountModel == nil || isExpires {
            return false
        } else {
            return true
        }
    }
    
    /// 用户授权令牌
    open var accessToken:String? {
        return accountModel?.accessToken
    }
    
    /// 用户ID
    open var uid:String? {
        return accountModel?.uid
    }
    
    private var isExpires:Bool {
        // 现在时间 < 过期时间 ? token未过期 : token过期
        if Date().compare(accountModel?.expiresDate ?? Date()) != ComparisonResult.orderedAscending {
            return true
        } else {
            return false
        }        
    }
    
    // MARK: - 私有属性
    private var accountModel:XGAccountModel?
    
    // MARK: - 懒加载
    private lazy var modelCachePath:String = {
       let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
         return (cachePath as NSString).appendingPathComponent("XGAccountModel.plist")
    }()
}
